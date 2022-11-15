//
//  EtransLocationManager.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/26.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "EtransLocationManager.h"
#import "GpsInfo.h"
#import "MinewBeaconManager.h"
#import "MinewBeaconConnection.h"
#import "DataSet.h"
#import "Preference.h"
#import "ComUtil.h"

@interface EtransLocationManager ()<CLLocationManagerDelegate, CBPeripheralDelegate, MinewBeaconManagerDelegate, MinewBeaconConnectionDelegate, CBCentralManagerDelegate>
{
    NSArray *_scannedBeacons;
    NSString *_oldIdentifer;
    Preference *_preference;
    CBCentralManager * _cManager;
}
@end

@implementation EtransLocationManager

@synthesize locationManager, longitude, latitude, isOnBluetooth;

+ (instancetype)sharedInstance {
    static EtransLocationManager *shared = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[EtransLocationManager alloc] init];
    });
    
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _oldIdentifer = @"";
        
        isOnBluetooth = YES;
        _cManager = [[CBCentralManager alloc] initWithDelegate:self
                                                                           queue:nil
                                                                         options:
                                       [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1]
                                                                   forKey:CBCentralManagerOptionShowPowerAlertKey]];
        [self checkStateInOneSecon];
    }
    return self;
}

- (void)startLocationManager {
    // CoerLocation
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    
    // 사용중에만 위치 정보 요청
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager setAllowsBackgroundLocationUpdates:YES];
        [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [self.locationManager startUpdatingLocation];
    }
//
//    CLAuthorizationStatus authorizationStatus;
//
//    if (@available(iOS 14.0, *)) {
//        authorizationStatus = self.locationManager.authorizationStatus;
//
//        if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
//            [self.locationManager startUpdatingLocation];
//        } else {
//            [self.locationManager requestWhenInUseAuthorization];
//        }
//    } else {
//
//    }
}

- (void)stopLocationManager {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    [locationManager stopMonitoringSignificantLocationChanges];   //asmyoung
}

- (void)startBeaconScan {
    [MinewBeaconManager sharedInstance].delegate = self;
    [[MinewBeaconManager sharedInstance] startScan];
}

- (void)stopBeaconScan {
    [MinewBeaconManager sharedInstance].delegate = nil;
    [[MinewBeaconManager sharedInstance] stopScan];
}


- (void)checkStateInOneSecon {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self checkStat];
    });
}

- (void)checkStat {
    [self checkStateInOneSecon];
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
    switch (central.state) {
        case CBManagerStatePoweredOff:
            NSLog(@"CBManagerStatePoweredOff");
            isOnBluetooth = NO;
            break;
        case CBManagerStatePoweredOn:
            NSLog(@"CBManagerStatePoweredOn");
            isOnBluetooth = YES;
            break;
        case CBManagerStateUnknown:
            NSLog(@"CBManagerStateUnknown");
            break;
        case CBManagerStateUnsupported:
            NSLog(@"CBManagerStateUnsupported");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"CBManagerStateUnauthorized");
            break;
        default:
            break;
    }
}
#pragma mark - CoreLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"locationManager didUpdateLocations");
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
//    NSDate* eventDate = location.timestamp;
//    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    
    CLLocationSpeed speed = location.speed; // m/s
    //if (speed > 9) {
        [[GpsInfo sharedInstance] setLocation:location];
    NSLog(@"GpsInfo location count ===> %ld", [[GpsInfo sharedInstance] getArrayListSize]);
    //}
    
    NSLog(@"latitude %+.6f, longitude %+.6f", location.coordinate.latitude, location.coordinate.longitude);
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        if (!error) {
            CLPlacemark *placemark = [placemarks lastObject];
            NSLog(@"%@", placemark);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManage didFailWithError, %@", error.description);
}


#pragma mark ******************MinewBeaconManager Delegate
- (void)minewBeaconManager:(MinewBeaconManager *)manager didRangeBeacons:(NSArray<MinewBeacon *> *)beacons
{
  
    _scannedBeacons = beacons;
    
    _scannedBeacons = [_scannedBeacons sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger rssi1 = ((MinewBeacon *)obj1).rssi;
        NSInteger rssi2 = ((MinewBeacon *)obj2).rssi;
        return rssi1 > rssi2? NSOrderedAscending: NSOrderedDescending;
        
    }];
    
    if (beacons.count > 0) [self sendBeaconData];
}

- (void)minewBeaconManager:(MinewBeaconManager *)manager appearBeacons:(NSArray<MinewBeacon *> *)beacons
{
//    NSLog(@"===appear beacons:%@", beacons);
}

