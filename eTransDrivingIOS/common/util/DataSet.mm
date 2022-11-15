//
//  DataSet.m
//  MGW
//
//  Created by user on 11. 3. 18..
//  Copyright 2011 juis. All rights reserved.
//

#import "DataSet.h"
#import "PopIndicatorViewController.h"
#import "Reachability.h"

#define Sessionexit_alert_TAG 10000
#define SessionTimeOut_alert_TAG 20000
#define InternetFail_alert_TAG 30000

@implementation DataSet

//@synthesize wire;
@synthesize g_fcUserId;

@synthesize target, selector;
@synthesize fromView;
@synthesize g_userid, g_username, g_deptid, g_deptname, g_displayname, g_repdeptid, g_repdeptname, g_positionname, g_isadmyn, g_status, g_authkey, g_gradename, g_photourl;
@synthesize option_orgtype, option_lockscreen, option_attachtalk, option_attachtalkreply, option_attachorder, option_attachorderreply, option_attachnotice, option_attachmboard, option_attachsize, option_attachsizeimg, option_sms, option_familyoptiongubun, option_familyoptionrel, option_familyoptionname, option_familyoptiondate, option_orderignoreuser, option_alldeptid, option_alldeptname, option_docserverurl, option_filedownurl, option_lockpassworderrortimes, option_announcementrespcodes, option_announcementrespnames, option_orgparenthasuser, option_mainrefreshterm, option_orgphotochange, option_orgsendemail, option_checkmobilephone, option_sessiontimeout, option_talkuselocation;

@synthesize arr_checkList, arr_TempcheckList, map_Address;
@synthesize orgSearchUserId, orgSearchUserName, body_thumbnail_imageSize, reply_thumbnail_imageSize, reply_collection_img_width;
@synthesize TalkForward_talkid, TalkForward_gubun, TalkModify_talkid, TalkModify_gubun, isReload, isSelectFinish, islogin, isFinishedChangePassword, setPassword;

@synthesize OrderForward_orderid, OrderForward_gubun, OrderModify_orderid, OrderModify_gubun;
@synthesize MboardModify_boardId, MboardModify_boardGubun;

@synthesize deviceTokenID, pushDict;
@synthesize sessiontimeoutMinute, sessionTimeout, lastRequestTime, pageSize, mainrefreshtime;

@synthesize fontsizeincrease;

@synthesize alreadyRegistedDeptId,selectedDeptId,selectedDeptName;

@synthesize push_seq, push_body, push_type, push_param, push_title, push_doc_gubun, push_yn, push_userInfo;

-(void)CommonSetting {
    arr_checkList = [[NSMutableArray alloc] init];
    arr_TempcheckList = [[NSMutableArray alloc] init];
    
    body_thumbnail_imageSize = 110.0f;
    reply_thumbnail_imageSize = 60.0f;
    reply_collection_img_width = 252.0f;
    fontsizeincrease = 1.0f;
    pageSize = 15;
    
    //    self.wire = [[WireHttpRequest alloc] initWithHost:[NSString stringWithFormat:@"%@/",HOST_URL]];
}

+ (DataSet *)sharedDataSet
{
    static DataSet *singletonClass = nil;
    if(singletonClass == nil)
    {
        @synchronized(self)
        {
            if(singletonClass == nil)
            {
                singletonClass = [[self alloc] init];
                [singletonClass CommonSetting];
            }
        }
    }
    return singletonClass;
}


