//
//  WebViewContainerViewController.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/20.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewContainerViewController : UIViewController

@property(strong, nonatomic) NSString *webViewURL;
@property(strong, nonatomic) NSString *webViewFileNm;
@property(strong, nonatomic) NSString *webViewFilePath;

@end

NS_ASSUME_NONNULL_END
