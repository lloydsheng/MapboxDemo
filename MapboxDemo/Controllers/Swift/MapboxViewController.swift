//
//  MapboxViewController.swift
//  MapboxDemo
//
//  Created by mapboxchina on 27/02/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import UIKit
import Mapbox

class MapboxViewController: MBDBaseViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    var carAnnotations = [CarPointAnnotation]()
    var hasCarAnnotationAdded = false
    var selectedTitle = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let url = URL(string: "mapbox://styles/mapbox/streets-zh-v1")

        let centerCoordinate = CLLocationCoordinate2D(latitude: 31.22, longitude: 121.48)
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(centerCoordinate, zoomLevel: 14, animated: false)
        mapView.delegate = self
        mapView.scaleBar.isHidden = false
        // make scalebar shows default
        let metersPerPoint = mapView.metersPerPoint(atLatitude: centerCoordinate.latitude);
        mapView.scaleBar.setValue(metersPerPoint, forKey: "metersPerPoint")
        
        self.mapView = mapView;
        view.addSubview(mapView)
        
        let showButton = UIButton(type: .custom)
        showButton.setTitle("Show", for: .normal)
        showButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        showButton.addTarget(self, action: #selector(onShowButtonPress), for: .touchUpInside)
        showButton.frame = CGRect(x: 20, y: view.bounds.size.height - 80, width: 100, height: 40)
        showButton.layer.cornerRadius = 20
        showButton.backgroundColor = UIColor(rgb: 0x325DD2)
        view.addSubview(showButton)
        
        let hideButton = UIButton(type: .custom)
        hideButton.setTitle("Hide", for: .normal)
        hideButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        hideButton.addTarget(self, action: #selector(onHideButtonPress), for: .touchUpInside)
        hideButton.frame = CGRect(x: view.bounds.size.width - 120, y: view.bounds.size.height - 80, width: 100, height: 40)
        hideButton.layer.cornerRadius = 20
        hideButton.backgroundColor = UIColor(rgb: 0x325DD2)
        view.addSubview(hideButton)
        
        let points :  [[Int]] = []
        
//        print("[")
//        for index in 1...points.count {
//            // Random generate some locations in current window
////            let point = CGPoint(x: Int(arc4random_uniform(UInt32(view.bounds.size.width))),
////                    y: Int(arc4random_uniform(UInt32(view.bounds.size.height - 100))));
//            
////            print("[\(point.x),\(point.y)],")
//            
//            let point = CGPoint(x: points[index - 1][0], y: points[index - 1][1])
//            
//            let fromLocation = mapView.convert(point, toCoordinateFrom: view);
////            let fromLocation = mapView.convert(CGPoint(x: 200,
////                                                       y: 200 + index*10),
////                                               toCoordinateFrom: view);
//            let toLocation = mapView.convert(CGPoint(x: Int(arc4random_uniform(UInt32(view.bounds.size.width))),
//                                                     y: Int(arc4random_uniform(UInt32(view.bounds.size.height - 100)))),
//                                             toCoordinateFrom: view);
//            // Add 1/3 yellow car and 2/3 blue car
//            let iconName = index % 3 == 0 ? "car_yellow" : "car_blue"
//            let carModel = CarModel(carID: index,
//                                    fromLocation: fromLocation,
//                                    toLocation: toLocation,
//                                    speed: 0.00002,
//                                    iconName: iconName)
//            let annotation = CarPointAnnotation(carModal: carModel)
//            annotation.title = "\(index)"
//            carAnnotations.append(annotation)
//        }
//        print("]")
//        // Schedule a timer for update annotation
//        let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
//        // Make sure timer tick on all runloop modes
//        RunLoop.current.add(timer, forMode: .commonModes)
    }

    
    // MARK: - Event handle
    @objc func timerTick() {
        // Update all car annotations' location
        for carAnnocation in carAnnotations {
            carAnnocation.updateLocation()
        }
    }
    
    @objc func onShowButtonPress() {
        // Make sure don't add duplicate annotations
        if (hasCarAnnotationAdded) {
            return
        }
        mapView.addAnnotations(carAnnotations)
        hasCarAnnotationAdded = true
    }
    
    @objc func onHideButtonPress() {
        // If has not add annotations, just return
        if (!hasCarAnnotationAdded) {
            return
        }
        mapView.removeAnnotations(carAnnotations);
        hasCarAnnotationAdded = false
    }
    
    func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage {
        let maskRef = maskImage.cgImage
        let mask = CGImage(
            maskWidth: maskRef!.width,
            height: maskRef!.height,
            bitsPerComponent: maskRef!.bitsPerComponent,
            bitsPerPixel: maskRef!.bitsPerPixel,
            bytesPerRow: maskRef!.bytesPerRow,
            provider: maskRef!.dataProvider!,
            decode: nil,
            shouldInterpolate: false)
        
        let masked = image.cgImage!.masking(mask!)
        let maskedImage = UIImage(cgImage: masked!)
        
        // No need to release. Core Foundation objects are automatically memory managed.
        
        return maskedImage
    }
    
    @objc
    func onSnapshotButtonPress()  {
        if let snapshotView = self.mapView {
            UIGraphicsBeginImageContextWithOptions(snapshotView.bounds.size, true, 0.0)
            snapshotView.drawHierarchy(in: snapshotView.bounds, afterScreenUpdates: true)
            let snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            print("\(snapshotImage.debugDescription)")
        }
    }

    
    // MARK: - MGLMapViewDelegate methods
    
    // This delegate method is where you tell the map to load a view for a specific annotation. To load a static MGLAnnotationImage, you would use `-mapView:imageForAnnotation:`.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is MGLPointAnnotation else {
            return nil
        }

        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "\(annotation.coordinate.longitude)"

        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)

        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CustomAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)

            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        annotationView?.annotation = annotation

        return annotationView
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        // 设置
        let index = Int(annotation.title!!)!
