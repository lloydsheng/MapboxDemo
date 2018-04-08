//
//  GCJShifter.h
//  LocationShiftDemo
//
//  Created by mapboxchina on 24/02/2018.
//  Copyright © 2018 mapboxchina. All rights reserved.
//

#import <corelocation/CLLocation.h>

@interface MBXGCJShifter : NSObject

+ (CLLocationCoordinate2D)wgsToCGJ:(CLLocationCoordinate2D)coordinate;

@end
