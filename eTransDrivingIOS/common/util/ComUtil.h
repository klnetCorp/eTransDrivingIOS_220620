//
//  ComUtil.h
//  WorkTalk
//
//  Created by juis on 2015. 9. 18..
//  Copyright (c) 2015년 juis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ComUtil : NSObject

+ (NSString*) phoneFormat:(NSString*)phonenum;
+ (UIImage*)resizeImage:(UIImage*) image maxlength:(float)max_width_height;
+ (NSString*) makeTitle:(NSString*)position subTitle:(NSString*)grade;

+ (NSString *)getDeviceId;
+ (NSString *)getMobileNo;
+ (NSString *)getOSVer;
+ (NSString *)getPhoneModel;
+ (NSString *)getAppVer;
+ (NSString *)getMacAddress;
+ (NSString *)getDownGB;

+ (void)setOnWisutakView:(UIViewController *)viewController viewUrl:(NSString *)viewUrl fileName:(NSString *)fileNm;
+ (NSString *)makeReportUrl:(NSDictionary *)dic;
+ (NSString *)nullConvert:(NSString *)str;
+ (NSString *)stringByPaddingTheLeftToLength:(NSUInteger)newLength withString:(NSString *)padString startingAtIndex:(NSUInteger)padIndex srcString:(NSString *)srcString;
+ (NSString *)encodeAES256:(NSString *)data;
+ (NSString *)euckrEncodingObjectiveC:(NSString *)str;
+ (void)showAlert:(UIViewController *)vc title:(NSString *)title message:(NSString *)message;
+ (BOOL)checkKorean:(NSString*)text;
+(BOOL)checkJailBreak;
@end
