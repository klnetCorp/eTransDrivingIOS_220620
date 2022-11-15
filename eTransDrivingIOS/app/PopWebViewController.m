//
//  PopWebViewController.m
//  eTransDrivingIOS
//
//  Created by Seung Myoung Ahn on 2021/11/24.
//  Copyright © 2021 macbook pro 2017. All rights reserved.
//

#import "PopWebViewController.h"

@interface PopWebViewController ()

@end

@implementation PopWebViewController
@synthesize wv_view, config, jsctrl, loadUrl, lb_title, loadTitle, view_body;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeWebView];
    // Do any additional setup after loading the view from its nib.
}

-(void) makeWebView { // webView 세팅
    // CGRect frame = [[UIScreen mainScreen]bounds];
    
    lb_title.text = loadTitle;
    
    
    config = [[WKWebViewConfiguration alloc] init];
    jsctrl = [[WKUserContentController alloc] init];
    WKProcessPool * wKProcessPool = [[WKProcessPool alloc] init];
    WKPreferences * wKPreferences = [[WKPreferences alloc] init];
    wKPreferences.javaScriptEnabled = YES;
    wKPreferences.javaScriptCanOpenWindowsAutomatically = YES;
    config.userContentController = jsctrl;
    config.processPool = wKProcessPool;
    config.preferences = wKPreferences;
    
    //CGRect frame = [[UIScreen mainScreen]bounds];
    CGRect frame = view_body.bounds;
    wv_view = [[WKWebView alloc] initWithFrame:frame configuration:config];
    wv_view.scrollView.delegate = nil;
    wv_view.translatesAutoresizingMaskIntoConstraints = false;
    [self.view_body addSubview:wv_view];
    
    self.wv_view.navigationDelegate = self;         // 네비게이션 델리케이드
    [self.wv_view setNavigationDelegate:self];
    self.wv_view.UIDelegate = self;                 // UI 델리케이트
    wv_view.scrollView.bounces = false;
    
    NSURL *targetUrl = [NSURL URLWithString:loadUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetUrl];
    [wv_view loadRequest:request];
}

- (IBAction)btn_close:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - WKNavigationDelegate

-(void) webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {  //webViewDidStartLoad
    NSLog(@"Start");
}

-(void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation { //webViewDidFinishLoad
    NSLog(@"Finish");
}

-(void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error { //disFailLoadWithError
    NSLog(@"Fail");
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler { //shouldsStartLoadWithRequest
    
    //20190501 LHY 외부 앱 실행
    NSString* scheme= [[navigationAction.request URL] scheme];
    if([scheme isEqualToString:@"http"]==NO
       && [scheme isEqualToString:@"https"] == NO
       && [scheme isEqualToString:@"tel"] == YES
       && [scheme isEqualToString:@"sms"] == NO
       && [scheme isEqualToString:@"mailto"] == NO
       && [scheme isEqualToString:@"geo"] == NO
       && [scheme isEqualToString:@"gap"] == NO
       && [scheme isEqualToString:@"itranskey"] == NO
       && [scheme isEqualToString:@"about"] == NO) {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"decidePolicyForNavigationResponse");
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - WKUIDelegate
// javascript alert
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

// javascript confirm
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"취소" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
