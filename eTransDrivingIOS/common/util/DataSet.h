//
//  DataSet.h
//  MGW
//
//  Created by user on 11. 3. 18..
//  Copyright 2011 juis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//#import "Binding.h"



#define alert_common_title_confirm_title @"확인"
#define alert_common_button_positive_text @"확인"
#define alert_common_button_negative_text @"취소"
#define alert_common_title_error1 @"오류"
#define alert_common_title_error2 @"오류 발생"
#define alert_common_message_error @"오류가 발생하였습니다. 잠시 후 다시 시도하여 주십시오."

//////////////////         인트로        //////////////////////

#define intro_download_done_text @"다운로드가 완료되었습니다."
#define intro_new_version_alert_text @"새로운 버전의 앱이 있습니다."
#define intro_new_version_alert_question_text @"업데이트 하시겠습니까?"
#define intro_new_version_alert_title_text @"알림"
#define intro_update_ing_text @"업데이트 중 입니다."


//#define CONNECTION_URL @"https://www.etruckbank.co.kr:8443" //운영
#define CONNECTION_URL @"https://smartest.klnet.co.kr:8443" //개발계
//#define PUSH_URL @"https://push.plism.com" //운영계 push
#define PUSH_URL @"https://testpush.plism.com" //개발계 push

//#define DOC_CONNECTION_URL @"https://www.etruckbank.co.kr" //운영
#define DOC_CONNECTION_URL @"https://smartest.klnet.co.kr" //개발계

#define LOGIN_PATH @"/etdriving/login.jsp"
#define LOGOUT_PATH @"/etdriving/loginOut.jsp"
#define MAIN_PATH @"/main.do"
#define PUSH_REDIRECT_PATH @"/etdriving/pushList.jsp"  //push 수신시 이동하는 url, javascript:pushTest(seq, doc_gubun, type, call_text, call_text_sub, call_param)
#define LBSENGINE_IP @"203.236.120.62"
//#define LBSENGINE_PORT @"14200" //real lbs port
#define LBSENGINE_PORT @"14666" //dev lbs port (smartest)

/** 플래인 채널 */
#define SOCKET_CHANNEL_TYPE_PLAIN   0;
/** SSL 채널 */
#define SOCKET_CHANNEL_TYPE_SSL     1;

/** 서버로 전송시 한글필드의 경우 2바이트로 인식할수 있게 인코딩 */
#define DEF_STRING_ENCODING_NAME    @"euc-kr";

// 이벤트 코드
/** 주기보고 */
#define DEF_EVENT_CODE_PERIOD_REPORT    @"01";
/** 즉시보고 */
#define DEF_EVENT_CODE_DIRECT_REPORT    @"02";



//public static String push_url = "https://testpush.plism.com";  //개발계 push
//    public static String push_url = "https://push.plism.com"; //운영계 push
//    public static String connect_url = "https://devmciq.plism.com";
    //public static String connect_url = "https://mciq.plism.com";

    //eTransDriving service
//    public static String connect_url = "https://www.etruckbank.co.kr:8443"; //운영
//    public static String connect_url = "https://smartest.klnet.co.kr:8443"; //개발계
//    public static String login_path = "/etdriving/login.jsp";
//    public static String logout_path = "/etdriving/loginOut.jsp";
//    public static String main_path = "/main.do";
//    public static String push_redirect_url = "/etdriving/push_test.jsp";  //push 수신시 이동하는 url, javascript:pushTest(seq, doc_gubun, type, call_text, call_text_sub, call_param)


#define basicPlistFileName @"basicInfo"
#define loginPlistFileName @"loginInfo"
#define phonePlistFileName @"phoneInfo"

#define plistSavedUserID @"saved_userid"
#define plistFontSize @"font_size"
#define plistSavedYN @"isSave"
#define plistSavedPhoneNumber @"saved_phoneNumber"