//        let identity =  index % 2 == 0 ? "pisavector" : "car_blue"
//        let imageName = index % 2 == 0 ? "pisavector" : "car_blue"
        let identity = "car_blue"
        let imageName = "car_blue"
        
        // 尝试获取可重用 MGLAnnotationImage
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: identity)

        
//        // 预先获取后面需要用到的图片
        let image = UIImage(named: imageName)!
//        let image = index % 2 == 0 ?
//            UIImage(named: "pisavector")!
//        : UIImage(named: "car_blue")!
        
//        print("image = %@", image)
        
        if annotationImage == nil {  // 如果没有可重用 MGLAnnotationImage
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: imageName)
        }
        else {  // 更新重用 MGLAnnotationImage 的图片
//            annotationImage?.image =  image
        }
    
        return annotationImage
    }
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
//        print("111")
//        annotation.title
//        let annotations = NSMutableArray(array: self.mapView.annotations!)
//        self.mapView.removeAnnotations(annotations as! [MGLAnnotation])
//        annotations.removeObject(at: annotations.index(of: annotation))
//        annotations.add(annotation)
////        annotations.insert(annotation, at: 0)
//        self.mapView.addAnnotations(annotations as! [MGLAnnotation])
//        self.mapView.removeAnnotation(annotation)
//        self.mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        mapView.userTrackingMode = .follow
//        let background = style.layers.last as! MGLBackgroundStyleLayer
//        background.backgroundOpacity = NSExpression.init(forConstantValue: 0)
//        print(style.layers.last)
//        let layer = MGLCircleStyleLayer(identifier: "circles", source: population)
//        layer.sourceLayerIdentifier = "population"
//        layer.circleColor = MGLStyleValue(rawValue: .green)
//        layer.circleRadius = MGLStyleValue(interpolationMode: .exponential,
//                                           cameraStops: [12: MGLStyleValue(rawValue: 2),
//                                                         22: MGLStyleValue(rawValue: 180)],
//                                           options: [.interpolationBase: 1.75])
//        layer.circleOpacity = MGLStyleValue(rawValue: 0.7)
//        layer.predicate = NSPredicate(format: "%K == %@", "marital-status", "married")
    }
    
//    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {
//        print("start rendering")
//    }
//
//    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
////        print("finish rendering, fully = \(fullyRendered)")
//    }
//
//    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
//        print("finish rendering frame, fully = \(fullyRendered)")
//    }
    
}


