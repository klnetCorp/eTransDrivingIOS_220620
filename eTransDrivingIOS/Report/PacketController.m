//
//  PacketController.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "PacketController.h"
#import "ReportPacket.h"
#import "GpsData.h"
#import "GpsInfo.h"
#import "Preference.h"
#import "ComUtil.h"
#import <CoreLocation/CoreLocation.h>

@interface PacketController ()
{
    ReportPacket *mClsReportPacket;
    double mLongitude;
    double mLatitude;
    long   mLngDistance;
    CLLocation *mLocation;
    
    Preference *preference;
}
@end

@implementation PacketController

- (instancetype)init
{
    self = [super init];
    if (self) {
        mClsReportPacket = [[ReportPacket alloc] init];
        preference = [Preference new];
    }
    return self;
}

- (void)clearPacket {
    [mClsReportPacket clear];
}

- (NSInteger)getGpsDataSize {
    return [mClsReportPacket getGpsDataSize];
}

- (NSData *)makePacket {
    NSInteger         intCnt                = 0;
    NSInteger         intDataCount         = 0;
    NSInteger         intDataLength        = 0;
    Byte        bytCheckSum          = 0x00;
    NSData      *bbSendBuffer        = nil;

    NSString *strCarrierId     = @"";
    NSString *strVehId         = @"";
    NSString *strChassisNo     = @"";
    NSString *strContainerNo1  = @"";
    NSString *strContainerNo2  = @"";
    NSString *strDispatchNo    = @"";
    NSString *strMacAddress    = @"";

    NSString *strOrderType     = @"100";
    NSString *strImportType    = @"O";
    int    strSendTerm         = 0;
    int    strCollectTerm      = 0;
    NSString *strRestFlag      = @"N";
    
    @try {
        // -------------------------------------------------------------
        // 헤더
        // -------------------------------------------------------------
        intDataCount = [mClsReportPacket getGpsDataSize];
        
        intDataLength = [ReportPacket getHeadSize] + ([GpsData getGpsDataSize] * intDataCount) + [ReportPacket getBodySize] + [ReportPacket getTailSize];
        
        [mClsReportPacket setHeader:DEF_MOB_PACKET_START_OF_TEXT strCommand:DEF_MOB_COMMAND_DEFAULT strMDN:[preference getAuthPhoneNo] intDataLegth:(int)intDataLength intDataCount:(int)intDataCount];
        
        // -------------------------------------------------------------
        // Body
        // -------------------------------------------------------------
        strCarrierId = [preference getCarrierId];
        if ([strCarrierId isEqualToString:@""]) {
            strCarrierId = @"0"; // 0번
            [preference setCarrierId:strCarrierId];
        }
        
        NSString *carCd = [preference getCarCd];
        strVehId = carCd; //carCd; //[ComUtil euckrEncodingObjectiveC:carCd];

        strMacAddress = [ComUtil getMacAddress];
        strChassisNo = [preference getChassisNo];
        if ([strChassisNo isEqualToString:@"샷시없음"]) {
            strChassisNo = @"";
            [preference setChassisNo:strChassisNo];
        }
        strContainerNo1 = [preference getContainerNo1];
        strContainerNo2 = [preference getContainerNo2];
        strDispatchNo = [preference getDispatchNo];
        if ([strDispatchNo isEqualToString:@"null"] || [strDispatchNo isEqualToString:@"NULL"]) {
            strDispatchNo = @" ";
            [preference setDispatchNo:strDispatchNo];
        }
        strOrderType = [preference getOrderType];
        strImportType = [preference getImportType];
        strRestFlag = [preference getRestFlag];
        strSendTerm = [preference getReportPeroid].intValue;
        strCollectTerm = [preference getCreationPeroid].intValue;
        
        [mClsReportPacket setBody:mLngDistance*100 strCarrierId:strCarrierId strCarCd:strVehId strChassisNo:strChassisNo strContainerNo1:strContainerNo1 strContainerNo2:strContainerNo2 strDispatchNo:strDispatchNo strMacAddress:strMacAddress strOrderType:strOrderType strImportType:strImportType strSendTerm:strSendTerm strCollectTerm:strCollectTerm strRestType:strRestFlag];
        
        mLngDistance = 0;
        
        // -------------------------------------------------------------
        // 테일
        // -------------------------------------------------------------
        // CheckSum
        for (intCnt = 0; intCnt < intDataCount; intCnt++) {
            GpsData *clsGpsData = [mClsReportPacket getGpsData][intCnt];
            NSData *arbGpsData = [[clsGpsData getData] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSUInteger len = [arbGpsData length];
            Byte *byteData = (Byte*)malloc(len);
            memcpy(byteData, [arbGpsData bytes], len);
            
            for (int intLoopCnt = 0; intLoopCnt < arbGpsData.length; intLoopCnt++)
            {
                bytCheckSum = (char) (bytCheckSum ^ byteData[intLoopCnt]);
            }
        }
        
        NSData *arbBody = [mClsReportPacket getBody];
        
        NSUInteger len = [arbBody length];
        Byte *byteData = (Byte*)malloc(len);
        memcpy(byteData, [arbBody bytes], len);
        
        for (intCnt = 0; intCnt < arbBody.length; intCnt++)
        {
            bytCheckSum = (Byte) (bytCheckSum ^ byteData[intCnt]);
        }
        
        [mClsReportPacket setTail:bytCheckSum chrETX:DEF_MOB_PACKET_END_OF_TEXT];
        // -------------------------------------------------------------
        bbSendBuffer = [mClsReportPacket getReportPacket];
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return bbSendBuffer;
}

/**
* GPS Data를 생성하여 PeriodReportPacket 클래스에 계속 추가한다.
*
* param strEventCode
* return 0: succcess, -1:전송할GPS데이터가 없음, -2:저장된GPS데이터가 비정상
*/
- (NSInteger)makePeriodReportGpsData:(NSString *)strEventCode {
    double    longitude        = 0;
    double    latitude        = 0;
    float    speed            = 0;
    float    bearing            = 0;
    short    shrSpeed        = 0;
    short    shtDirection    = 0;
    NSString *provider        = @"";
    char    chrGpsStatus    = 'G'; // ‘G’ : GPS Active / 'N' : Network Active / ‘I’ : Provider Invalid
    GpsData   *clsGpsData        = nil;
    CLLocation *location        = nil;
    
    @try {
        
        GpsInfo * gpsInfo = [GpsInfo sharedInstance];
        NSInteger size = [gpsInfo getArrayListSize];
        if (size <= 0) {
            if (location == nil) {
                //
            }
        }
        
        clsGpsData = [GpsData new];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyMMddHHmmss"];
        NSString *strCurDateTime = [dateFormatter stringFromDate:[NSDate date]];
        
        location = [gpsInfo getLocation];
        if (location == nil) {
            longitude    = 0;
            latitude    = 0;
            speed        = 0;
            bearing        = 0;
            provider    = @"I";
            return -2;
        } else {
            longitude = location.coordinate.longitude;
            latitude = location.coordinate.latitude;
            speed = location.speed;
            bearing = location.course;
            provider = @"G";
        }
        
        chrGpsStatus = 'G';
        
        // 거리 누적 : 이전좌표와 현재좌표를 이용하여 거리 계산하여 누적 한 다음 패킷 전송후 초기화 한다.
        if (longitude > 0 && latitude > 0) {
            if (mLongitude > 0 && mLatitude > 0)
            {
                CLLocationDistance distance = [mLocation distanceFromLocation:location];
                mLngDistance += +distance;
            }
            else
            {
                mLngDistance = 0;
            }

            // 이전거리와 현재거리를 비교하기 위해, 현재 위치를 백업한다.
            mLongitude = longitude;
            mLatitude = latitude;
            mLocation = location;

            shrSpeed = (short) (speed < 0 ? 0 : speed * 3.6);
            shtDirection = (short) bearing;
        }
        
        if (longitude <= 0 || latitude <= 0)
        {
            longitude = 000.00000; // Default
            latitude = 000.00000; // Default
            chrGpsStatus = 'I'; // GPS 수신 못함
        }
        
        // 이벤트 코드가 없다면 Preference 변수에서 찾는다.
        if ([strEventCode isEqualToString:@""])
        {
            strEventCode = [preference getEventCode];
        }
        
        //마지막 GPS 정보 저장하기 13.10.25 황용민
        NSString *lastGpsData = [NSString stringWithFormat:@"%@%c%f%f%hd%hd", strCurDateTime, chrGpsStatus, latitude, longitude, shrSpeed, shtDirection];
        [preference setLastGps:lastGpsData];
        
        [clsGpsData setData:strCurDateTime gpsStatus:chrGpsStatus lat:latitude lon:longitude speed:speed direction:shtDirection eventCode:strEventCode];
        
        NSLog(@"lastGpsData = %@", lastGpsData);
        
        // -----------------------------------------------------
        // 생성주기시 만들어진 패킷의 GPSData를 보고주기관련 클래스에 추가한다.
        // -----------------------------------------------------
        [mClsReportPacket addGpsData:clsGpsData];
        // -----------------------------------------------------

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return 0;
}
@end