#define plistSavedProcessID @"saved_process_rid"
#define plistSessoinKeyName @"skey"
#define plistSetPassword @"set_password"
#define plistLockScreenPassword @"lock_password"
#define plistGCMRegsterID @"gcm_registered_id"

@interface DataSet : NSObject {
    //와이어오피스 연결 관련
    //WireHttpRequest *wire;
    id target;
    SEL selector;
    UIView* fromView;
}

//
@property (nonatomic, strong) NSString *g_fcUserId;
//


//@property (nonatomic, retain) WireHttpRequest* wire;
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, retain) UIView* fromView;


@property (nonatomic, strong) NSString *g_userid;
@property (nonatomic, strong) NSString *g_username;
@property (nonatomic, strong) NSString *g_deptid;
@property (nonatomic, strong) NSString *g_deptname;
@property (nonatomic, strong) NSString *g_displayname;
@property (nonatomic, strong) NSString *g_repdeptid;
@property (nonatomic, strong) NSString *g_repdeptname;
@property (nonatomic, strong) NSString *g_positionname;
@property (nonatomic, strong) NSString *g_isadmyn;
@property (nonatomic, strong) NSString *g_status;
@property (nonatomic, strong) NSString *g_authkey;
@property (nonatomic, strong) NSString *g_gradename;
@property (nonatomic, strong) NSString *g_photourl;


@property (nonatomic, strong) NSString *option_orgtype;
@property (nonatomic, strong) NSString *option_lockscreen;
@property (nonatomic, strong) NSString *option_attachtalk;
@property (nonatomic, strong) NSString *option_attachtalkreply;
@property (nonatomic, strong) NSString *option_attachorder;
@property (nonatomic, strong) NSString *option_attachorderreply;
@property (nonatomic, strong) NSString *option_attachnotice;
@property (nonatomic, strong) NSString *option_attachmboard;
@property (nonatomic, strong) NSString *option_attachsize;
@property (nonatomic, strong) NSString *option_attachsizeimg;
@property (nonatomic, strong) NSString *option_sms;
@property (nonatomic, strong) NSString *option_familyoptiongubun;
@property (nonatomic, strong) NSString *option_familyoptionrel;
@property (nonatomic, strong) NSString *option_familyoptionname;
@property (nonatomic, strong) NSString *option_familyoptiondate;
@property (nonatomic, strong) NSString *option_orderignoreuser;

@property (nonatomic, strong) NSString *option_orgphotochange;
@property (nonatomic, strong) NSString *option_orgsendemail;

@property (nonatomic, strong) NSString *option_alldeptid;
@property (nonatomic, strong) NSString *option_alldeptname;

@property (nonatomic, strong) NSString *option_docserverurl;
@property (nonatomic, strong) NSString *option_filedownurl;

@property (nonatomic, strong) NSString *option_talkuselocation;
@property (nonatomic, strong) NSString *option_sessiontimeout;

@property (nonatomic, strong) NSString *option_announcementrespcodes;
@property (nonatomic, strong) NSString *option_announcementrespnames;

@property (nonatomic, strong) NSString *option_lockpassworderrortimes;
@property (nonatomic, strong) NSString *option_checkmobilephone;

@property (nonatomic, strong) NSString *option_orgparenthasuser;
@property (nonatomic, strong) NSString *option_mainrefreshterm;

@property (strong, nonatomic) NSString *orgSearchUserId;
@property (strong, nonatomic) NSString *orgSearchUserName;


@property (strong, nonatomic) NSString *TalkForward_talkid;
@property (strong, nonatomic) NSString *TalkForward_gubun;
@property (strong, nonatomic) NSString *TalkModify_talkid;
@property (strong, nonatomic) NSString *TalkModify_gubun;

@property (strong, nonatomic) NSString *OrderForward_orderid;
@property (strong, nonatomic) NSString *OrderForward_gubun;
@property (strong, nonatomic) NSString *OrderModify_orderid;
@property (strong, nonatomic) NSString *OrderModify_gubun;

