//
//  ReportPacket.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GpsData;

NS_ASSUME_NONNULL_BEGIN

#define DEF_MOB_PACKET_START_OF_TEXT        0x01
#define DEF_MOB_PACKET_END_OF_TEXT          0x02
#define DEF_MOB_COMMAND_DEFAULT             @"RPT"

#define DEF_MOB_HEAD_STX_LENGTH             1
#define DEF_MOB_HEAD_DATA_LENGTH_LENGTH     4
#define DEF_MOB_HEAD_DATA_COUNT_LENGTH      2
#define DEF_MOB_HEAD_COMMAND_LENGTH         3
#define DEF_MOB_HEAD_MDN_LENGTH             13

#define DEF_MOB_BODY_DISTANCE_LENGTH        10
#define DEF_MOB_BODY_CARRIER_ID_LENGTH      15    // 운송사ID 길이
#define DEF_MOB_BODY_CAR_CD_LENGTH          12    // 차량ID 길이
#define DEF_MOB_BODY_CHASSIS_NO_LENGTH      12    // 샤시 길이
#define DEF_MOB_BODY_CONTAINER_NO_LENGTH    12    // 컨테이너번호 길이
#define DEF_MOB_BODY_DISPATCH_NO_LENGTH     20    // 배차번호 길이
#define DEF_MOB_BODY_MAC_ADDRESS_LENGTH     12    // 맥어드레스 길이
#define DEF_MOB_BODY_ORDER_TYPE_LENGTH      3    // ORDER TYPE 길이
#define DEF_MOB_BODY_IMPORT_TYPE_LENGTH     1    // IMPORT TYPE 길이
#define DEF_MOB_BODY_SEND_TERM_LENGTH       5    // SEND TERM 길이
#define DEF_MOB_BODY_COLLECT_TERM_LENGTH    5    // COLLECT TERM 길이
#define DEF_MOB_BODY_REST_FLAG_LENGTH       1    // REST FLAG 길이

#define DEF_MOB_TAIL_CHECK_SUM_LENGTH       1
#define DEF_MOB_TAIL_ETX_LENGTH             1

@interface ReportPacket : NSObject
+ (NSInteger)getBodySize;
+ (NSInteger)getHeadSize;
+ (NSInteger)getTailSize;

- (instancetype)initWithEncoding:(NSString *)strEncoding;
- (void)clear;
- (void)addGpsData:(GpsData *)clsBody;
- (void)clearGpsData;
- (NSArray<GpsData *> *)getGpsData;
- (NSInteger)getGpsDataSize;
- (NSData *)getHeader;
- (NSData *) getBody;
- (NSData *)getReportPacket;
- (void)setBody:(long)lngDistance strCarrierId:(NSString *)strCarrierId strCarCd:(NSString *)strCarCd strChassisNo:(NSString *)strChassisNo strContainerNo1:(NSString *)strContainerNo1 strContainerNo2:(NSString *)strContainerNo2 strDispatchNo:(NSString *)strDispatchNo strMacAddress:(NSString *)strMacAddress strOrderType:(NSString *)strOrderType strImportType:(NSString *)strImportType strSendTerm:(int)strSendTerm strCollectTerm:(int)strCollectTerm strRestType:(NSString *)strRestType;
- (void)setHeader:(Byte)chrSTX strCommand:(NSString *)strCommand strMDN:(NSString *)strMDN intDataLegth:(int)intDataLegth intDataCount:(int)intDataCount;
- (void)setTail:(Byte)chrCheckSum chrETX:(Byte)chrETX;
@end

NS_ASSUME_NONNULL_END
