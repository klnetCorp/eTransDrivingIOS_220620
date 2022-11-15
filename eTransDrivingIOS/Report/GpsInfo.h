//
//  GpsInfo.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface GpsInfo : NSObject
+ (instancetype)sharedInstance;
- (NSInteger)getArrayListSize;
- (void)setLocation:(CLLocation *)location;
- (CLLocation *)getLocation;
@end

NS_ASSUME_NONNULL_END
