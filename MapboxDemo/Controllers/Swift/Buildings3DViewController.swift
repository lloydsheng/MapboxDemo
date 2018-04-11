//
//  Buildings3DViewController.swift
//  MapboxDemo
//
//  Created by mapboxchina on 09/04/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import UIKit

class Buildings3DViewController: MBDBaseViewController , MGLMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        // Set the map style to Mapbox Light Style version 9. The map's source will be queried later in this example.
//        let styleURL =  MGLStyle.lightStyleURL(withVersion: 9)
        
//        Configuration.changeMapbRegin(region: .com)
        let styleURL = Configuration.streetStyleURL()
        let mapView = MGLMapView(frame: view.bounds, styleURL:styleURL)

        
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Center the map view on the Colosseum in Rome, Italy and set the camera's pitch and distance.
        mapView.camera = MGLMapCamera(lookingAtCenter: DemoConstants.peopleSquareCoordinate, fromDistance: 600, pitch: 60, heading: 0)
        mapView.delegate = self
        
        view.addSubview(mapView)
    }
    
    func add3DBuildingsLayer(style: MGLStyle) {
        // Access the Mapbox Streets source and use it to create a `MGLFillExtrusionStyleLayer`. The source identifier is `composite`. Use the `sources` property on a style to verify source identifiers.
        if let source = style.source(withIdentifier: "composite") {
            let layer = MGLFillExtrusionStyleLayer(identifier: "buildings", source: source)
            
            if Configuration.region() == .cn {
                layer.sourceLayerIdentifier = "china_building"
            }
            else {
                layer.sourceLayerIdentifier = "building"
                
                // Filter out buildings that should not extrude.
                layer.predicate = NSPredicate(format: "extrude == 'true' AND height >= 0")
            }

            
            // Set the fill extrusion height to the value for the building height attribute.
            layer.fillExtrusionHeight = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "height", options: nil)
            layer.fillExtrusionBase = MGLStyleValue(interpolationMode: .identity, sourceStops: nil, attributeName: "min_height", options: nil)
            layer.fillExtrusionOpacity = MGLStyleValue(rawValue: 0.75)
            layer.fillExtrusionColor = MGLStyleValue(rawValue: .white)
            
            // Insert the fill extrusion layer below a POI label layer. If you aren’t sure what the layer is called, you can view the style in Mapbox Studio or iterate over the style’s layers property, printing out each layer’s identifier.
            if let symbolLayer = style.layer(withIdentifier: "poi-scalerank3") {
                style.insertLayer(layer, below: symbolLayer)
            } else {
                style.addLayer(layer)
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        self.add3DBuildingsLayer(style: style)
    }
}
