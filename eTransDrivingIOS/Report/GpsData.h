//
//  GpsData.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define DEF_MOB_DATE_LENGTH          6
#define DEF_MOB_TIME_LENGTH          6
#define DEF_MOB_GPS_STATUS_LENGTH    1
#define DEF_MOB_LATITUDE_LENGTH      9
#define DEF_MOB_LONGITUDE_LENGTH     9
#define DEF_MOB_SPEED_LENGTH         3
#define DEF_MOB_DIRECTION_LENGTH     3
#define DEF_MOB_EVENT_CODE_LENGTH    2

@interface GpsData : NSObject

+ (NSInteger)getGpsDataSize;
- (void)clear;
- (NSString *)getData;
- (void)setData:(NSString *)strDateTime gpsStatus:(char)chrGpsStatus lat:(double)dblLat lon:(double)dblLon speed:(short)shtSpeed direction:(short)shtDir eventCode:(NSString *)strEventCode;
@end

NS_ASSUME_NONNULL_END
