//
//  PopWebViewController.h
//  eTransDrivingIOS
//
//  Created by Seung Myoung Ahn on 2021/11/24.
//  Copyright © 2021 macbook pro 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopWebViewController : UIViewController <UIScrollViewDelegate, WKUIDelegate, WKNavigationDelegate>
@property (nonatomic, strong) IBOutlet WKWebView *wv_view;
@property (nonatomic, strong) WKWebViewConfiguration *config;
@property (nonatomic, strong) WKUserContentController *jsctrl;
@property (nonatomic, strong) IBOutlet UILabel *lb_title;
@property (strong, nonatomic) IBOutlet UIView *view_body;
@property (nonatomic, strong) NSString *loadUrl;
@property (nonatomic, strong) NSString *loadTitle;

- (IBAction)btn_close:(id)sender;

@end

NS_ASSUME_NONNULL_END
