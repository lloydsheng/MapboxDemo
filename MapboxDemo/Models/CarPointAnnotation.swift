//
//  CarPointAnnotation.swift
//  MapboxDemo
//
//  Created by Lloyd Sheng on 2018/1/20.
//  Copyright © 2018年 lloydsheng. All rights reserved.
//

import UIKit
import Mapbox

class CarPointAnnotation : MGLPointAnnotation {
    var carView : CarAnnotationView?
    var carModal : CarModel!
    var animating = false
    
    init(carModal: CarModel) {
        super.init()
        self.carModal = carModal
        self.coordinate = carModal.getCurrentLocation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateLocation() {
        guard carView != nil else {
            return
        }
        if (animating) {
            return
        }
        
        let transform = CGAffineTransform(rotationAngle: -self.carModal.getCurrentAngle() + CGFloat(Double.pi))
        // If the car is changing direction stop update location
        if (self.carView?.transform != transform) {
            self.animating = true
            UIView.animate(withDuration: 0.5, animations: {
                self.carView?.transform = transform
            }, completion: { (finished) in
                self.animating = false
            })
        }
        else {
            self.coordinate = self.carModal.getCurrentLocation()
        }
    }
}
