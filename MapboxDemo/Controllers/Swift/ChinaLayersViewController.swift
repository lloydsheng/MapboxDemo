import UIKit
import Mapbox



class ChinaLayersTestViewController: MBDBaseViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    var carAnnotations = [CustomPointAnnotation]()
    var hasCarAnnotationAdded = false
    var viewDidLoadAt : TimeInterval = 0
    var styleLoadFinishedaAt : TimeInterval = 0
    var renderingFinishedAt : TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        let url = URL(string: "mapbox://styles/mapbox/streets-v10")
        let url = URL(string: "mapbox://styles/mapbox/streets-zh-v1")
        let centerCoordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: 116.4)
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(centerCoordinate, zoomLevel: 12, animated: false)
        self.mapView = mapView;
        self.mapView.delegate = self
        view.addSubview(mapView)
        
        
        print("=================")
        
        viewDidLoadAt = NSDate().timeIntervalSince1970
        
//        let font = UIFont(name: "PingFang SC", size: 10)
//        print("font = \(font)")
//        print("viewDidLoad at: \(NSDate().timeIntervalSince1970)")
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
//        mapView.attributionButton.isHidden = true
//        print("layers count = \(style.layers.count)")
//        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 4500, pitch: 15, heading: 180)
//        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
//      print("didFinishLoading at: \(NSDate().timeIntervalSince1970)")
        styleLoadFinishedaAt = NSDate().timeIntervalSince1970
        print("load style used time: \(styleLoadFinishedaAt - viewDidLoadAt)")
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
//        print("mapViewDidFinishRenderingMap at: \(NSDate().timeIntervalSince1970)")
        renderingFinishedAt = NSDate().timeIntervalSince1970
        print("rendering used time: \(renderingFinishedAt - styleLoadFinishedaAt)")
        print("=================")
    }
    
    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {
        
    }
}
