//
//  AppDelegate.m
//  eTransDrivingIOS
//
//  Created by macbook pro 2017 on 04/03/2020.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//
#import "AppDelegate.h"
#import "TestMenuViewController.h"
#import "MainViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "ReportServiceManager.h"
#import "EtransLocationManager.h"
#import "Preference.h"
#import "DataSet.h"
#import <CallKit/CallKit.h>
#import "SpeechHelper.h"
@import Firebase;

@interface AppDelegate ()<UNUserNotificationCenterDelegate, FIRMessagingDelegate>
{
//    CXCallObserver *_callObserver;
//    BOOL _bIsCalling;
}
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"didFinishLaunchingWithOptions");
    
//    _callObserver = [[CXCallObserver alloc] init];
//    [_callObserver setDelegate:self queue:nil];
    
//    [self goMain];
    
    // [START configure_firebase]
    [FIRApp configure];
    // [END configure_firebase]

    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]

    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    // [START register_for_notifications]
    if ([UNUserNotificationCenter class] != nil) {
      // iOS 10 or later
      // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    } else {
      // iOS 10 notifications aren't available; fall back to iOS 8-9 notifications.
      UIUserNotificationType allNotificationTypes =
      (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
      UIUserNotificationSettings *settings =
      [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
      [application registerUserNotificationSettings:settings];
    }

    [application registerForRemoteNotifications];
    // [END register_for_notifications]
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [[EtransLocationManager sharedInstance] startLocationManager];
//    [[EtransLocationManager sharedInstance] startBeaconScan];
//    [[ReportServiceManager sharedInstance] startReportService];
    
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[EtransLocationManager sharedInstance] stopLocationManager];
//    [[EtransLocationManager sharedInstance] stopBeaconScan];
//    [[ReportServiceManager sharedInstance] stopReportService];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%@", url.absoluteString);
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    Preference * p = [Preference new];
    [p setLoggedIn:@"N"];
}

#pragma mark - UISceneSession lifecycle
//
//
//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}


//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"eTransDrivingIOS"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (void)goMain {
    _window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
//    TestMenuViewController *mainview = [[TestMenuViewController alloc] initWithNibName:@"TestMenuViewController" bundle:nil];
//    TestMenuViewController *mainview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
//                                        instantiateViewControllerWithIdentifier:@"TestMenuViewController"];
    MainViewController *mainview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
    instantiateViewControllerWithIdentifier:@"MainViewController"];
    _window.rootViewController = mainview;
    [_window makeKeyAndVisible];
    
}


#pragma mark - FCM Message Delegate

