//
//  EtransLocationManager.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/26.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface EtransLocationManager : NSObject

@property(strong, nonatomic) CLLocationManager *locationManager;
@property CGFloat latitude;
@property CGFloat longitude;
@property BOOL isOnBluetooth;

+ (instancetype)sharedInstance;

- (void)startLocationManager;
- (void)stopLocationManager;
- (void)startBeaconScan;
- (void)stopBeaconScan;
@end

NS_ASSUME_NONNULL_END
