//
//  MapKitViewController.swift
//  MapboxDemo
//
//  Created by mapboxchina on 28/02/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import UIKit
import MapKit

class MapKitViewController: MBDBaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let mapView = MKMapView(frame: self.view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view .addSubview(mapView)
        mapView.delegate = self
        mapView.userTrackingMode = .followWithHeading
        mapView.showsUserLocation = true
//        mapView.showsScale = true
//        mapView.mapType = .hybrid
        self.mapView = mapView
        
        print("\(mapView.userLocation.coordinate)")
        
        let showButton = UIButton(type: .custom)
        showButton.setTitle("Show", for: .normal)
        showButton.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        showButton.addTarget(self, action: #selector(onShowButtonPress), for: .touchUpInside)
        showButton.frame = CGRect(x: 20, y: view.bounds.size.height - 80, width: 100, height: 40)
        showButton.layer.cornerRadius = 20
        showButton.backgroundColor = UIColor(rgb: 0x325DD2)
        view.addSubview(showButton)
        
//        let center = CLLocationCoordinate2DMake(121.76, 31.05)
        let center = CLLocationCoordinate2DMake(0, 0)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        if !(region.span.latitudeDelta.isNaN || region.span.longitudeDelta.isNaN) {
            self.mapView.setRegion(region, animated: true)
        }
    
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        determineCurrentLocation()
    }
    
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        //manager.stopUpdatingLocation()
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
//        let gcjCenter = MBXGCJShifter.wgs(toCGJ: center)
        
//        let region = MKCoordinateRegion(center: gcjCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
//        mapView.setRegion(region, animated: true)
        
//        if let gcjLocation = userLocation.mbx_gcj() {
//            // Drop a pin at user's Current Location
//            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
//            myAnnotation.coordinate = CLLocationCoordinate2DMake(gcjLocation.coordinate.latitude, gcjLocation.coordinate.longitude);
//            myAnnotation.title = "Current location"
//            mapView.addAnnotation(myAnnotation)
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @objc
    func onShowButtonPress() {
//        locationManager.startUpdatingLocation()
        let center = CLLocationCoordinate2DMake(31.05, 121.76)
//        let center = CLLocationCoordinate2DMake(0, 0)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        self.mapView.setCenter(CLLocationCoordinate2DMake(121.76, 31.05), animated: true)
        self.mapView.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        mapView.setCenter(userLocation.coordinate, animated: true)
    }

}
