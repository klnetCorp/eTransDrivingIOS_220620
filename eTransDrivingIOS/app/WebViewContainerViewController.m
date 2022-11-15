//
//  WebViewContainerViewController.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/20.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "WebViewContainerViewController.h"
#import "ComUtil.h"

#import <KakaoLink/KakaoLink.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface WebViewContainerViewController ()<WKNavigationDelegate, WKUIDelegate, UIDocumentInteractionControllerDelegate>
{
    BOOL _isKakaoShare;
}
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *mob_webView_textView_01;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevPage;
@property (weak, nonatomic) IBOutlet UIButton *btnNextPage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end

@implementation WebViewContainerViewController

@synthesize webViewURL, webViewFileNm, webViewFilePath;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    self.btn1.layer.cornerRadius = 15;
    self.btn2.layer.cornerRadius = 15;
    self.btn3.layer.cornerRadius = 15;
    
    [self.btn1 setHidden:YES];
    [self.btn2 setHidden:YES];
    [self.btn3 setHidden:YES];
    
    if (self.webViewFileNm != nil && [self.webViewURL containsString:@"WiSutak"]) {
        [self setOnSaveButton];
    } else if (self.webViewFileNm != nil && [self.webViewURL containsString:@"reportMobileTs"]) {
        [self setOnReportTsButton];
        if ([self.webViewURL containsString:@"reportMobileTsPrint"]) {
            [self.btnPrevPage setHidden:YES];
            [self.btnNextPage setHidden:YES];
        }
    } else if (self.webViewFileNm != nil && [self.webViewURL containsString:@"reportMobilePay"]) {
        [self setOnReportButton];
        
        if ([self.webViewURL containsString:@"reportMobilePayPrint"]) {
            [self.btnPrevPage setHidden:NO];
            [self.btnNextPage setHidden:NO];
        }
    }
    
    // http://smartest.klnet.co.kr/mi330U/etruckbank/jsp/reportWiSutakPrint.jsp?dispatchNo='200608566695'
    //https://smartest.klnet.co.kr:8443/mi330U/etruckbank/jsp/reportWiSutakPrint.jsp?dispatchNo='200608566695'
    //https://smartest.klnet.co.kr/mi330U/etruckbank/jsp/reportMobilePayPrint.jsp?billNo=B171109172659&orgReadStatus=1&carCd=서울80가3366&fileNm=17-11_80가3366_운송사_C1&accountGrpCd=&reportNm=reportMobilePayPrint&supplierReadStatus=1
    NSLog(@"webViewURL ==== %@", self.webViewURL);
    NSString *tempurl = [self.webViewURL stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet];
    NSURL * url = [NSURL URLWithString:tempurl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
    
    _isKakaoShare = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setOnSaveButton {
    [self.btn1 setHidden:NO];
    [self.btn1 setTitle:@"저장하기" forState:UIControlStateNormal];
    self.btn1.tag = 1;
}

- (void)setOnReportButton {
    [self.btn1 setHidden:NO];
    [self.btn1 setTitle:@"세금계산서" forState:UIControlStateNormal];
    self.btn1.tag = 2;
    
    [self.btn2 setHidden:NO];
    [self.btn2 setTitle:@"저장하기" forState:UIControlStateNormal];
    self.btn2.tag = 1;
    
    [self.btn3 setHidden:NO];
    [self.btn3 setTitle:@"카카오톡공유" forState:UIControlStateNormal];
    self.btn3.tag = 1;
}

- (void)setOnReportTsButton {
    [self.btn2 setHidden:NO];
    [self.btn2 setTitle:@"저장하기" forState:UIControlStateNormal];
    self.btn2.tag = 2;
}

- (IBAction)clickFileSave:(UIButton *)sender {
    NSString *script = @"fileSave()";
    if (sender.tag == 1) {
        [self.webView evaluateJavaScript:script completionHandler:nil];
    } else if (sender.tag == 2) {
        NSString * url = self.webViewURL;
        url = [url stringByReplacingOccurrencesOfString:@"reportMobilePayPrint" withString:@"reportMobileSupplierBillPrint"];
        NSString *tempurl = [url stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet];
        NSURL * url2 = [NSURL URLWithString:tempurl];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url2];
        [self.webView loadRequest:request];
        
        [self.btn1 setTitle:@"거래명세서" forState:UIControlStateNormal];
        [self.btnPrevPage setHidden:YES];
        [self.btnNextPage setHidden:YES];
        self.btn1.tag = 3;
    } else {
        NSString *tempurl = [self.webViewURL stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLFragmentAllowedCharacterSet];
        NSURL * url2 = [NSURL URLWithString:tempurl];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url2];
        [self.webView loadRequest:request];
        [self.btn1 setTitle:@"세금계산서" forState:UIControlStateNormal];
        [self.btnPrevPage setHidden:NO];
        [self.btnNextPage setHidden:NO];
        self.btn1.tag = 2;
    }
}

- (IBAction)clickBtn2:(UIButton *)sender {
    NSString *script = @"";
    NSInteger tag = sender.tag;
    
    if (tag == 1 || tag == 2) {
        script = @"pdfSave()";
        [self.webView evaluateJavaScript:script completionHandler:nil];
    }
}

- (IBAction)clickBtn3:(UIButton *)sender {
    NSString *script = @"";
    NSInteger tag = sender.tag;
    
    if (tag == 1) {
        _isKakaoShare = YES;
        script = @"imgSave()";
        [self.webView evaluateJavaScript:script completionHandler:nil];
    }
}

- (IBAction)clickPrevBtn:(UIButton *)sender {
    NSString *script = @"pagingPrv()";
    [self.webView evaluateJavaScript:script completionHandler:nil];
}

