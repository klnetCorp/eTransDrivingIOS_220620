//
//  Preference.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/09.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define PREF_KEY_AUTHKEY @"etrans.driving.pref.key.authkey"
#define PREF_KEY_AUTOLOGIN @"etrans.driving.pref.key.autologin"
#define PREF_KEY_LOGGEDIN @"etrans.driving.pref.key.loggedin"
#define PREF_KEY_FIRST_LOGIN @"etrans.driving.pref.key.firstlogin"
#define PREF_KEY_AGREE_TYPE @"etrans.driving.pref.key.agreetype"
#define PREF_KEY_GPS_AGREE_YN @"etrans.driving.pref.key.gpsagreeyn"
#define PREF_KEY_PUSH_TOKEN @"etrans.driving.pref.key.pushtoken"
#define PREF_KEY_LBSSTART_YN @"etrans.driving.pref.key.lbsstartyn" //관제시작여부
#define PREF_KEY_VEHICLE_ID @"etrans.driving.pref.key.vehicleid"
#define PREF_KEY_CARCD @"etrans.driving.pref.key.carcd" //차량ID(번호) 설정
#define PREF_KEY_CARGB @"etrans.driving.pref.key.cargb" //벌크(1)/컨테이너(2) 구분
#define PREF_KEY_CREATION_PERIOD @"etrans.driving.pref.key.creationperiod" //생성주기
#define PREF_KEY_REPORT_PERIOD @"etrans.driving.pref.key.reportperiod" //보고주기
#define PREF_KEY_ARRPLANDTM_PERIOD @"etrans.driving.pref.key.arrplandtmperiod" //도착 예정 주기
#define PREF_KEY_CARRIER_ID @"etrans.driving.pref.key.carrierid" //운송사ID
#define PREF_KEY_EVENT_CODE @"etrans.driving.pref.key.eventcode" //이벤트 코드
#define PREF_KEY_LAST_GPS @"etrans.driving.pref.key.lastgps" // 마지막 저장된 GPS
#define PREF_KEY_CHASSIC_NO @"etrans.driving.pref.key.chassicno" // 샤시번호
#define PREF_KEY_CONTAINER_NO1 @"etrans.driving.pref.key.containerno1" // 컨테이너번호1
#define PREF_KEY_CONTAINER_NO2 @"etrans.driving.pref.key.containerno2" // 컨테이너번호2
#define PREF_KEY_DISPATCH_NO @"etrans.driving.pref.key.dispatchno" // 배차번호
#define PREF_KEY_ORDER_TYPE @"etrans.driving.pref.key.ordertype" // 오더유형
#define PREF_KEY_IMPORT_TYPE @"etrans.driving.pref.key.ordertype" // 수출입구분
#define PREF_KEY_REST_FLAG @"etrans.driving.pref.key.restflag"
#define PREF_KEY_NAVIGATION_TYPE @"etrans.driving.pref.key.navigationtype" //설정>네비게이션 종류 지정
#define PREF_KEY_AUTH_PHONE_NO @"etrans.driving.pref.key.authPhoneNo" //ios 인증받은 폰번호
#define PREF_KEY_USE_TTS @"etrans.driving.pref.key.ttsSet" //TTS 사용여부

@interface Preference : NSObject
{
    NSUserDefaults *_userDefault;
}

- (NSString *)getPreference:(NSString *)key defValue:(NSString *)defValue;
- (void)setPreference:(NSString *)key value:(NSString *)value;

- (NSString *)getAuthKey;
- (void)setAuthKey:(NSString *)authKey;

- (NSString *)getAutoLogin;
- (void)setAutoLogin:(NSString *)autoLogin;

- (NSString *)getLoggedIn;
- (void)setLoggedIn:(NSString *)loggedin;

- (NSString *)getFirstLogin;
- (void)setFirstLogin:(NSString *)firstLogin;

- (NSString *)getAgreeType;
- (void)setAgreeType:(NSString *)agreeType;

- (NSString *)getGpsAgreeYn;
- (void)setGpsAgreeYn:(NSString *)agreeType;

- (NSString *)getCarCd;
- (void)setCarCd:(NSString *)carCd;

- (NSString *)getVehicleId;
- (void)setVehicleId:(NSString *)vehicleId;

- (NSString *)getCarrierId;
- (void)setCarrierId:(NSString *)carrierId;

- (NSString *)getReportPeroid;
- (void)setReportPeroid:(NSString *)reportPeriod;

- (NSString *)getCreationPeroid;
- (void)setCreationPeroid:(NSString *)creationPeriod;

- (NSString *)getRestFlag;
- (void)setRestFlag:(NSString *)restFlag;

- (NSString *)getChassisNo;
- (void)setChassisNo:(NSString *)chassisNo;

- (NSString *)getPushToken;
- (void)setPushToken:(NSString *)token;

- (NSString *)getAuthPhoneNo;
- (void)setAuthPhoneNo:(NSString *)phoneNo;

- (NSString *)getNavigationType;
- (void)setNavigationType:(NSString *)navigationType;

- (NSString *)getContainerNo1;
- (void)setContainerNo1:(NSString *)containerno;

- (NSString *)getContainerNo2;
- (void)setContainerNo2:(NSString *)containerno;

- (NSString *)getDispatchNo;
- (void)setDispatchNo:(NSString *)dispatchNo;

- (NSString *)getOrderType;
- (void)setOrderType:(NSString *)orderType;

- (NSString *)getImportType;
- (void)setImportType:(NSString *)importType;

- (NSString *)getEventCode;
- (void)setEventCode:(NSString *)getEventCode;

- (NSString *)getLastGps;
- (void)setLastGps:(NSString *)lastGps;

- (NSString *)getTTS;
- (void)setTTS:(NSString *)tts;
@end

NS_ASSUME_NONNULL_END
