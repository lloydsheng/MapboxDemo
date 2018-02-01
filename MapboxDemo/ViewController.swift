//
//  ViewController.swift
//  MapboxDemo
//
//  Created by Lloyd Sheng on 2018/1/19.
//  Copyright © 2018年 lloydsheng. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView : MGLMapView!
    var carAnnotations = [CarPointAnnotation]()
    var hasCarAnnotationAdded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "mapbox://styles/mapbox/streets-v8")
        self.mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 38.90, longitude: -77.03), zoomLevel: 14, animated: false)
        mapView.delegate = self
        mapView.allowsRotating = false
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
        
        for index in 1...30 {
            // Random generate some locations in current window
            let fromLocation = mapView.convert(CGPoint(x: Int(arc4random_uniform(UInt32(view.bounds.size.width))),
                                                            y: Int(arc4random_uniform(UInt32(view.bounds.size.height - 100)))),
                                                    toCoordinateFrom: view);
            let toLocation = mapView.convert(CGPoint(x: Int(arc4random_uniform(UInt32(view.bounds.size.width))),
                                                              y: Int(arc4random_uniform(UInt32(view.bounds.size.height - 100)))),
                                                      toCoordinateFrom: view);
            // Add 1/3 yellow car and 2/3 blue car
            let iconName = index % 3 == 0 ? "car_yellow" : "car_blue"
            let carModel = CarModel(carID: index,
                                    fromLocation: fromLocation,
                                    toLocation: toLocation,
                                    speed: 0.00002,
                                    iconName: iconName)
            let annotation = CarPointAnnotation(carModal: carModel)
            carAnnotations.append(annotation)
        }
        // Schedule a timer for update annotation
        let timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        // Make sure timer tick on all runloop modes
        RunLoop.current.add(timer, forMode: .commonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    // MARK: - MGLMapViewDelegate
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // Only card point annotation will has custom view
        guard annotation is CarPointAnnotation else {
            return nil
        }
        let carAnnocation = annotation as! CarPointAnnotation
        // Use the card id as the reuse identifier for its view.
        let reuseIdentifier = "\(carAnnocation.carModal.carID)"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = CarAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        }
        let carview = annotationView as? CarAnnotationView
        carview?.iconView.image = UIImage(named: carAnnocation.carModal.iconName)
        carAnnocation.carView = carview
        
        return annotationView
    }
}

