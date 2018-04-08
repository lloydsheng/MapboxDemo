//
//  CLLocation+GCJ.m
//  LocationShiftDemo
//
//  Created by mapboxchina on 24/02/2018.
//  Copyright © 2018 mapboxchina. All rights reserved.
//

#import "MBXGCJShifter.h"

#import "MBXCLLocation+GCJ.h"

@implementation CLLocation (MBXGCJ)

- (CLLocation *)mbx_gcjLocation {
    CLLocationCoordinate2D coordinate = [MBXGCJShifter wgsToCGJ:self.coordinate];

    return [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
}

@end
