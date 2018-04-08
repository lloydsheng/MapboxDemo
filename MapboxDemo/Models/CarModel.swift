//
//  CarModel.swift
//  MapboxDemo
//
//  Created by Lloyd Sheng on 2018/1/20.
//  Copyright © 2018年 lloydsheng. All rights reserved.
//

import UIKit
import CoreLocation

enum CarDirection {
    // from location => to location
    case come
    // to locaton => from location
    case back
}

/*
 A class for store car data and simulation location change
*/
class CarModel {
    
    var carID : Int!
    
    // Just the initial location of car
    private var fromLocation : CLLocationCoordinate2D!
    // Just where the car to
    private var toLocation : CLLocationCoordinate2D!
    // The angle of car icon view transform
    private var angle : CGFloat!
    // Current location of car
    private var location : CLLocationCoordinate2D!
    // Current directionof car
    private var direction : CarDirection!
    // Car speed
    private var speed : CGFloat
    
    var iconName : String
    
    init(carID: Int, fromLocation: CLLocationCoordinate2D, toLocation: CLLocationCoordinate2D, speed: CGFloat, iconName: String) {
        self.carID = carID
        self.fromLocation = fromLocation
        self.toLocation = toLocation
        self.location = self.fromLocation
        self.direction = .come
        self.angle = self.fromLocation.angle(to: self.toLocation)
        self.speed = speed
        self.iconName = iconName
    }
    
    private func changeDirection() {
        if (direction == .come) {
            direction = .back
        }
        else {
            direction = .come
        }
    }
    
    /*
     Calculate car location with speed and angle
    */
    func getCurrentLocation() -> CLLocationCoordinate2D {
        // If the car has no speed, just stop at original location
        guard speed > 0 else {
            return location
        }
        
        let angle = self.getCurrentAngle();
        let deltaLongitude = speed*cos(angle)
        let deltaLatitude = speed*sin(angle)
        let nextLocation = CLLocationCoordinate2D(latitude: location.latitude + Double(deltaLatitude),
                                                  longitude: location.longitude + Double(deltaLongitude))
        let startLocation = direction == .come ? fromLocation : toLocation;
        let currentDistance = startLocation!.distance(from: nextLocation)
        let maxDistance = fromLocation.distance(from: toLocation)
        if (currentDistance >= maxDistance) {
            self.changeDirection()
        }
        else {
            location = nextLocation
        }
        
        return location
    }
    
    /*
     Calculate car icon transform angle with direction and location
    */
    func getCurrentAngle() -> CGFloat {
        var angle : CGFloat
        if (direction == .come) {
            angle = fromLocation.angle(to: toLocation)
        }
        else {
            angle = toLocation.angle(to: fromLocation)
        }
        return angle/CGFloat(180.0 / Double.pi)
    }
}
