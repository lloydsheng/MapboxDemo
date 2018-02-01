//
//  CarAnnotationView.swift
//  MapboxDemo
//
//  Created by Lloyd Sheng on 2018/1/20.
//  Copyright © 2018年 lloydsheng. All rights reserved.
//

import UIKit
import Mapbox

/*
 A class as subclass of MGLAnnotationView, for custom annotation icon
 */
class CarAnnotationView: MGLAnnotationView {
    
    var iconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addSubview(iconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