- (void)minewBeaconManager:(MinewBeaconManager *)manager disappearBeacons:(NSArray<MinewBeacon *> *)beacons
{
//    NSLog(@"---disappear beacons:%@", beacons);
}


- (void)minewBeaconManager:(MinewBeaconManager *)manager didUpdateState:(BluetoothState)state
{
     NSLog(@"the bluetooth state is %@!", state == BluetoothStatePowerOn? @"power on":( state == BluetoothStatePowerOff? @"power off": @"unknown"));
}

#pragma mark **********************Connection Delegate
- (void)beaconConnection:(MinewBeaconConnection *)connection didChangeState:(ConnectionState)state
{
    NSString *string = @"Connection state change to ";
    
    switch (state) {
        case ConnectionStateConnecting:
           string = [string stringByAppendingString:@"Connceting"];
            break;
            
        case ConnectionStateConnected:
            string = [string stringByAppendingString:@"Connected"];
            break;
            
        case ConnectionStateDisconnected:
            string = [string stringByAppendingString:@"Disconnected"];
            break;
            
        case ConnectionStateConnectFailed:
            string = [string stringByAppendingString:@"ConnectFailed"];
            break;
        default:
            break;
    }
    
    NSLog(@"%@", string);
    
}

- (void) sendBeaconData {
    //비콘리스트
    NSArray *strBeaconList = @[@"MiniBeacon_16615",@"MiniBeacon_16616",@"MiniBeacon_16618"
                              ,@"klnet16645",@"klnet1664516645",@"klnet16646"
                              ,@"MiniBeacon_16649",@"MiniBeacon_16650",@"MiniBeacon_16651"
                              ,@"MiniBeacon_16652",@"MiniBeacon_16655",@"MiniBeacon_16656"
                              ,@"MiniBeacon_16755",@"MiniBeacon_16756",@"MiniBeacon_16760"
                              ,@"MiniBeacon_16761",@"MiniBeacon_16762",@"Mini@eacon_16763"
                              ,@"MiniBeacon_16763",@"MiniBeacon_16764"];
    
    for (NSString *item in strBeaconList) {
        for (MinewBeacon *beacon in _scannedBeacons) {
            NSString *name = beacon.name;
            //NSLog(@">>>>>>>>>> %@", identifer);
            
            if ([item isEqualToString:name]) {
                //Send Data
                [self requestBeaconData:beacon];
                break;
            }
        }
    }
}

- (void) requestBeaconData:(MinewBeacon *)beacon {
    
    if (_oldIdentifer != nil && [_oldIdentifer isEqualToString:beacon.identifer]) {
        return;
    }
    
    _preference = [[Preference alloc] init];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/report.do?method=reqTerminalBeaconAlarmInfo", CONNECTION_URL];
   
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[_preference getAuthPhoneNo] forKey:@"PhoneNumber"];
    [params setValue:[_preference getVehicleId] forKey:@"Vehicle_Id"];
    [params setValue:[_preference getVehicleId] forKey:@"Vehicle_ID"];
    [params setValue:[ComUtil getMacAddress] forKey:@"Mac_Address"];
    [params setValue:beacon.name forKey:@"BEACON_NAME"];
    [params setValue:beacon.mac forKey:@"BEACON_MAC"];
    [params setValue:beacon.identifer forKey:@"BEACON_UUID"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)beacon.battery] forKey:@"BEACON_BATTERY"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)beacon.major] forKey:@"BEACON_MAJOR"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)beacon.minor] forKey:@"BEACON_MINOR"];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString* jsonDataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

    NSMutableURLRequest *urlRequst = [[NSMutableURLRequest alloc] init];
    //post 데이터 만들기
    NSString *post = [NSString stringWithFormat:@"paramStr=%@",jsonDataStr]; //보낼 내용을 작성합니다.
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    //Request 요청 설정하기
    [urlRequst setURL:[NSURL URLWithString:strUrl]];
    [urlRequst setHTTPMethod:@"POST"]; // POST 방식으로 보냄
//    [urlRequst setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequst setHTTPBody:postData];
    [urlRequst setTimeoutInterval:60.0];

    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:urlRequst
                                                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

           if (!error) {
               NSString * responseStr = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
               NSLog(@"responseStr : %@", responseStr);
               
               self->_oldIdentifer = beacon.identifer;
           }
           else {
               NSLog(@"%@",error);
           }
    }];
    [postDataTask resume];
}
@end
