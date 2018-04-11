//
//  CameraAnimationViewController.swift
//  MapboxDemo
//
//  Created by mapboxchina on 11/04/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import Foundation


class CameraAnimationViewController: MBDBaseViewController, MGLMapViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.delegate = self
        
        mapView.styleURL = MGLStyle.outdoorsStyleURL();
        
        // Mauna Kea, Hawaii
        let center = CLLocationCoordinate2D(latitude: 19.820689, longitude: -155.468038)
        
        // Optionally set a starting point.
        mapView.setCenter(center, zoomLevel: 7, direction: 0, animated: false)
        
        view.addSubview(mapView)
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        // Wait for the map to load before initiating the first camera movement.
        
        // Create a camera that rotates around the same center point, rotating 180°.
        // `fromDistance:` is meters above mean sea level that an eye would have to be in order to see what the map view is showing.
        let camera = MGLMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: 4500, pitch: 15, heading: 180)
        
        // Animate the camera movement over 5 seconds.
        mapView.setCamera(camera, withDuration: 5, animationTimingFunction: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut))
    }
}
