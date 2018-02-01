//
//  Extensions.swift
//  MapboxDemo
//
//  Created by Lloyd Sheng on 2018/1/20.
//  Copyright © 2018年 lloydsheng. All rights reserved.
//

import UIKit
import CoreLocation

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension CLLocationCoordinate2D {
    func angle(to comparisonPoint: CLLocationCoordinate2D) -> CGFloat {
        let originX = comparisonPoint.longitude - self.longitude
        let originY = comparisonPoint.latitude - self.latitude
        let bearingRadians = atan2f(Float(originY), Float(originX))
        var bearingDegrees = CGFloat(bearingRadians) * CGFloat(180.0 / Double.pi)
        while bearingDegrees < 0 {
            bearingDegrees += 360
        }
        return bearingDegrees
    }
    
    func distance(from point: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: point.latitude, longitude: point.longitude)
        let to = CLLocation(latitude: self.latitude, longitude: self.longitude)
        return from.distance(from: to);
    }
}