- (IBAction)clickNextBtn:(UIButton *)sender {
    NSString *script = @"pagingNxt()";
    [self.webView evaluateJavaScript:script completionHandler:nil];
}

- (void) imageSaved:(UIImage *)imageSaved didFinishSavingWithError:(NSError *)error contextInfo:(id)info {
    if (error == nil) {
        if (_isKakaoShare) {
//            [[KLKImageStorage sharedStorage] uploadWithImage:imageSaved
//            success:^(KLKImageInfo *original) {
//                // 업로드 성공
//                NSLog(@"Image URL: %@", original.URL);
//
//                [[KLKTalkLinkCenter sharedCenter] sendScrapWithURL:original.URL success:^(NSDictionary* msg, NSDictionary* msg2){
//                    NSLog(@"Image msg2: %@", msg2);
//                } failure:^(NSError *error){
//
//                }];
//            } failure:^(NSError *error) {
//                // 업로드 실패
//            }];
        } else {
            //[ComUtil showAlert:self title:@"알림" message:@"이미지가 앨범에 저장되었습니다."];
        }
        
        _isKakaoShare = NO;
    } else {
        _isKakaoShare = NO;
        [ComUtil showAlert:self title:@"알림" message:@"이미지 저장에 실패하였습니다."];
    }
}

- (void)downloadFileFromURL:(NSString *)strData extention:(NSString *)ext completion:(void (^)(NSString *fileURL))completion {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *data = [[NSData alloc] initWithBase64EncodedString:strData options:0];
        
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        documentPath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@", self.webViewFilePath]];
        
        if (self.webViewFilePath != nil && self.webViewFilePath.length > 0) {
            
            if (![fileManager fileExistsAtPath:documentPath]) {
                NSError *error = nil;
                BOOL b = [fileManager createDirectoryAtPath:documentPath withIntermediateDirectories:YES attributes:nil error:&error];
                if (b) {
                    
                } else {
                    [ComUtil showAlert:self title:@"" message:error.localizedDescription];
                    completion(nil);
                }
            }
        }
        
        @try {
            NSString *filePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", self.webViewFileNm, ext]];
            NSInteger count = 0;
            while (true) {
                BOOL b = [fileManager fileExistsAtPath:filePath];
                if (b) {
                    count ++;
                    filePath = @"";
                    filePath = [documentPath stringByAppendingString:[NSString stringWithFormat:@"/%@.%@", [NSString stringWithFormat:@"%@(%ld)", self.webViewFileNm, count], ext]];
                } else {
                    break;
                }
            }
            
            BOOL b = [data writeToFile:filePath atomically:YES];
            
            if (!b) {
                [ComUtil showAlert:self title:@"" message:@"Fail create File"];
                completion(nil);
            } else {
                completion(filePath);
            }
        } @catch (NSException *exception) {
            NSLog(@"NSException : %@", exception.description);
        } @finally {
            
        }
        
    });
}

#pragma mark - WKWebviewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.indicator.hidden = NO;
    [self.indicator startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
    NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }

    decisionHandler(WKNavigationResponsePolicyAllow);
    //NSLog(@"decidePolicyForNavigationResponse");
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSURLRequest *request = navigationAction.request;
    
    NSString *absoluteString = [request URL].absoluteString;
    
    NSLog(@"absoluteString ======> %@", absoluteString);

    if([absoluteString hasPrefix:@"data:image/jpeg"] || [absoluteString hasPrefix:@"data:image/png"]){
        //Do not load the zip url in the webview.
        decisionHandler(WKNavigationActionPolicyCancel);
        //Instead use the API to download the file
        
        NSString *strData = [absoluteString componentsSeparatedByString:@","][1];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSData *data = [[NSData alloc] initWithBase64EncodedString:strData options:0];
            UIImage *image = [UIImage imageWithData:data];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSaved:didFinishSavingWithError:contextInfo:), nil);
        });
        
        self.webViewFilePath = @"images";
        
        NSString *ext = @"";
        if ([absoluteString hasPrefix:@"data:image/jpeg"]) ext = @"jpeg";
        else if ([absoluteString hasPrefix:@"data:image/png"]) ext = @"png";
        
        [self downloadFileFromURL:strData extention:ext completion:^(NSString *fileURL) {
            
            if (fileURL == nil) return;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSURL *path = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
            path = [path URLByAppendingPathComponent:self.webViewFilePath isDirectory:YES];
            path = [path URLByAppendingPathComponent:[[NSURL fileURLWithPath:fileURL] lastPathComponent]];
            
            UIDocumentInteractionController *uic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileURL]];
            uic.delegate = self;
            [uic presentPreviewAnimated:YES];
//            [uic presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
        }];
        
        return;
    } else if ([absoluteString hasPrefix:@"data:application/pdf"]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        
        if ([self.webViewURL containsString:@"reportMobilePayPrint"]) {
            self.webViewFilePath = @"eTransDriving_Spec";
        } else if ([self.webViewURL containsString:@"reportMobileSupplierBillPrint"]) {
            self.webViewFilePath = @"eTransDriving_Tax";
        }
        
        NSString *strData = [absoluteString componentsSeparatedByString:@","][1];
        
        [self downloadFileFromURL:strData extention:@"pdf" completion:^(NSString *fileURL) {
            
            if (fileURL == nil) return;
            
            UIDocumentInteractionController *uic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileURL]];
            uic.delegate = self;
            [uic presentPreviewAnimated:YES];
//            [uic presentOptionsMenuFromRect:self.view.frame inView:self.view animated:YES];
        }];
        
        return;
    }

    //Allow all other request types to load in the webview
    decisionHandler(WKNavigationActionPolicyAllow);
}


#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller {
    //_documentController = nil;
}

@end