@property (strong, nonatomic) NSString *MboardModify_boardId;
@property (strong, nonatomic) NSString *MboardModify_boardGubun;

@property(nonatomic, strong) NSMutableArray *arr_TempcheckList;
@property(nonatomic, strong) NSMutableArray *arr_checkList;

@property(nonatomic, strong) NSString *selectedDeptId;        ///< 현재 선택된 부서ID
@property(nonatomic, strong) NSString *selectedDeptName;      ///< 현재 선택된 부서명
@property(nonatomic, strong) NSString *alreadyRegistedDeptId; ///< 이미 서버에 등록되어 있는 부서 ID

@property(nonatomic) Boolean istalk_not_preview; // 간편소통에서 접근하지 않은경우


@property (strong, nonatomic) NSString *map_Address;
@property(nonatomic) Boolean isSetmapAdress;


@property(nonatomic) float body_thumbnail_imageSize;
@property(nonatomic) float reply_thumbnail_imageSize;
@property(nonatomic) float reply_collection_img_width;

@property(nonatomic) Boolean isReload;
@property(nonatomic) Boolean isSelectFinish;
@property(nonatomic) Boolean islogin;
@property(nonatomic) Boolean isFinishedChangePassword;
@property(nonatomic) Boolean isFinishedLockPassword;
@property(nonatomic) Boolean setPassword;

@property(nonatomic) Boolean isMainLock;

@property(nonatomic) int backgroundCount;

@property(nonatomic) float fontsizeincrease;

@property(nonatomic) int viewdepth;


@property (nonatomic, strong) NSString  *deviceTokenID;

@property (strong, nonatomic) NSDictionary *pushDict;

@property (nonatomic) Boolean isSessionExpired;

@property (nonatomic) Boolean isMain;

@property (nonatomic) int sessiontimeoutMinute;
@property (nonatomic) long sessionTimeout;
@property (nonatomic) long lastRequestTime;
@property (nonatomic) int pageSize;

@property (nonatomic) long mainrefreshtime;

@property(nonatomic) Boolean isStartPush;

@property (nonatomic, strong) NSString  *push_seq;
@property (nonatomic, strong) NSString  *push_type;
@property (nonatomic, strong) NSString  *push_doc_gubun;
@property (nonatomic, strong) NSString  *push_title;
@property (nonatomic, strong) NSString  *push_body;
@property (nonatomic, strong) NSString  *push_param;
@property (nonatomic, strong) NSString  *push_yn;
@property (nonatomic, strong) NSDictionary  *push_userInfo;

+(DataSet *)sharedDataSet;

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector;

//-(void)getRequest:(UIView*)view input:(Binding*)inputs widl:(NSString*)widl service:(NSString*)service;
//-(void)getRequest:(UIView*)view input:(Binding*)inputs widl:(NSString*)widl service:(NSString*)service time:(NSInteger)time;

- (void)didReceiveFinished:(NSDictionary *)headers result:(NSData*)result;
- (void)didFailWithError:(NSString *)error_msg;

-(void)delWaitPopView:(UIView*)view;
-(void)waitPopView:(UIView*)view;

+(void)setFromDate:(UITextField *)tf_fromdate setToDate:(UITextField *)tf_todate;
+(void)setDate:(UITextField *)tf_date;
+(void)setTime:(UITextField *)tf_time;

+(void)alert:(NSString*)msg;
+(void)alert:(NSString*)msg title:(NSString*)title;

+(NSDictionary*)loadDicFromFile:(NSString *)fileName;

+(void)saveDicToFile:(NSDictionary*)dic fileName:(NSString *)fileName;

+ (NSString *)getPath : (NSString *) plistFileName;

+(NSString*)getValue:(NSString*)value;

+(id)getMapValue:(id)map key:(id)key;

+(void)setPlistWithName:(NSString *)fileName key:(NSString *)key value:(NSString *)value;
+(NSString *)getPlistWithName:(NSString *)fileName key:(NSString *)key;

@end