// For Background
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }

    // Print full message.
    NSLog(@"Background : %@", userInfo);

    NSData *jsonData = [[userInfo objectForKey:@"msg"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    NSString *type = [dic objectForKey:@"type"];
    NSString *seq = [dic objectForKey:@"seq"];
    NSString *doc_gubun = [dic objectForKey:@"doc_gubun"];
    NSString *param = [dic objectForKey:@"param"];
    NSString *title = [dic objectForKey:@"title"];
    NSString *body = [dic objectForKey:@"body"];
    
    [DataSet sharedDataSet].push_title = title;
    [DataSet sharedDataSet].push_body = body;
    [DataSet sharedDataSet].push_type = type;
    [DataSet sharedDataSet].push_seq = seq;
    [DataSet sharedDataSet].push_doc_gubun = doc_gubun;
    [DataSet sharedDataSet].push_param = param;
    
    Preference *preference = [Preference new];
    
    if ([doc_gubun isEqualToString:@"99"]) {
        NSString *collectTerm = [self getQueryString:param tag:@"collectTerm"];
        NSString *sendTerm = [self getQueryString:param tag:@"sendTerm"];
        
        if (collectTerm != nil && collectTerm.length > 0) {
            [preference setCreationPeroid:collectTerm];
        }
        
        if (sendTerm != nil && sendTerm.length > 0) {
            [preference setReportPeroid:sendTerm];
        }
        
        completionHandler(UIBackgroundFetchResultNoData);
        
    } else {
        
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

// [START ios_10_message_handling]
// Receive displayed notifications for iOS 10 devices.
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary *userInfo = notification.request.content.userInfo;

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[FIRMessaging messaging] appDidReceiveMessage:userInfo];

    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
      NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }

    // Print full message.
    NSLog(@"foreground : %@", userInfo);
    
    NSData *jsonData = [[userInfo objectForKey:@"msg"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    NSString *type = [dic objectForKey:@"type"];
    NSString *seq = [dic objectForKey:@"seq"];
    NSString *doc_gubun = [dic objectForKey:@"doc_gubun"];
    NSString *param = [dic objectForKey:@"param"];
    NSString *title = @"";//[dic objectForKey:@"title"];
    NSString *body = @"";//[dic objectForKey:@"body"];
    
    [DataSet sharedDataSet].push_title = title;
    [DataSet sharedDataSet].push_body = body;
    [DataSet sharedDataSet].push_type = type;
    [DataSet sharedDataSet].push_seq = seq;
    [DataSet sharedDataSet].push_doc_gubun = doc_gubun;
    [DataSet sharedDataSet].push_param = param;
    
    Preference *preference = [Preference new];
    
    if ([doc_gubun isEqualToString:@"99"]) {
        NSString *collectTerm = [self getQueryString:param tag:@"collectTerm"];
        NSString *sendTerm = [self getQueryString:param tag:@"sendTerm"];
        
        if (collectTerm != nil && collectTerm.length > 0) {
            [preference setCreationPeroid:collectTerm];
        }
        
        if (sendTerm != nil && sendTerm.length > 0) {
            [preference setReportPeroid:sendTerm];
        }
        
        completionHandler(UNNotificationPresentationOptionNone);
        
    } else {
        
        // Change this to your preferred presentation option
        completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
    }
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }

    // Print full message.
    NSLog(@"tapped ========== %@", userInfo);
    
    NSData *jsonData = [[userInfo objectForKey:@"msg"] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *e;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
    
    NSString *type = [dic objectForKey:@"type"];
    NSString *seq = [dic objectForKey:@"seq"];
    NSString *doc_gubun = [dic objectForKey:@"doc_gubun"];
    NSString *param = [dic objectForKey:@"param"];
    NSString *title = [dic objectForKey:@"title"];
    NSString *body = [dic objectForKey:@"body"];
    
    [DataSet sharedDataSet].push_title = title;
    [DataSet sharedDataSet].push_body = body;
    [DataSet sharedDataSet].push_type = type;
    [DataSet sharedDataSet].push_seq = seq;
    [DataSet sharedDataSet].push_doc_gubun = doc_gubun;
    [DataSet sharedDataSet].push_param = param;
    
    if ([doc_gubun isEqualToString:@"99"]) {
    } else {
        
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
            NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
            [noti postNotificationName:@"goPush" object:nil userInfo:userInfo];
        } else {
            [DataSet sharedDataSet].push_yn = @"Y";
            [DataSet sharedDataSet].push_userInfo = userInfo;
        }
    }
    
    completionHandler();
}

// [END ios_10_message_handling]

- (NSString *)getQueryString:(NSString *)url tag:(NSString *)tag {
    NSString *strResult = @"";
    
    NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *url2 = [url stringByReplacingOccurrencesOfString:@"hybridapp://" withString:@""];
    NSArray *urlComponents = [url2 componentsSeparatedByString:@"|"];
    
    for (NSString *keyValuePair in urlComponents)
    {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString *key = @"";
        NSString *value = @"";
        
        if (pairComponents.count == 2) {
            key = [pairComponents[0] stringByRemovingPercentEncoding];
            value = [pairComponents[1] stringByRemovingPercentEncoding];
        } else {
            //
        }
        
        [queryStringDictionary setObject:value forKey:key];
    }
    
    if ([queryStringDictionary objectForKey:tag]) {
        strResult = [queryStringDictionary objectForKey:tag];
    }
    
//    NSArray * queryItems = [[[NSURLComponents alloc] initWithString:url] queryItems];
//
//    for (NSURLQueryItem *item in queryItems) {
//        if ([tag isEqualToString:item.name]) {
//            strResult = item.value;
//            break;
//        }
//    }
    
    return strResult;
}

// [START refresh_token]
- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    NSLog(@"FCM registration token: %@", fcmToken);
    // Notify about received token.
    NSDictionary *dataDict = [NSDictionary dictionaryWithObject:fcmToken forKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"FCMToken" object:nil userInfo:dataDict];
    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
    
    Preference *p = [Preference new];
    [p setPushToken:fcmToken];
}
// [END refresh_token]

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"Unable to register for remote notifications: %@", error);
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs device token can be paired to
// the FCM registration token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSLog(@"APNs device token retrieved: %@", deviceToken);

  // With swizzling disabled you must set the APNs device token here.
  // [FIRMessaging messaging].APNSToken = deviceToken;
}

//#pragma mark - CXCallObserverDelegate Method
//- (void)callObserver:(CXCallObserver *)callObserver callChanged:(CXCall *)call {
//    if (call.hasEnded) {
//        //Disconnected
//        NSLog(@"CXCallObserver ======== Disconnected");
//
//        if (_bIsCalling) {
//            _bIsCalling = NO;
//            [SpeechHelper speakString:[DataSet sharedDataSet].push_body withCompletion:^{}];
//        }
//
//    } else if (call.isOutgoing && !call.hasConnected) {
//        //Dialing
//        NSLog(@"CXCallObserver ======== Dialing");
//        _bIsCalling = YES;
//    } else if (!call.isOutgoing && !call.hasConnected && !call.hasEnded) {
//        //Incoming
//        NSLog(@"CXCallObserver ======== Incoming");
//        _bIsCalling = YES;
//    } else if (call.hasConnected && !call.hasEnded) {
//        //Connected
//        NSLog(@"CXCallObserver ======== Connected");
//        _bIsCalling = YES;
//    }
//}
@end