- (void)setDelegate:(id)aTarget selector:(SEL)aSelector
{
    // 데이터 수신이 완료된 이후에 호출될 메서드의 정보를 담고 있는 셀렉터 설정
    self.target = aTarget;
    self.selector = aSelector;
}
//
//-(void)getRequest:(UIView*)view input:(Binding*)inputs widl:(NSString*)widl service:(NSString*)service
//{
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
//
//    NetworkStatus status = [reachability currentReachabilityStatus];
//
//    if(status == NotReachable)
//    {
//        UIAlertController * alert=   [UIAlertController
//        alertControllerWithTitle:@"오류"
//        message:@"인터넷이 되지 않습니다. 확인 후 다시 접속하기 바랍니다"
//        preferredStyle:UIAlertControllerStyleAlert];
//
//        [AlertViewUtil alertConfirmNormal:alert handler:^(UIAlertAction * action){
//            exit(0);
//        }];
//
//        NSLog(@"No internet");
//
//        return;
//    }
//    else if (status == ReachableViaWiFi)
//    {
//        NSLog(@"WiFi");
//    }
//    else if (status == ReachableViaWWAN)
//    {
//        NSLog(@"3G");
//    }
//
//    [self getRequest:view input:inputs widl:widl service:service time:20];
//}
//
//-(void)getRequest:(UIView*)view input:(Binding*)inputs widl:(NSString*)widl service:(NSString*)service time:(NSInteger)time
//{
//    if ([DataSet sharedDataSet].islogin) {
//        long nowtime = (long)[[NSDate date] timeIntervalSince1970] * 1000;
//
//        if((nowtime - lastRequestTime) > sessionTimeout) {
//            NSString *message = [NSString stringWithFormat:@"%d%@", sessiontimeoutMinute, main_alert_timeoutexit_text_message];
//
//            UIAlertController * alert=   [UIAlertController
//            alertControllerWithTitle:alert_common_title_confirm_title
//            message:message
//            preferredStyle:UIAlertControllerStyleAlert];
//
//            [AlertViewUtil alertConfirmNormal:alert handler:^(UIAlertAction * action){
//                exit(0);
//            }];
//            return;
//        }
//    }
//
//    lastRequestTime = (long)[[NSDate date] timeIntervalSince1970] * 1000;
//
//    fromView = view;
//
//    [inputs put:@"wire_widl" value:widl];
//    [inputs put:@"wire_svc" value:service];
//
//    //입력데이터 변환
//    NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
//    NSMutableArray *arrFiles = [[NSMutableArray alloc] init];
//
//    if ([inputs hasFiles])
//    {
//        NSString *filename;
//        NSString *formname;
//
//        NSEnumerator * enu = [[inputs getDict] keyEnumerator];
//
//        NSString *name;
//        while((name = [enu nextObject])) {
//            BindingObject *obj2 = [[inputs getDict] objectForKey:name];
//            switch ([obj2 getType]) {
//                case 0:
//                {
//                    NSString *objs = [obj2 getScalar];
//                    if (objs == nil) continue;
//                    if ([name rangeOfString:@"ff_bitweb"].location == NSNotFound && [name rangeOfString:@"fn_bitweb"].location == NSNotFound)
//                    {
//                        [args setObject:objs forKey:name];
//                    }
//                    else if ([name rangeOfString:@"ff_bitweb"].location == NSNotFound && [name rangeOfString:@"fn_bitweb"].location != NSNotFound)
//                    {
//                        NSString *suffix = [name substringFromIndex:3];
//                        //                        NSString *suffix2 = [name substringFromIndex:9];
//                        if (objs != nil && [objs isEqual:@""] == false)
//                        {
//                            filename = objs;
//                        }
//                        else
//                        {
//                            filename = @"WSTemp.tmp";
//                        }
//
//                        obj2 = [[inputs getDict] objectForKey:[NSString stringWithFormat:@"ff_%@", suffix]];
//
//                        if (obj2 != nil && [[obj2 getScalar] isEqual:@""] == false)
//                        {
//                            formname = [obj2 getScalar];
//                        }
//                        else
//                        {
//                            continue;
//                        }
//
//                    }
//
//                    [args setObject:objs forKey:name];
//                    break;
//                }
//                case 3:
//                {
//                    Files *objs = [obj2 getFiles];
//                    NSArray *files = [objs getFiles];
//                    for (int i = 0; i < [files count]; i++)
//                    {
//                        NSArray *file = [files objectAtIndex:i];
//
//                        NSString *ff = (NSString *)[file objectAtIndex:0];
//                        NSString *fn = (NSString *)[file objectAtIndex:1];
//                        NSData *fdata = (NSData*)[file objectAtIndex:2];
//
//                        NSDictionary *fileInfo = [[NSDictionary alloc] initWithObjectsAndKeys:ff, @"filename",
//                                                  fn, @"formname",
//                                                  fdata, @"fdata", nil];
//
//                        [arrFiles addObject:fileInfo];
//                    }
//
//
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
//    }
//    else
//    {
//        NSEnumerator * enu = [[inputs getDict] keyEnumerator];
//
//        NSString *name;
//        while((name = [enu nextObject])) {
//            BindingObject *obj2 = [[inputs getDict] objectForKey:name];
//            switch ([obj2 getType]) {
//                case 0:
//                {
//                    NSString *objs = [obj2 getScalar];
//                    [args setObject:objs forKey:name];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }
//    }
//    //첨부파일 처리
//
//    //HTTP 요청
//
//    // 접속할 주소 설정
//    NSString *url = HOST_URL;
//
//    // HTTP Request 인스턴스 생성
//    HTTPRequest *httpRequest = [[HTTPRequest alloc] init];
//
//    // 통신 완료 후 호출할 델리게이트 셀렉터 설정
//    [httpRequest setDelegate:self selectorSuccess:@selector(didReceiveFinished: result:) selectorFail:@selector(didFailWithError:)];
//
//    // 페이지 호출
//    [httpRequest requestUrl:url bodyObject:args fileArray:arrFiles];
//
//    if (fromView != nil)
//        [self waitPopView:fromView];
//}
//
//- (void)didReceiveFinished:(NSDictionary *)headers result:(NSData*)result
//{
//    if (fromView != nil)
//        [self delWaitPopView:fromView];
//
//    NSString *content_type = (NSString *)[headers objectForKey:@"Content-Type"];
//
//    Binding *outputs = [[Binding alloc] init];
//
//    //    if ([content_type isEqual:@"application/json"])
//    if ([content_type rangeOfString:@"application/json"].location == 0)
//    {
//        NSError* error;
//        NSDictionary* json = [NSJSONSerialization
//                              JSONObjectWithData:result
//                              options:kNilOptions
//                              error:&error];
//
//        NSDictionary *dic = json;
//
//        NSEnumerator *enumerator = [dic keyEnumerator];
//
//        for(NSString *aKey in enumerator) {
//            NSObject* val = [dic valueForKey:aKey];
//            if ([val isKindOfClass:[NSString class]])
//            {
//                BindingObject *scalar = [[BindingObject alloc] initWithScalar:(NSString*)val];
//                [[outputs getDict] setObject:scalar forKey:aKey];
//            }
//            else if ([val isKindOfClass:[NSArray class]])
//            {
//                NSArray* aval = (NSArray*)val;
//                if ([aval count] > 0)
//                {
//                    NSObject *vval = [aval objectAtIndex:0];
//                    if ([vval isKindOfClass:[NSArray class]])
//                    {
//                        //[][]
//                        BindingObject *matrix = [[BindingObject alloc] initWithMatrix:aval];
//                        [[outputs getDict] setObject:matrix forKey:aKey];
//                    }
//                    else {
//                        //[]
//                        BindingObject *vector = [[BindingObject alloc] initWithVector:aval];
//                        [[outputs getDict] setObject:vector forKey:aKey];
//                    }
//                }
//            }
//
//        }
//
//    }
//    //    else if ([content_type isEqual:@"application/octet-stream"])
//    else if ([content_type rangeOfString:@"application/octet-stream"].location == 0)
//    {
//        [outputs put:@"value" value:@"success"];
//        [outputs putFile:@"noname" formname:@"noname" data:result];
//
//        NSString *MO_PAGECOUNT = (NSString *)[headers objectForKey:@"MO_PAGECOUNT"];
//        NSString *MO_CONVERTING = (NSString *)[headers objectForKey:@"MO_CONVERTING"];
//        NSString *MO_PAGEHEIGHT = (NSString *)[headers objectForKey:@"MO_PAGEHEIGHT"];
//        NSString *MO_PAGEWIDTH = (NSString *)[headers objectForKey:@"MO_PAGEWIDTH"];
//        NSString *MO_STATE = (NSString *)[headers objectForKey:@"MO_STATE"];
//        NSString *MO_SVRIP = (NSString *)[headers objectForKey:@"MO_SVRIP"];
//
//        if (MO_STATE != nil && ![MO_STATE isEqualToString:@""])
//        {
//            [outputs put:@"MO_PAGECOUNT" value:MO_PAGECOUNT];
//            [outputs put:@"MO_CONVERTING" value:MO_CONVERTING];
//            [outputs put:@"MO_PAGEHEIGHT" value:MO_PAGEHEIGHT];
//            [outputs put:@"MO_PAGEWIDTH" value:MO_PAGEWIDTH];
//            [outputs put:@"MO_STATE" value:MO_STATE];
//            [outputs put:@"MO_SVRIP" value:MO_SVRIP];
//
//            [outputs put:@"code" value:@"0000"];
//            [outputs put:@"message" value:@""];
//
//        }
//    }
//    else
//    {
//        [outputs put:pExceptionTag value:@"응답이 없습니다. 잠시후 다시 시도해 주십시오."];
//    }
//
//    NSString *code = [outputs get:@"code"];
//
//    if (code != nil && [@"9998" isEqualToString:code]) {
//        self.isSessionExpired = true;
//
//        UIAlertController * alert=   [UIAlertController
//        alertControllerWithTitle:alert_common_title_confirm_title
//        message:main_alert_sessionexit_text_message
//        preferredStyle:UIAlertControllerStyleAlert];
//
//        [AlertViewUtil alertConfirmNormal:alert handler:^(UIAlertAction * action){
//            exit(0);
//        }];
//
//        return;
//    }
//
//    if(target)
//    {
//        [target performSelector:selector withObject:outputs];
//    }
//
//}
//
//- (void)didFailWithError:(NSString *)error_msg
//{
//    [self delWaitPopView:fromView];
//
//    Binding *outputs = [[Binding alloc] init];
//
//    [outputs put:pExceptionTag value:error_msg];
//
//    if(target)
//    {
//        [target performSelector:selector withObject:outputs];
//    }
//
//}


