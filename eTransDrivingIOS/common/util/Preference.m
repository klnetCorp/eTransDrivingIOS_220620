//
//  Preference.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/09.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "Preference.h"
#import "DataSet.h"

@implementation Preference

- (instancetype)init
{
    self = [super init];
    if (self) {
        _userDefault = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

- (NSString *)getPreference:(NSString *)key defValue:(NSString *)defValue {
    return [_userDefault objectForKey:key] == nil ? defValue : [_userDefault objectForKey:key];
}

- (void)setPreference:(NSString *)key value:(NSString *)value {
    [_userDefault setObject:value forKey:key];
    [_userDefault synchronize];
}

- (NSString *)getAuthKey {
    return [self getPreference:PREF_KEY_AUTHKEY defValue:@""];
}

- (void)setAuthKey:(NSString *)authKey {
    [self setPreference:PREF_KEY_AUTHKEY value:authKey];
}

- (NSString *)getAutoLogin {
    return [self getPreference:PREF_KEY_AUTOLOGIN defValue:@""];
}

- (void)setAutoLogin:(NSString *)autoLogin {
    [self setPreference:PREF_KEY_AUTOLOGIN value:autoLogin];
}

- (NSString *)getLoggedIn {
    return [self getPreference:PREF_KEY_LOGGEDIN defValue:@""];
}

- (void)setLoggedIn:(NSString *)loggedin {
    [_userDefault setObject:loggedin forKey:PREF_KEY_LOGGEDIN];
}

- (NSString *)getFirstLogin {
    return [self getPreference:PREF_KEY_FIRST_LOGIN defValue:@"Y"];
}

- (void)setFirstLogin:(NSString *)firstLogin {
    [_userDefault setObject:firstLogin forKey:PREF_KEY_FIRST_LOGIN];
}

- (NSString *)getAgreeType {
    return [self getPreference:PREF_KEY_AGREE_TYPE defValue:@"N"];
}
- (void)setAgreeType:(NSString *)agreeType {
    [_userDefault setObject:agreeType forKey:PREF_KEY_AGREE_TYPE];
}

- (NSString *)getGpsAgreeYn {
    return [self getPreference:PREF_KEY_GPS_AGREE_YN defValue:@"N"];
}
- (void)setGpsAgreeYn:(NSString *)agreeType {
    [_userDefault setObject:agreeType forKey:PREF_KEY_GPS_AGREE_YN];
}

- (NSString *)getCarCd {
    return [self getPreference:PREF_KEY_CARCD defValue:@""];
}
- (void)setCarCd:(NSString *)carCd {
    [_userDefault setObject:carCd forKey:PREF_KEY_CARCD];
}

- (NSString *)getVehicleId {
    return [self getPreference:PREF_KEY_VEHICLE_ID defValue:@""];
}
- (void)setVehicleId:(NSString *)vehicleId {
    [_userDefault setObject:vehicleId forKey:PREF_KEY_VEHICLE_ID];
}

- (NSString *)getCarrierId {
    return [self getPreference:PREF_KEY_CARRIER_ID defValue:@""];
}
- (void)setCarrierId:(NSString *)carrierId {
    [_userDefault setObject:carrierId forKey:PREF_KEY_CARRIER_ID];
}

- (NSString *)getReportPeroid {
    return [self getPreference:PREF_KEY_REPORT_PERIOD defValue:@"10"];
}
- (void)setReportPeroid:(NSString *)reportPeriod {
    [_userDefault setObject:reportPeriod forKey:PREF_KEY_REPORT_PERIOD];
}

- (NSString *)getCreationPeroid {
    return [self getPreference:PREF_KEY_CREATION_PERIOD defValue:@"5"];
}
- (void)setCreationPeroid:(NSString *)creationPeriod {
    [_userDefault setObject:creationPeriod forKey:PREF_KEY_CREATION_PERIOD];
}

- (NSString *)getRestFlag {
    return [self getPreference:PREF_KEY_REST_FLAG defValue:@"N"];
}
- (void)setRestFlag:(NSString *)restFlag {
    [_userDefault setObject:restFlag forKey:PREF_KEY_REST_FLAG];
}

- (NSString *)getChassisNo {
    return [self getPreference:PREF_KEY_CHASSIC_NO defValue:@""];
}
- (void)setChassisNo:(NSString *)chassisNo {
    [_userDefault setObject:chassisNo forKey:PREF_KEY_CHASSIC_NO];
}

- (NSString *)getPushToken {
    return [self getPreference:PREF_KEY_PUSH_TOKEN defValue:@""];
}
- (void)setPushToken:(NSString *)token {
    [_userDefault setObject:token forKey:PREF_KEY_PUSH_TOKEN];
}

- (NSString *)getAuthPhoneNo {
    return [self getPreference:PREF_KEY_AUTH_PHONE_NO defValue:@""];
}
- (void)setAuthPhoneNo:(NSString *)phoneNo {
    [_userDefault setObject:phoneNo forKey:PREF_KEY_AUTH_PHONE_NO];
}

- (NSString *)getNavigationType {
    return [self getPreference:PREF_KEY_NAVIGATION_TYPE defValue:@"01"];
}
- (void)setNavigationType:(NSString *)navigationType {
    [self setPreference:PREF_KEY_NAVIGATION_TYPE value:navigationType];
}

- (NSString *)getContainerNo1; {
    return [self getPreference:PREF_KEY_CONTAINER_NO1 defValue:@""];
}
- (void)setContainerNo1:(NSString *)containerno {
    [self setPreference:PREF_KEY_CONTAINER_NO1 value:containerno];
}

- (NSString *)getContainerNo2 {
     return [self getPreference:PREF_KEY_CONTAINER_NO2 defValue:@""];
}
- (void)setContainerNo2:(NSString *)containerno  {
    [self setPreference:PREF_KEY_CONTAINER_NO2 value:containerno];
}

- (NSString *)getDispatchNo {
    return [self getPreference:PREF_KEY_DISPATCH_NO defValue:@""];
}
- (void)setDispatchNo:(NSString *)dispatchNo {
    [self setPreference:PREF_KEY_DISPATCH_NO value:dispatchNo];
}

- (NSString *)getOrderType {
    return [self getPreference:PREF_KEY_ORDER_TYPE defValue:@""];
}
- (void)setOrderType:(NSString *)orderType {
    [self setPreference:PREF_KEY_ORDER_TYPE value:orderType];
}

- (NSString *)getImportType {
    return [self getPreference:PREF_KEY_IMPORT_TYPE defValue:@""];
}
- (void)setImportType:(NSString *)importType {
    [self setPreference:PREF_KEY_IMPORT_TYPE value:importType];
}

- (NSString *)getEventCode {
    return [self getPreference:PREF_KEY_EVENT_CODE defValue:@""];
}
- (void)setEventCode:(NSString *)eventCode {
    [self setPreference:PREF_KEY_EVENT_CODE value:eventCode];
}

- (NSString *)getLastGps {
    return [self getPreference:PREF_KEY_LAST_GPS defValue:@""];
}
- (void)setLastGps:(NSString *)lastGps {
    [self setPreference:PREF_KEY_LAST_GPS value:lastGps];
}

- (NSString *)getTTS {
    return [self getPreference:PREF_KEY_USE_TTS defValue:@"N"];
}
- (void)setTTS:(NSString *)tts {
    [self setPreference:PREF_KEY_USE_TTS value:tts];
}
@end
