//
//  ReportPacket.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "ReportPacket.h"
#import "GpsData.h"
#import "DataSet.h"
#import "ComUtil.h"
#import <iconv.h>

@interface ReportPacket ()
{
    NSString *mStrEncoding;
    Byte mChrSTX; //Start
    NSString *mStrDataLength;        // 총길이
    NSString *mStrDataCount;        // Body1의 데이터 갯수
    NSString *mStrCommand;        // 전문종류
    NSString *mStrMDN;            // 단말기 MDN
    NSMutableArray<GpsData *> *mListGpsData;
    NSString *mStrDistance;        // 거리
    NSString *mStrCarrierId;        // 운송사ID
    NSString *mStrCarCd;            // 차량ID
    NSString *mStrChassisNo;        // 샤시번호
    NSString *mStrContainerNo1;    // 컨테이너번호1
    NSString *mStrContainerNo2;    // 컨테이너번호2
    NSString *mStrDispatchNo;        // 배차번호
    NSString *mStrMacAddress;        // 맥어드레스
    NSString *mStrOrderType;        // Order Type
    NSString *mStrImportType;        // Import Type
    NSString *mStrSendTerm;        // Send Term
    NSString *mStrCollectTerm;    // Collect Term
    NSString *mStrRestFlag;        // Rest Flag
    Byte     mChrCheckSum;        // Check Sum
    Byte     mChrETX;            // End
}
@end

@implementation ReportPacket

+ (NSInteger)getBodySize {
    return DEF_MOB_BODY_DISTANCE_LENGTH + DEF_MOB_BODY_CARRIER_ID_LENGTH + DEF_MOB_BODY_CAR_CD_LENGTH + DEF_MOB_BODY_CHASSIS_NO_LENGTH
    + DEF_MOB_BODY_CONTAINER_NO_LENGTH + DEF_MOB_BODY_CONTAINER_NO_LENGTH + DEF_MOB_BODY_DISPATCH_NO_LENGTH
    + DEF_MOB_BODY_MAC_ADDRESS_LENGTH + DEF_MOB_BODY_ORDER_TYPE_LENGTH + DEF_MOB_BODY_IMPORT_TYPE_LENGTH + DEF_MOB_BODY_SEND_TERM_LENGTH
    + DEF_MOB_BODY_COLLECT_TERM_LENGTH + DEF_MOB_BODY_REST_FLAG_LENGTH;
}

+ (NSInteger)getHeadSize {
    return (DEF_MOB_HEAD_STX_LENGTH + DEF_MOB_HEAD_DATA_LENGTH_LENGTH + DEF_MOB_HEAD_DATA_COUNT_LENGTH +
    DEF_MOB_HEAD_COMMAND_LENGTH + DEF_MOB_HEAD_MDN_LENGTH);
}

+ (NSInteger)getTailSize {
    return DEF_MOB_TAIL_CHECK_SUM_LENGTH + DEF_MOB_TAIL_ETX_LENGTH;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        mStrEncoding = DEF_STRING_ENCODING_NAME;
        mListGpsData = [NSMutableArray new];
        [self initData];
    }
    return self;
}

- (instancetype)initWithEncoding:(NSString *)strEncoding {
    self = [super init];
    if (self) {
        // 한글 필드가 있을지 몰라 encoding을 받음.
        mStrEncoding = strEncoding;
        mListGpsData = [NSMutableArray new];
        [self initData];
    }
    return self;
}

- (void)initData {
    mChrSTX               = 0x01;
    mStrDataLength        = nil;
    mStrDataCount         = nil;
    mStrCommand           = nil;
    mStrMDN               = nil;

    mStrDistance          = nil;
    mStrCarrierId         = nil;
    mStrCarCd             = nil;
    mStrChassisNo         = nil;
    mStrContainerNo1      = nil;
    mStrContainerNo2      = nil;
    mStrDispatchNo        = nil;

    mStrMacAddress        = nil;

    mStrOrderType         = nil;
    mStrImportType        = nil;
    mStrSendTerm          = nil;
    mStrCollectTerm       = nil;
    mStrRestFlag          = nil;

    mChrCheckSum          = 0x00;
    mChrETX               = 0x02;
}

- (void)clear {
    [self clearGpsData];

    [self initData];
}

- (void)addGpsData:(GpsData *)clsBody {
    if (mListGpsData != nil) {
        if (mListGpsData.count > 98) {
            [mListGpsData removeObjectAtIndex:0];
        }
        
        [mListGpsData addObject:clsBody];
    }
}