//대기뷰 삭제
-(void)delWaitPopView:(UIView*)view {
    if (view == nil) return;
    
    UIView *vw = [view viewWithTag:338];
    
    if (vw != nil) [vw removeFromSuperview];
}

//대기 뷰
-(void)waitPopView:(UIView*)view {
    if (view == nil) return;
    
    /*
     UIView *chkview = [view viewWithTag:338];
     if (chkview) return;
     
     CGFloat fHeight = [[UIScreen mainScreen] bounds].size.height;
     CGFloat fWidth = [[UIScreen mainScreen] bounds].size.width;
     
     CGRect winRect = CGRectMake(0, 0, fWidth, fHeight);
     
     UIView *vw = [[UIView alloc] initWithFrame:winRect];
     
     vw.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
     
     [vw setBackgroundColor:[UIColor grayColor]];
     [vw setAlpha:0.5];
     */
    
    
    
    PopIndicatorViewController *vw = [[PopIndicatorViewController alloc] init];
    CGFloat fHeight = view.frame.size.height;
    CGFloat fWidth = view.frame.size.width;
    
    vw.view.frame = CGRectMake(0.0, 0.0, fWidth, fHeight);
    
    UIActivityIndicatorView *iv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    [iv sizeToFit];
    [iv setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [iv setFrame: CGRectMake((fWidth-iv.frame.size.width)/2-iv.frame.size.width, (fHeight-iv.frame.size.height)/2 ,iv.frame.size.width*3,iv.frame.size.height*3) ];
    
    
    NSLog(@"x : %f y : %f width : %f heigh : %f ", (fWidth-iv.frame.size.width)/2-iv.frame.size.width, (fHeight-iv.frame.size.height)/2, iv.frame.size.width*3, iv.frame.size.height*3);
    
    
    vw.view.tag = 338;
    
    [vw.view addSubview:iv];
    
    iv.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                           UIViewAutoresizingFlexibleRightMargin |
                           UIViewAutoresizingFlexibleTopMargin |
                           UIViewAutoresizingFlexibleBottomMargin);
    
    //
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //
    //    [self performSelectorOnMainThread:@selector(addEventToButton:) withObject:button waitUntilDone:NO];
    //
    //    //    [button addTarget:self
    //    //               action:@selector(cancelRequest)
    //    //     forControlEvents:UIControlEventTouchDown];
    //    [button setTitle:@"취소" forState:UIControlStateNormal];
    //    button.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //    [button setAlpha:1];
    //    //[vw addSubview:button]; //here
    
    [view addSubview:vw.view]; //here
    //    [view addSubview:button]; //here
    
    [iv startAnimating];
}


