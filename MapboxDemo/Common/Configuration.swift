//
//  Configuration.swift
//  MapboxDemo
//
//  Created by mapboxchina on 09/04/2018.
//  Copyright © 2018 lloydsheneg. All rights reserved.
//

import UIKit

enum MapboxMapRegion : String{
    case cn
    case com
}

class Configuration: NSObject {
    
    private static var currentRegion : MapboxMapRegion = .cn
    
    private static func changeConfiguration(token: String, baseURL: URL?) {
        URLCache.shared.removeAllCachedResponses()
        MGLAccountManager.setAccessToken(token)
        let classItem = NSClassFromString("MGLNetworkConfiguration") as! AnyObject
        let selector = NSSelectorFromString("setAPIBaseURL:")
        classItem.perform(selector, with: baseURL)
        let selector1 = NSSelectorFromString("cacheURLIncludingSubdirectory:")
        let path = MGLOfflineStorage.perform(selector1, with: nil) as? NSURL
        
        if let absoluteString = path?.absoluteString, let fileURL = URL(string: absoluteString) {
            do {
                try FileManager.default.removeItem(at: fileURL)
            }
            catch  {
                print("clear cache error")
            }
        }
    }
    
    static func region() -> MapboxMapRegion {
        return currentRegion
    }
    
    static func streetStyleURL() -> URL {
        var url = MGLStyle.streetsStyleURL()
        switch currentRegion {
        case .cn:
            url = MGLStyle.mbcn_streetsChineseStyleURL()
            break
        default:
            break
        }
        return url
    }
    
    static func changeMapbRegin(region: MapboxMapRegion) {
        currentRegion = region
        
        switch region {
        case .cn:
            changeConfiguration(token: DemoConstants.cnToken, baseURL: DemoConstants.cnAPIBaseURL)
            break
        case .com:
            changeConfiguration(token: DemoConstants.comToken, baseURL: DemoConstants.comAPIBaseURL)
        default:
            break
        }
    }

}
