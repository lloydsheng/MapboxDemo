//
//  GCJShifter.m
//  LocationShiftDemo
//
//  Created by mapboxchina on 24/02/2018.
//  Copyright © 2018 mapboxchina. All rights reserved.
//

#import "MBXGCJShifter.h"

#import "shift.h"

static float const kGCJConstant = 3686400.0f;

@implementation MBXGCJShifter

+ (CLLocationCoordinate2D)wgsToCGJ:(CLLocationCoordinate2D)wgsCoordinate {
    uint originalIntLongitude = (uint)(wgsCoordinate.longitude * kGCJConstant);
    uint originalIntLatitude = (uint)(wgsCoordinate.latitude * kGCJConstant);
    uint shiftedIntLongitude = 0;
    uint shiftedIntLatitude = 0;
    // convert WGS-84 coodinate to GCJ-02 coodinate
    wgtochina_lb(1, originalIntLongitude, originalIntLatitude, 0, 0, 0, &shiftedIntLongitude, &shiftedIntLatitude);
    // Longitude and latitude both equal to 0 if the coordinate is outside china, failback to WGS coodinate
    if (shiftedIntLongitude == 0 && shiftedIntLatitude == 0) {
        return wgsCoordinate;
    }

    return CLLocationCoordinate2DMake(shiftedIntLatitude / kGCJConstant, shiftedIntLongitude / kGCJConstant);
}

@end
