//
//  ReportServiceManager.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/26.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "ReportServiceManager.h"
#import "PacketController.h"
#import "Preference.h"
#import "EtransLocationManager.h"

@interface ReportServiceManager ()
{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    PacketController *mClsPacketController;
    
    NSDate *_lastTimestamp;
    NSDate *_lastTimestamp2;
    
    NSTimer *_timer;
    NSInteger mIntCreationPeroid;
    NSInteger mIntReportPeroid;
    
    Preference *_preference;
}
@end

@implementation ReportServiceManager

+ (instancetype)sharedInstance {
    static ReportServiceManager *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[ReportServiceManager alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        mClsPacketController = [[PacketController alloc] init];
        _preference = [[Preference alloc] init];
        _lastTimestamp = [NSDate date];
        _lastTimestamp2 = [NSDate date];
    }
    return self;
}

- (void)startReportService {
     _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandler:) userInfo:nil repeats:YES];
}

- (void)stopReportService {
    [_timer invalidate];
}

- (void)initNetworkCommunication
{
    CFReadStreamRef readStream; CFWriteStreamRef writeStream;
//    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.219.100", 10001, &readStream, &writeStream);
    
//REAL LBS
//    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"203.236.120.62", 14200, &readStream, &writeStream);
//DEV LBS (smartest : smart to mfedi)
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"203.236.120.62", 14666, &readStream, &writeStream);
    
    inputStream = (__bridge NSInputStream *)readStream;
    outputStream = (__bridge NSOutputStream *)writeStream;
    [inputStream setDelegate:self]; [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)sendPacket {
    if (outputStream == nil) {
        [self initNetworkCommunication];
    }
    
    NSData *data = [mClsPacketController makePacket];
    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
    NSString* responseString = [[NSString alloc] initWithData:data encoding:encoding];
    NSLog(@"sendPacket : %@", responseString);
    [outputStream write:[data bytes] maxLength:[data length]];
}

-(void)timerHandler:(NSTimer*)timer
{
    //NSLog(@"call timerHandler === %@", @"");
    
    mIntCreationPeroid = [_preference getCreationPeroid].integerValue;
    mIntReportPeroid = [_preference getReportPeroid].integerValue;
    
    NSDate *now = [NSDate date];
    NSTimeInterval interval = _lastTimestamp ? [now timeIntervalSinceDate:_lastTimestamp] : 0;
    NSTimeInterval interval2 = _lastTimestamp2 ? [now timeIntervalSinceDate:_lastTimestamp2] : 0;
    
    if (interval >= mIntCreationPeroid) {
        // 이벤트코드 : 주기보고
        [mClsPacketController makePeriodReportGpsData:@"01"];
        
        //Scan Beacon
        //[[EtransLocationManager sharedInstance] startBeaconScan];
        
        _lastTimestamp = now;
    }
    
    if (interval2 >= mIntReportPeroid) {
        if ([mClsPacketController getGpsDataSize] > 0) {
            [self sendPacket];
        }
        
        _lastTimestamp2 = now;
    }
    
    
    
//    RNLBeacon *beacon = [self scanBeacons];
//    if (beacon != nil && ![scanedBeacon isEqualToString:beacon.bluetoothIdentifier]) {
//        //Send To Server
//        NSMutableDictionary *params = [NSMutableDictionary new];
//        [params setValue:beacon.name forKey:@"BEACON_NAME"];
//        beacon.name;
//        beacon.bluetoothIdentifier;
//        beacon.serviceUuid;
//        beacon.measuredPower;
//        ((CLBeacon *)beacon).major;
//        ((CLBeacon *)beacon).minor;
//
//        scanedBeacon = beacon.bluetoothIdentifier;
//    }
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    //NSLog(@"stream event %lu", (unsigned long)streamEvent);
    NSUInteger event = streamEvent;

    switch (event)
    {
        case NSStreamEventOpenCompleted:
            NSLog(@"Stream opened");
//            [self sendPacket];
            break;
        case NSStreamEventHasBytesAvailable: // fundamental to receive messages
            if (theStream == inputStream)
            {
                uint8_t buffer[3];
                long len;
                while ([inputStream hasBytesAvailable])
                {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0)
                    {
                        NSString *output = [[NSString alloc] initWithBytes:buffer
                        length:len
                        encoding:NSUTF8StringEncoding];
                        if (nil != output)
                        {
                            NSLog(@"server said: %x", buffer[1]);
                            [mClsPacketController clearPacket];
                        }
                    }
                }
            }
            break;
        case NSStreamEventErrorOccurred:
            NSLog(@"Can not connect to the host!");
            break;
        case NSStreamEventEndEncountered:
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
            outputStream = nil;
            break;
        default:
            NSLog(@"Unknown event");
    }
}

@end