+ (void)setFromDate:(UITextField *)tf_fromdate setToDate:(UITextField *)tf_todate {
    
    NSDateFormatter *today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy-MM-dd"];
    NSString *stodate = [today stringFromDate:[NSDate date]];
    tf_todate.text = stodate;
    
    
    //NSCalendar *cal = [NSCalendar currentCalendar];
    NSTimeInterval one_Month = -24 * 60 * 60 * 30;
    
    NSDate *nowdate = [NSDate date];
    NSDate *fromdate = [nowdate dateByAddingTimeInterval:one_Month];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *sfromdate = [formatter stringFromDate:fromdate];
    tf_fromdate.text = sfromdate;
}

+ (void)setDate:(UITextField *)tf_date {
    NSDateFormatter *today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"yyyy-MM-dd"];
    NSString *sdate = [today stringFromDate:[NSDate date]];
    tf_date.text = sdate;
}

+ (void)setTime:(UITextField *)tf_time  {
    NSDateFormatter *today = [[NSDateFormatter alloc] init];
    [today setDateFormat:@"HH':'mm"];
    NSString *sdate = [today stringFromDate:[NSDate date]];
    tf_time.text = sdate;
}

//+(void)alert:(NSString*)msg {
//    [[self class] alert:msg title:nil];
//}

