//
//  GpsData.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "GpsData.h"

@interface GpsData()
{
    char mChrGPSStatus; // GPS상태 ('A':GPS Active / 'V':GPS Invalid(마지막 GPS Active 값을전송)
    NSString * mStrDateTime;    // 날짜시간 (YYMMDDHHMMSS)
    NSString * mStrLatitude;    // 위도
    NSString * mStrLongitude;    // 경도
    NSString * mStrSpeed;        // 속도
    NSString * mStrDirection;    // 방향
    NSString * mStrEventCode;    // 이벤트코드
}
@end

@implementation GpsData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self clear];
    }
    return self;
}

+ (NSInteger)getGpsDataSize {
    return (DEF_MOB_DATE_LENGTH + DEF_MOB_TIME_LENGTH + DEF_MOB_GPS_STATUS_LENGTH + DEF_MOB_LATITUDE_LENGTH +
    DEF_MOB_LONGITUDE_LENGTH + DEF_MOB_SPEED_LENGTH + DEF_MOB_DIRECTION_LENGTH + DEF_MOB_EVENT_CODE_LENGTH);
}

- (void)clear {
    mChrGPSStatus = 0x00;
    mStrDateTime = nil;
    mStrLatitude = nil;
    mStrLatitude = nil;
    mStrSpeed = nil;
    mStrDirection = nil;
    mStrEventCode = nil;
}

- (NSString *)getData {
    NSString *data = [NSString stringWithFormat:@"%@%c%@%@%@%@%@", mStrDateTime, mChrGPSStatus, mStrLatitude, mStrLongitude, mStrSpeed, mStrDirection, mStrEventCode];
    return data;
}

- (void)setData:(NSString *)strDateTime gpsStatus:(char)chrGpsStatus lat:(double)dblLat lon:(double)dblLon speed:(short)shtSpeed direction:(short)shtDir eventCode:(NSString *)strEventCode {
    mStrDateTime    = strDateTime;
    mChrGPSStatus    = chrGpsStatus;
    mStrLatitude    =  [NSString stringWithFormat:@"%09.5f", dblLat];
    mStrLongitude    = [NSString stringWithFormat:@"%09.5f", dblLon];
    mStrSpeed        = [NSString stringWithFormat:@"%03d", shtSpeed];
    mStrDirection    = [NSString stringWithFormat:@"%03d", shtDir];;    // 0~359

    // 00: NONE
    if ([strEventCode isEqualToString:@""])
    {
        mStrEventCode = @"00";
    } else {
        mStrEventCode = strEventCode;
    }
}


@end
