//
//  GpsInfo.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "GpsInfo.h"
#import <CoreLocation/CoreLocation.h>

@interface GpsInfo()
{
    int mGpsStatus;
    BOOL mIsUpdate;
    NSMutableArray<CLLocation *> *mLocationArrayList;
}
@end

@implementation GpsInfo

+ (instancetype)sharedInstance {
    static GpsInfo *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[GpsInfo alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        mLocationArrayList = [NSMutableArray new];
    }
    return self;
}

- (NSInteger)getArrayListSize {
    return mLocationArrayList == nil ? 0 : mLocationArrayList.count;
}

- (void)setLocation:(CLLocation *)location {
    if (location != nil) {
        NSInteger size = mLocationArrayList.count;
        if (size > 1) {
            for (int i = 0; i < size-1; i++) {
                [mLocationArrayList removeObjectAtIndex:0];
            }
        }
        
        [mLocationArrayList addObject:location];
    }
}

- (CLLocation *)getLocation {
    CLLocation *location = nil;
    
    if (mLocationArrayList != nil) {
        NSInteger size = mLocationArrayList.count;
        if (size > 0) {
            location = [mLocationArrayList objectAtIndex:0];
            [mLocationArrayList removeObjectAtIndex:0];
        }
    }
    
    return location;
}
@end