- (void)clearGpsData {
    if (mListGpsData != nil) {
        for (int intCnt = 0; intCnt < mListGpsData.count; intCnt++) {
            GpsData *clsData = [mListGpsData objectAtIndex:intCnt];
            if (clsData != nil) {
                [clsData clear];
            }
        }
        
        [mListGpsData removeAllObjects];
    }
}

- (NSData *) getBody {
    NSMutableData * data = [[NSMutableData alloc] init];
//    NSString *str = [NSString stringWithString: [self getBodyText]];
//    NSData *dt = [[NSData alloc] initWithData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    //[data appendData: dt];
    
    const char *a1 = [mStrDistance cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a2 = [mStrCarrierId cStringUsingEncoding:(0x80000000 + 0x0422)];
    //const char *a3 = [mStrCarCd cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a4 = [mStrChassisNo cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a5 = [mStrContainerNo1 cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a6 = [mStrContainerNo2 cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a7 = [mStrDispatchNo cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a8 = [mStrMacAddress cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a9 = [mStrOrderType cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a10 = [mStrImportType cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a11 = [mStrSendTerm cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a12 = [mStrCollectTerm cStringUsingEncoding:(0x80000000 + 0x0422)];
    const char *a13 = [mStrRestFlag cStringUsingEncoding:(0x80000000 + 0x0422)];
    
    NSData *d1  = [[NSData alloc] initWithData:[NSData dataWithBytes:a1 length:strlen(a1)]];
    NSData *d2  = [[NSData alloc] initWithData:[NSData dataWithBytes:a2 length:strlen(a2)]];
    //NSInteger convertedLength = [mStrCarCd lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
    //NSData *d3  = [[NSData alloc] initWithData:[NSData dataWithBytes:a3 length:convertedLength]];
    //차량번호의 한글 인코딩 처리 --> 한글짜씩 분리해서 따로 인코딩해야함 (EUC-KR)
    NSMutableData *d3 = [[NSMutableData alloc] init];
    NSInteger length = mStrCarCd.length;
    NSInteger carCdTotalLength = 0;
    for (NSInteger i=0; i<length; i++) {
        NSString *str = [[mStrCarCd substringFromIndex:i] substringToIndex:1];
        
        NSInteger l = [str lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
        const char *c = [str cStringUsingEncoding:(0x80000000 + 0x0422)];
        NSData *data  = [[NSData alloc] initWithData:[NSData dataWithBytes:c length:l]];
        
        [d3 appendData: data];
        
        carCdTotalLength += l;
    }
    //한글 2바이트 처리 후 남은 자리수 계산 처리
    for (NSInteger i=0; i<DEF_MOB_BODY_CAR_CD_LENGTH-carCdTotalLength; i++) {
        NSString *str = @" ";
        NSInteger l = [str lengthOfBytesUsingEncoding:(0x80000000 + 0x0422)];
        const char *c = [str cStringUsingEncoding:(0x80000000 + 0x0422)];
        NSData *data  = [[NSData alloc] initWithData:[NSData dataWithBytes:c length:l]];
        [d3 appendData: data];
    }
    NSData *d4  = [[NSData alloc] initWithData:[NSData dataWithBytes:a4 length:strlen(a4)]];
    NSData *d5  = [[NSData alloc] initWithData:[NSData dataWithBytes:a5 length:strlen(a5)]];
    NSData *d6  = [[NSData alloc] initWithData:[NSData dataWithBytes:a6 length:strlen(a6)]];
    NSData *d7  = [[NSData alloc] initWithData:[NSData dataWithBytes:a7 length:strlen(a7)]];
    NSData *d8  = [[NSData alloc] initWithData:[NSData dataWithBytes:a8 length:strlen(a8)]];
    NSData *d9  = [[NSData alloc] initWithData:[NSData dataWithBytes:a9 length:strlen(a9)]];
    NSData *d10  = [[NSData alloc] initWithData:[NSData dataWithBytes:a10 length:strlen(a10)]];
    NSData *d11  = [[NSData alloc] initWithData:[NSData dataWithBytes:a11 length:strlen(a11)]];
    NSData *d12  = [[NSData alloc] initWithData:[NSData dataWithBytes:a12 length:strlen(a12)]];
    NSData *d13  = [[NSData alloc] initWithData:[NSData dataWithBytes:a13 length:strlen(a13)]];
    
    [data appendData: d1];
    [data appendData: d2];
    [data appendData: d3];
    [data appendData: d4];
    [data appendData: d5];
    [data appendData: d6];
    [data appendData: d7];
    [data appendData: d8];
    [data appendData: d9];
    [data appendData: d10];
    [data appendData: d11];
    [data appendData: d12];
    [data appendData: d13];
    
    return data;
}

- (NSString *)getBodyText {
    NSString *body = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", mStrDistance, mStrCarrierId, mStrCarCd, mStrChassisNo, mStrContainerNo1, mStrContainerNo2, mStrDispatchNo, mStrMacAddress, mStrOrderType, mStrImportType, mStrSendTerm, mStrCollectTerm, mStrRestFlag];
    
    return body;
}

- (NSArray<GpsData *> *)getGpsData {
    return mListGpsData;
}

- (NSInteger)getGpsDataSize {
    return mListGpsData != nil ? mListGpsData.count : 0;
}

- (NSData *)getHeader {
    
    NSMutableData * data = [[NSMutableData alloc] init];
    NSString *header = @"";
    
    header = [NSString stringWithFormat:@"%@%@%@%@", mStrDataLength, mStrDataCount, mStrCommand, mStrMDN];
    
//    NSData *dt = [[NSData alloc] initWithData:[header dataUsingEncoding:NSUTF8StringEncoding]];
    
    [data appendData: [NSData dataWithBytes: "\x01" length:1]];
    //[data appendData: dt];
    
    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
    const char * source = [header cStringUsingEncoding:encoding];
    NSInteger sourceLen = strlen((const char *)source);
    NSData *data2  = [[NSData alloc] initWithData:[NSData dataWithBytes:source length:sourceLen]];
    [data appendData: data2];
    
    return data;
}

- (NSString *)getHeaderText {
    NSString *header = @"";
    
    header = [NSString stringWithFormat:@"%c%@%@%@%@", (char)mChrSTX, mStrDataLength, mStrDataCount, mStrCommand, mStrMDN];
    
    return header;
}

- (NSData *)getReportPacket {
    int intCnt = 0;
    NSString *strPacket = @"";
    NSString *result = @"";
    
    NSMutableData * data = [[NSMutableData alloc] init];
    
    @try {
        for (intCnt = 0; intCnt < mListGpsData.count; intCnt++) {
            GpsData *clsBody = mListGpsData[intCnt];
            strPacket = [strPacket stringByAppendingString: [clsBody getData]];
        }
        
//        result = [NSString stringWithFormat:@"%@%@%@%@", [self getHeaderText], strPacket, [self getBodyText], [self getTailText]];
        
        NSData *gpsData = [[NSData alloc] initWithData:[strPacket dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
        const char * source = [strPacket cStringUsingEncoding:encoding];
        NSInteger sourceLen = strlen((const char *)source);
        gpsData  = [[NSData alloc] initWithData:[NSData dataWithBytes:source length:sourceLen]];
        
//        [data appendData: dt];
        NSData *header = [self getHeader];
        NSData *body = [self getBody];
        NSData *tail = [self getTail];
        
        [data appendData: header];
        [data appendData: gpsData];
        [data appendData: body];
        [data appendData: tail];
        
        return data;
        
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    return nil;
}

- (NSData *)getTail {
    NSMutableData * data = [[NSMutableData alloc] init];
    [data appendData: [NSData dataWithBytes: "\x00" length:1]];
    [data appendData: [NSData dataWithBytes: "\x02" length:1]];
    return data;
}

- (NSString *)getTailText {
    NSString * tail = [NSString stringWithFormat:@"%c%c", (char)mChrCheckSum, (char)mChrETX];
    return tail;
}


- (void)setBody:(long)lngDistance strCarrierId:(NSString *)strCarrierId strCarCd:(NSString *)strCarCd strChassisNo:(NSString *)strChassisNo strContainerNo1:(NSString *)strContainerNo1 strContainerNo2:(NSString *)strContainerNo2 strDispatchNo:(NSString *)strDispatchNo strMacAddress:(NSString *)strMacAddress strOrderType:(NSString *)strOrderType strImportType:(NSString *)strImportType strSendTerm:(int)strSendTerm strCollectTerm:(int)strCollectTerm strRestType:(NSString *)strRestType {
    
    if (lngDistance >= 0 && lngDistance <= 9999999999L)
    {
        mStrDistance = [NSString stringWithFormat:@"%010ld", lngDistance];
    }
    else
    {
        mStrDistance = [NSString stringWithFormat:@"%010ld", 0L];
    }

    // 빈자리는 스페이스로 채운다.
    if (strCarrierId.length == DEF_MOB_BODY_CARRIER_ID_LENGTH)
    {
        mStrCarrierId = strCarrierId;
    }
    else
    {
        mStrCarrierId = [strCarrierId stringByPaddingToLength:DEF_MOB_BODY_CARRIER_ID_LENGTH withString:@" " startingAtIndex:0];
    }

    //mStrCarCd = [strCarCd stringByPaddingToLength:DEF_MOB_BODY_CAR_CD_LENGTH withString:@" " startingAtIndex:0];
    if (mStrCarCd == nil)
    {
        mStrCarCd = strCarCd;
    } else {
        mStrCarCd = @"            ";
    }

    mStrChassisNo = [strChassisNo stringByPaddingToLength:DEF_MOB_BODY_CHASSIS_NO_LENGTH withString:@" " startingAtIndex:0];
    if (mStrChassisNo == nil)
    {
        mStrChassisNo = strChassisNo;
    }

    mStrContainerNo1 = [strContainerNo1 stringByPaddingToLength:DEF_MOB_BODY_CONTAINER_NO_LENGTH withString:@" " startingAtIndex:0];
    if (mStrContainerNo1 == nil)
    {
        mStrContainerNo1 = strContainerNo1;
    }

    mStrContainerNo2 = [strContainerNo2 stringByPaddingToLength:DEF_MOB_BODY_CONTAINER_NO_LENGTH withString:@" " startingAtIndex:0];
    if (mStrContainerNo2 == nil)
    {
        mStrContainerNo2 = strContainerNo2;
    }

    if (strDispatchNo.length == DEF_MOB_BODY_DISPATCH_NO_LENGTH)
    {
        mStrDispatchNo = strDispatchNo;
    }
    else
    {
        mStrDispatchNo = [strDispatchNo stringByPaddingToLength:DEF_MOB_BODY_DISPATCH_NO_LENGTH withString:@" " startingAtIndex:0];
    }

    if (strMacAddress.length == DEF_MOB_BODY_MAC_ADDRESS_LENGTH)
    {
        mStrMacAddress = strMacAddress;
    }
    else
    {
        mStrMacAddress = [strMacAddress stringByPaddingToLength:DEF_MOB_BODY_MAC_ADDRESS_LENGTH withString:@" " startingAtIndex:0];
    }

    if (strOrderType.length == DEF_MOB_BODY_ORDER_TYPE_LENGTH)
    {
        mStrOrderType = strOrderType;
    }
    else
    {
        mStrOrderType = [strOrderType stringByPaddingToLength:DEF_MOB_BODY_ORDER_TYPE_LENGTH withString:@" " startingAtIndex:0];
    }

    if (strImportType.length == DEF_MOB_BODY_IMPORT_TYPE_LENGTH)
    {
        mStrImportType = strImportType;
    }
    else
    {
        mStrImportType = [strImportType stringByPaddingToLength:DEF_MOB_BODY_IMPORT_TYPE_LENGTH withString:@" " startingAtIndex:0];
    }

    if (strSendTerm >= 0 && strSendTerm <= 9999999999L)
    {
        mStrSendTerm =  [NSString stringWithFormat:@"%05d", strSendTerm];
    }
    else
    {
        mStrSendTerm = [NSString stringWithFormat:@"%05d", 0];
    }

    if (strCollectTerm >= 0 && strCollectTerm <= 9999999999L)
    {
        mStrCollectTerm = [NSString stringWithFormat:@"%05d", strCollectTerm];
    }
    else
    {
        mStrCollectTerm = [NSString stringWithFormat:@"%05d", 0];
    }
    
    if (strRestType != nil && strRestType.length != 0)
    {
        mStrRestFlag = strRestType;
    }
    else
    {
        mStrRestFlag = @"N";
    }
}

- (void)setHeader:(Byte)chrSTX strCommand:(NSString *)strCommand strMDN:(NSString *)strMDN intDataLegth:(int)intDataLegth intDataCount:(int)intDataCount {
    mChrSTX          = chrSTX;
    mStrDataLength   = [NSString stringWithFormat:@"%04d", intDataLegth];
    mStrDataCount    = [NSString stringWithFormat:@"%02d", intDataCount];
    mStrCommand      = strCommand;
    mStrMDN          = [ComUtil stringByPaddingTheLeftToLength:DEF_MOB_HEAD_MDN_LENGTH withString:@"@" startingAtIndex:0 srcString:strMDN];
}

- (void)setTail:(Byte)chrCheckSum chrETX:(Byte)chrETX {
    mChrCheckSum = chrCheckSum;
    mChrETX = chrETX;
}
@end
