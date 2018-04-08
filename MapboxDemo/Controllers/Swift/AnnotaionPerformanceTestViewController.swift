import UIKit
import Mapbox

class CustomPointAnnotation : MGLPointAnnotation {

}

class IconAnnotationView: MGLAnnotationView {
    
    var iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundColor = nil
        self.addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AnnotaionPerformanceTestViewController: MBDBaseViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    var carAnnotations = [CustomPointAnnotation]()
    var hasCarAnnotationAdded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let url = URL(string: "mapbox://styles/mapbox/streets-zh-v1")
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: 35.7094109, longitude: 139.774723)
        let mapView = MGLMapView(frame: view.bounds, styleURL: url)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(centerCoordinate, zoomLevel: 14, animated: false)
        self.mapView = mapView;
        self.mapView.delegate = self
        view.addSubview(mapView)
        
        do {
            let path = Bundle.main.path(forResource: "positions", ofType: "json")
            let positionsData = NSData(contentsOf: URL(fileURLWithPath: path!))
            let points = try JSONSerialization.jsonObject(with: positionsData as Data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [[Int]]
            for index in 1...points.count {
                let point = CGPoint(x: points[index - 1][0], y: points[index - 1][1])
                let location = mapView.convert(point, toCoordinateFrom: view);
                let annotation = CustomPointAnnotation();
                annotation.title = "annotaion - \(index)"
                annotation.coordinate = location
                carAnnotations.append(annotation)
            }
        }
        catch  {
            
        }
        
        let timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
    }
    
    // MARK: - Event handle
    @objc func timerTick() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 35.7094109, longitude: 139.774723)
        let zoomLevel = mapView.zoomLevel == 16.0 ? 14.0 : 16.0
        mapView.setCenter(centerCoordinate, zoomLevel: zoomLevel, animated: true)
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        // This example is only concerned with point annotations.
        guard annotation is CustomPointAnnotation else {
            return nil
        }
        
        // Use the point annotation’s longitude value (as a string) as the reuse identifier for its view.
        let reuseIdentifier = "view_annotations"
        
        // For better performance, always try to reuse existing annotations.
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        // If there’s no reusable annotation view available, initialize a new one.
        if annotationView == nil {
            annotationView = IconAnnotationView(reuseIdentifier: reuseIdentifier)
            annotationView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            
            // Set the annotation view’s background color to a value determined by its longitude.
            let hue = CGFloat(annotation.coordinate.longitude) / 100
            annotationView!.backgroundColor = UIColor(hue: hue, saturation: 0.5, brightness: 1, alpha: 1)
        }
        let iconAnnotation = annotationView as! IconAnnotationView
        iconAnnotation.iconView.image = UIImage(named: "car_blue")
        iconAnnotation.backgroundColor = nil
        
        return annotationView
    }

    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {
        if (hasCarAnnotationAdded) {
            return
        }
        mapView.addAnnotations(carAnnotations)
        hasCarAnnotationAdded = true
    }
}