//+(void)alert:(NSString*)msg title:(NSString*)title  {
//    [AlertViewUtil alertConfirmNormal:title message:msg];
//}


+(NSDictionary*)loadDicFromFile:(NSString *)fileName {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/%@", document, fileName];
    NSDictionary *ret = [[NSDictionary alloc] initWithContentsOfFile:file];
    return ret;
}

+(void)saveDicToFile:(NSDictionary*)dic fileName:(NSString *)fileName {
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *file = [NSString stringWithFormat:@"%@/%@", document, fileName];
    [dic writeToFile:file atomically:YES];
    
}


+ (NSString *)getPath : (NSString *) plistFileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:plistFileName];
    
    return path;
}

+(NSString*)getValue:(NSString*)value { //널값이거나 null이면 @"" 리턴해줌
    if (value == NULL) return @"";
    if ([value isEqualToString:@"null"]) return @"";
    return value;
    
}

//사전(Dictionary)에서 값을 가져올때 nil값을 @"" 처리하여 돌려준다.
+(id)getMapValue:(id)map key:(id)key {
    id value;
    if ([map isKindOfClass:[NSDictionary class]] || [map isKindOfClass:[NSMutableDictionary class]]) {
        value = [map objectForKey:key];
        if (value==nil) value=@"";
        return value;
    }
    return nil;
}

+(void)setPlistWithName:(NSString *)fileName key:(NSString *)key value:(NSString *)value
{
    NSLog(@"value : %@", value);
    NSString *plistFileName = [NSString stringWithFormat:@"%@.plist", fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [DataSet getPath:plistFileName];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"XInitializerItem" forKey:@"DoNotEverChangeMe"];
    // saving values
    [dict setObject:value forKey:key];
    // writing to GameData.plist
    [dict writeToFile:path atomically:YES];
    
    NSDictionary *resultDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"Saved file in Documents Direcotry is --> %@", [resultDictionary description]);
}

+(NSString *)getPlistWithName:(NSString *)fileName key:(NSString *)key
{
    NSString *plistFileName = [NSString stringWithFormat:@"%@.plist", fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSString *path = [DataSet getPath:plistFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //check if file exists
    if (![fileManager fileExistsAtPath:path]) {
        NSLog(@"path doesn't exist. plist file will be copied to the path.");
        // If it doesn't, copy it from the default file in the Bundle
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        if (bundlePath) {
            NSLog(@"file exists in the main bundle.");
//            NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionaryWithContentsOfFile:bundlePath];
            NSDictionary *resultDictionary = [NSDictionary dictionaryWithContentsOfFile:bundlePath];
            NSLog(@"Bundle GameData.plist file is --> %@", [resultDictionary description]);
            // copy dictionary from main bundle to document directory path
            [fileManager copyItemAtPath:bundlePath toPath:path error:nil];
            NSLog(@"plist file is copied from main bundle to document directory");
        } else {
            NSLog(@"GameData.plist not found in main bundle. Please, make sure it is part of the bundle.");
        }
        // use this to delete file from documents directory
        // [fileManager removeItemAtPath:path error:nil];
    }
    
    // store plist file, at documents directory, in dictionary
    NSDictionary *resultDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"Loaded file at Documents Directory is --> %@", [resultDictionary description]);
    
//    NSDictionary *myDict = [NSDictionary dictionaryWithContentsOfFile:path];
    if (resultDictionary) {
        // load items from plist file
        NSString *returnValue = [resultDictionary objectForKey:key];
        NSLog(@"returnValue : %@", returnValue);
        return returnValue;
    } else {
        NSLog(@"WARNING: Couldn't create dictionary from GameData.plist at Documents Dicretory! Default values will be used!");
    }
    
    return @"";
}

@end
