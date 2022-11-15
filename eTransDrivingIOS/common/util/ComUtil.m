//
//  ComUtil.m
//  WorkTalk
//
//  Created by juis on 2015. 9. 18..
//  Copyright (c) 2015년 juis. All rights reserved.
//

#import "ComUtil.h"
#import "NICInfoSummary.h"
#import "DataSet.h"
#import "OpenUDID.h"
#import "WebViewContainerViewController.h"
#import <CommonCrypto/CommonCryptor.h>

@import Firebase;

#import <sys/utsname.h>

@implementation ComUtil

+ (NSString*) phoneFormat:(NSString*) phonenum {
    
    phonenum = [phonenum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if(phonenum.length == 0) {
        phonenum = @" ";
        return phonenum;
    }
    
    NSString *strTel = phonenum;
    NSArray *strDDD = [[NSArray alloc] initWithObjects:@"02", @"031", @"032", @"033", @"041", @"042", @"043", @"051", @"052", @"053", @"054", @"055", @"061", @"062", @"063", @"064", @"010", @"011", @"012", @"013", @"015", @"016", @"017", @"018", @"019",    @"070", @"080", @"081", @"082", @"083", @"086",nil];
    
    NSRange range_02 = {0,2};
    NSRange range_03 = {0,3};
    
    if(strTel.length < 9) {
        return strTel;
    } else if([[strTel substringWithRange:range_02] isEqualToString:[strDDD objectAtIndex:0]]) {
        
        NSRange range_2len4 = {2, (strTel.length -2-4)};
        NSRange range_4leng = {2+(strTel.length -2-4), strTel.length-2-(strTel.length-2-4)};
        
        strTel = [NSString stringWithFormat:@"%@-%@-%@", [strTel substringWithRange:range_02], [strTel substringWithRange:range_2len4],[strTel substringWithRange:range_4leng]];
    } else {
        for (int i = 1; i < strDDD.count; i++) {
            if([[strTel substringWithRange:range_03] isEqualToString:[strDDD objectAtIndex:i]]) {
                NSRange range_3len4 = {3, (strTel.length-3-4)};
                NSRange range_4leng = {3+(strTel.length-3-4), strTel.length-3-(strTel.length-3-4)};
                
                strTel = [NSString stringWithFormat:@"%@-%@-%@", [strTel substringWithRange:range_03], [strTel substringWithRange:range_3len4],[strTel substringWithRange:range_4leng]];
            }
        }
    }

    return strTel;
}


+ (UIImage *)resizeImage : (UIImage *)image maxlength:(float)max_width_height {
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    
    if (actualHeight <=  max_width_height && actualWidth <= max_width_height) {
        return image;
    } else {
        float imgRatio = 1;
        
        if (actualHeight < actualWidth) {
            imgRatio = max_width_height/actualWidth;
        } else {
            imgRatio = max_width_height/actualHeight;
        }
        CGRect rect = CGRectMake(0.0, 0.0, actualWidth*imgRatio, actualHeight*imgRatio);
        
        UIGraphicsBeginImageContext(rect.size);
        [image drawInRect:rect];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

+ (NSString*) makeTitle:(NSString*)position subTitle:(NSString*)grade {
    NSString *ret = @"";
    
    position = [position stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    grade = [grade stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([position length] > 0) {
        ret = position;
    } else {
        ret = grade;
    }
    
    return ret;
}




+ (NSString *)getDeviceId {
    return [OpenUDID value];
}

+ (NSString *)getMobileNo {
    
    NSString* mac_address = [self getMacAddress];
    
    NSString *testNo = @"01023427113";
    
    if ([mac_address isEqualToString:@"ACEE9EAEA373"]) {
        [DataSet sharedDataSet].g_fcUserId = testNo;
        return testNo;
    }
    //g4
    if ([mac_address isEqualToString:@"C49A028A820C"]) {
        [DataSet sharedDataSet].g_fcUserId = testNo;
        return testNo;
    }
    //A90 - juis
    if ([mac_address isEqualToString:@"ECAA257C1F7D"]) {
        [DataSet sharedDataSet].g_fcUserId = testNo;
        return testNo;
    }
    
    [DataSet sharedDataSet].g_fcUserId = @"01000000000";
    
    return @"01000000000";
}

+ (NSString *)getOSVer {
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)getPhoneModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)getAppVer {
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];

    NSString *version = infoDictionary[@"CFBundleShortVersionString"];
    //NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    //NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
    
    return version;
}

+ (NSString *)getMacAddress {
    NICInfoSummary* summary = [[NICInfoSummary alloc] init];

    // en0 is for WiFi
    NICInfo* wifi_info = [summary findNICInfo:@"en0"];

    // you can get mac address in 'XX-XX-XX-XX-XX-XX' form
    NSString* mac_address = [wifi_info getMacAddressWithSeparator:@""];

    // ip can be multiple
    if(wifi_info.nicIPInfos.count > 0)
    {
        NICIPInfo* ip_info = [wifi_info.nicIPInfos objectAtIndex:0];
        NSString* ip = ip_info.ip;
        NSString* netmask = ip_info.netmask;
        NSString* broadcast_ip = ip_info.broadcastIP;
    }
    else
    {
        NSLog(@"WiFi not connected!");
    }
    
    return mac_address;
}

+ (NSString *)getDownGB {
    return @"market";
}

+ (void)setOnWisutakView:(UIViewController *)viewController viewUrl:(NSString *)viewUrl fileName:(NSString *)fileNm {
    WebViewContainerViewController *webViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewContainerViewController"];
    if (webViewController) {
        webViewController.webViewURL = [NSString stringWithFormat:@"%@%@", DOC_CONNECTION_URL, viewUrl];
        webViewController.webViewFileNm = fileNm;
//        [webViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        [viewController presentViewController:webViewController animated:YES completion:nil];
    }
}

+ (NSString *)makeReportUrl:(NSMutableDictionary *)dic {
    NSString *url = [NSString stringWithFormat:@"%@%@.jsp?", [dic valueForKey:@"url"], [dic valueForKey:@"reportNm"]];
    [dic removeObjectForKey:@"url"];
    
    for (NSString *key in dic) {
        url = [url stringByAppendingString:@"&"];
        url = [url stringByAppendingString:key];
        url = [url stringByAppendingString:@"="];
        url = [url stringByAppendingString:[dic valueForKey:key]];
    }
    
    url = [url stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    
    return url;
}

+ (NSString *)nullConvert:(NSString *)str {
    if (str == nil || [str isEqualToString:@"null"]) {
        return @"";
    }
    
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)stringByPaddingTheLeftToLength:(NSUInteger)newLength withString:(NSString *)padString startingAtIndex:(NSUInteger)padIndex srcString:(NSString *)srcString
{
    if ([srcString length] <= newLength)
        return [[@"" stringByPaddingToLength:newLength - [srcString length] withString:padString startingAtIndex:padIndex] stringByAppendingString:srcString];
    else
        return [srcString copy];
}

+ (NSString *)encodeAES256:(NSString *)data {
    NSData *d = [data dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *enc = [d AES256Encrypt:@"abcdefghijklmnop"];
    NSString *key = @"abcdefghijklmnop";
    
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    size_t bufferSize = [d length] + kCCBlockSizeAES128;
    size_t encryptedByteSize = 0;
    void *buffer = malloc(bufferSize);
    if (!buffer) {
        return nil;
    }
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding, keyPtr, kCCKeySizeAES256, NULL, [d bytes], [d length], buffer, bufferSize, &encryptedByteSize);
    
    if (status == kCCSuccess) {
        NSData *data = [NSData dataWithBytesNoCopy:buffer length:encryptedByteSize];
        return[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    free(buffer);
    return nil;
}

+ (NSString *)euckrEncodingObjectiveC:(NSString *)str {
    NSMutableString *outputQuery = [NSMutableString string];
    NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
    const char * source = [str cStringUsingEncoding:encoding];
    NSInteger sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' ') {
            [outputQuery appendString:@"+"];
            
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || (thisChar >= 'a' && thisChar <= 'z') || (thisChar >= 'A' && thisChar <= 'Z') || (thisChar >= '0' && thisChar <= '9')) {
            [outputQuery appendFormat:@"%c", thisChar];
            
        } else {
            [outputQuery appendFormat:@"%%%02X", thisChar];
            
        }
        
    }
    return outputQuery;
}

+ (void)showAlert:(UIViewController *)vc title:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+ (BOOL)checkKorean:(NSString*)text {
    
    NSString *check = @"^[ㄱ-ㅎㅏ-ㅣ가-힣]{1,3}";
    NSRange match = [text rangeOfString:check options:NSRegularExpressionSearch];
    if (NSNotFound == match.location)
    {
        return NO;
    }
    return YES;
}

+(BOOL)checkJailBreak {
    NSArray *checkList=[NSArray arrayWithObjects:@"/Applications/Cydia.app",
                                                @"/Applications/RockApp.app",
                                                @"/Applications/Icy.app",
                                                @"/usr/sbin/sshd",
                                                @"/usr/bin/sshd",
                                                @"/usr/libexec/sftp-server",
                                                @"/Applications/WinterBoard.app",
                                                @"/Applications/SBSettings.app",
                                                @"/Applications/MxTube.app",
                                                @"/Applications/IntelliScreen.app",
                                                @"/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                                                @"/Applications/FakeCarrier.app",
                                                @"/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                                                @"/private/var/lib/apt",
                                                @"/Applications/blackra1n.app",
                                                @"/private/var/stash",
                                                @"/private/var/mobile/Library/SBSettings/Themes",
                                                @"/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                                                @"/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                                                @"/private/var/tmp/cydia.log",
                                                @"/private/var/lib/cydia",
                                                nil];
    for (NSString *filePath in checkList){
        if([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
            NSLog(@"JailBroken:%@", filePath);
            return YES;
        }
    }
    return NO;
}

@end
