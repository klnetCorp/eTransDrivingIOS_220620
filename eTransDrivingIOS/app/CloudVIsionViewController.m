//
//  CloudVIsionViewController.m
//  eTransDrivingIOS
//
//  Created by macbook pro 2017 on 04/03/2020.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "CloudVisionViewController.h"

@interface CloudResultTableCell : UITableViewCell {
    NSDictionary *annotations_;
}

@property (nonatomic) IBOutlet UITextField* desc;
@property (nonatomic) IBOutlet UIImageView* image;

@end

@implementation CloudResultTableCell
- (void)configure:(NSDictionary *)annotations  {
    
    annotations_ = annotations;
    [self.desc setText:[annotations objectForKey:@"description"]];
}
@end

@interface CloudVisionViewController () {
    NSData *imageData_;
    UIImage *image_;
    NSArray *textAnnotations_;
}

@property (nonatomic) IBOutlet UILabel *imageInfo;
@property (nonatomic) IBOutlet UILabel *visionTextResult;
@property (nonatomic) IBOutlet UILabel *visionFaceResult;
@property (nonatomic) IBOutlet UIImageView *ivCropImage;
@property (nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) IBOutlet NSLayoutConstraint *ivHeightConstraint;


@end

@implementation CloudVisionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    

    [self runVisionApi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate/data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [textAnnotations_ count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CloudResultTableCell";
    CloudResultTableCell *cell = (CloudResultTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //    cell = [[MenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (indexPath.row > [textAnnotations_ count]) return cell;
    
    [cell configure:[textAnnotations_ objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    
    NSDictionary *annotation = [textAnnotations_ objectAtIndex:row];
    
    NSLog(@"%@", annotation);
    
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];
    NSDictionary *dic = @{@"orcText": [annotation objectForKey:@"description"], @"imageData": imageData_};
    [noti postNotificationName:@"conNoToServer" object:nil userInfo:dic];
}

- (IBAction)actionReTakePhoto:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];

    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(onReTakePhoto:)]) {
        [self.delegate onReTakePhoto:self];
    }
}

- (IBAction)actionClose:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if(self.delegate!=nil && [self.delegate respondsToSelector:@selector(onClosed:)]) {
        [self.delegate onClosed:self];
    }
}

- (void)setImageData:(NSData*)image {
    imageData_ = [NSData dataWithData:image];
}

- (NSData*)getImageData {
    return imageData_;
}

- (void)runVisionApi {
    [self startAnimating];

    if(imageData_!=nil) {
        image_ = [UIImage imageWithData:imageData_];
        
        NSString *encodedText = [NSString string];
        encodedText = [self base64EncodeImage:image_];
        
        [self.ivCropImage setImage:image_];
        self.imageInfo.text = [NSString stringWithFormat:@"image width=%f\nimage height=%f\n전송 중입니다. 잠시만 기다려주세요."
                               , image_.size.width, image_.size.height];
        

        [self createRequest:encodedText];

//        NSThread *thTime = [[NSThread alloc] initWithTarget:self selector:@selector(requestWorker) object:nil];
//        [thTime start];
    } else {
        [self stopAnimating];
        [self.imageInfo setText:@"이미지 데이터가 없습니다!"];
    }
}

- (void)requestWorker {
}


- (UIImage *) resizeImage: (UIImage*) image toSize: (CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *) base64EncodeImage: (UIImage*)image {
    NSData *imagedata = UIImagePNGRepresentation(image);
    
    // Resize the image if it exceeds the 2MB/4 API limit
    if ([imagedata length] > 2097152/4) {
        CGSize oldSize = [image size];
        CGSize newSize = CGSizeMake(800, oldSize.height / oldSize.width * 800);
        image = [self resizeImage: image toSize: newSize];
        imagedata = UIImagePNGRepresentation(image);
    }
    
    NSString *base64String = [imagedata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return base64String;
}

- (void) createRequest: (NSString*)imageData {
    // Create our request URL
    
    NSString *urlString = @"https://vision.googleapis.com/v1/images:annotate?key=";
    NSString *API_KEY = @"AIzaSyBTCq4IiYhDfUSP4nh6sdg5vjZuv_lQqzE";
    
    NSString *requestString = [NSString stringWithFormat:@"%@%@", urlString, API_KEY];
    
    NSURL *url = [NSURL URLWithString: requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod: @"POST"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request
     addValue:[[NSBundle mainBundle] bundleIdentifier]
     forHTTPHeaderField:@"X-Ios-Bundle-Identifier"];
    
    // Build our API request
    NSDictionary *paramsDictionary =
    @{@"requests":@[
              @{@"image":
                    @{@"content":imageData},
                @"features":@[
                        //                @{@"type":@"LABEL_DETECTION",
                        //                  @"maxResults":@10},
                        //                @{@"type":@"FACE_DETECTION",
                        //                  @"maxResults":@10}
                        @{@"type":@"TEXT_DETECTION",
                          @"maxResults":@10}
                        ]}
              ]};
    
    NSError *error;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:paramsDictionary options:0 error:&error];
    [request setHTTPBody: requestData];
    
    // Run the request on a background thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self runRequestOnBackgroundThread: request];
    });
}

- (void)runRequestOnBackgroundThread: (NSMutableURLRequest*) request {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^ (NSData *data, NSURLResponse *response, NSError *error) {
        [self analyzeResults:data];
    }];
    [task resume];
}

- (void)analyzeResults: (NSData*)dataToParse {
    __weak typeof(self)weakSelf = self;
    
    // Update UI on the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        if(dataToParse==nil) {
            NSLog(@"Error, response data is nil");
            strongSelf.visionTextResult.text = @"Vision API\nInvalid response";
            strongSelf.visionFaceResult.text = @"";
            return;
        }

        NSError *e = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:dataToParse options:kNilOptions error:&e];
        
        NSArray *responses = [json objectForKey:@"responses"];
        NSLog(@"Vision API response=%@", responses);
        NSDictionary *responseData = [responses objectAtIndex: 0];
        NSDictionary *errorObj = [json objectForKey:@"error"];
        
        [strongSelf stopAnimating];
//        self.ivCropImage.hidden = true;
        strongSelf.visionTextResult.hidden = false;
        strongSelf.visionFaceResult.hidden = false;
        
        // Check for errors
        if (errorObj) {
            NSString *errorString1 = @"Error code ";
            NSString *errorCode = [errorObj[@"code"] stringValue];
            NSString *errorString2 = @": ";
            NSString *errorMsg = errorObj[@"message"];
            strongSelf.visionTextResult.text = [NSString stringWithFormat:@"%@%@%@%@", errorString1, errorCode, errorString2, errorMsg];
        } else {
/*
            // Get face annotations
            NSDictionary *faceAnnotations = [responseData objectForKey:@"faceAnnotations"];
            if (faceAnnotations != NULL) {
                // Get number of faces detected
                NSInteger numPeopleDetected = [faceAnnotations count];
                NSString *peopleStr = [NSString stringWithFormat:@"%lu", (unsigned long)numPeopleDetected];
                NSString *faceStr1 = @"People detected: ";
                NSString *faceStr2 = @"\n\nEmotions detected:\n";
                self.visionFaceResult.text = [NSString stringWithFormat:@"%@%@%@", faceStr1, peopleStr, faceStr2];
                
                NSArray *emotions = @[@"joy", @"sorrow", @"surprise", @"anger"];
                NSMutableDictionary *emotionTotals = [NSMutableDictionary dictionaryWithObjects:@[@0.0,@0.0,@0.0,@0.0]forKeys:@[@"sorrow",@"joy",@"surprise",@"anger"]];
                NSDictionary *emotionLikelihoods = @{@"VERY_LIKELY": @0.9, @"LIKELY": @0.75, @"POSSIBLE": @0.5, @"UNLIKELY": @0.25, @"VERY_UNLIKELY": @0.0};
                
                // Sum all detected emotions
                for (NSDictionary *personData in faceAnnotations) {
                    for (NSString *emotion in emotions) {
                        NSString *lookup = [emotion stringByAppendingString:@"Likelihood"];
                        NSString *result = [personData objectForKey:lookup];
                        double newValue = [emotionLikelihoods[result] doubleValue] + [emotionTotals[emotion] doubleValue];
                        NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:newValue];
                        [emotionTotals setValue:tempNumber forKey:emotion];
                    }
                }
                
                // Get emotion likelihood as a % and display it in the UI
                for (NSString *emotion in emotionTotals) {
                    double emotionSum = [emotionTotals[emotion] doubleValue];
                    double totalPeople = [faceAnnotations count];
                    double likelihoodPercent = emotionSum / totalPeople;
                    NSString *percentString = [[NSString alloc] initWithFormat:@"%2.0f%%",(likelihoodPercent*100)];
                    NSString *emotionPercentString = [NSString stringWithFormat:@"%@%@%@%@", emotion, @": ", percentString, @"\r\n"];
                    strongSelf.visionFaceResult.text = [strongSelf.visionFaceResult.text stringByAppendingString:emotionPercentString];
                }
            } else {
                strongSelf.visionFaceResult.text = @"No faces found";
            }
*/
            // Get label annotations
            NSDictionary *textAnnotations = [responseData objectForKey:@"textAnnotations"];
            NSInteger numTexts = [textAnnotations count];
            NSMutableArray *texts = [[NSMutableArray alloc] init];
            if (numTexts > 0) {
                for (NSDictionary *text in textAnnotations) {
                    [texts addObject:text];
                }
                strongSelf->textAnnotations_ = [self findContainerNo:[NSArray arrayWithArray:texts]];
                
                strongSelf.visionTextResult.text = [NSString stringWithFormat:@"%ld texts found", [strongSelf->textAnnotations_ count]];
                
                if ([strongSelf->textAnnotations_ count] > 0) {
                    strongSelf.imageInfo.text = @"\nOCR 처리상태: OCR 응답 완료.";
                } else {
                    strongSelf.imageInfo.text = @"\nOCR 처리상태: 컨테이너 번호 형식이 아닙니다.";
                }
                
                [strongSelf refreshData];
            } else {
//                strongSelf.visionTextResult.text = @"번호를 인식하지 못했습니다";
                strongSelf.imageInfo.text = @"\n번호를 인식하지 못했습니다";
            }
        }
    });
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:true completion:NULL];
}

- (void)startAnimating {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];

}

- (void)stopAnimating {
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;

}

- (void)refreshData {
    [self.tableView reloadData];
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (NSArray *)findContainerNo:(NSArray *)array {
//    컨테이너 번호 규칙
//    https://regexr.com
//    알파벳3자리(owner code) + 'U' + 숫자6자리(serial no) + 숫자1자리(check digit, option)
//    regular expression                            '찾는 문자열 형태'
//    expr1: /[a-zA-Z]{3}U[0-9]{7}/g                  'xxxU1234567'
//    expr2: /[a-zA-Z]{3}U[0-9]{6}[0-9 -]{2}/g        'xxxU123456 7', 'xxxU123456-7'
    
    NSMutableArray<NSDictionary *> *conNoList = [NSMutableArray new];
    NSMutableArray<NSString *> *ownerGroup = [NSMutableArray new];
    NSMutableArray<NSString *> *serialGroup = [NSMutableArray new];
    
    NSDictionary *dic = array[0];
    
    NSString *conNo = [dic objectForKey:@"description"];
    NSArray *ocrList = [conNo componentsSeparatedByString:@"\n"];
    
    for (NSString *text in ocrList) {
        //문자열에서 개행문자 제거, 공백문자 제거
        NSString *text2 = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        text2 = [text2 stringByReplacingOccurrencesOfString:@" " withString:@""];
        //문자열 대문자로 변경
        text2 = [text2 uppercaseString];
        
        NSLog(@"text2 = %@", text2);
        
        if ([self isMatchedPattern:@"[a-zA-Z]{3}U[0-9]{7}" text:text2]) {
            [conNoList addObject:@{@"description": [self correctDigitCode:text2]}];
            return conNoList;
        }
        
        //'xxxU123456-7' 패턴 검사 성공 시, 처리중인 것들 삭제하고 현재 값만 전달
        if ([self isMatchedPattern:@"[a-zA-Z]{3}U[0-9]{6}[0-9 -]{2}" text:text2]) {
            [conNoList addObject:@{@"description": [self correctDigitCode:text2]}];
            return conNoList;
        }
        
        //문자열이 영문3자리 + "U"이면 owner 그룹에 추가
        if ([self isMatchedPattern:@"[a-zA-Z]{3}U" text:text2]) {
            [ownerGroup addObject:text2];
        } else if ([self isMatchedPattern:@"[0-9]{6,8}" text:text2]) {
            [serialGroup addObject:text2];
        } else {
            continue;
        }
    }
    
    //ownerGroup 못찾았을 경우 workaround
    if (ownerGroup.count == 0)  {
        for (NSString *text in ocrList) {
            //문자열에서 개행문자 제거, 공백문자 제거
            NSString *text2 = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            text2 = [text2 stringByReplacingOccurrencesOfString:@" " withString:@""];
            //문자열 대문자로 변경
            text2 = [text2 uppercaseString];
            
            NSLog(@"[ownerGroup]text2 = %@", text2);
            
            //문자열이 영문4자리 이고 숫자 6~8자리이면
            if ([self isMatchedPattern:@"[a-zA-Z]{4}[0-9]{6,8}" text:text2]) {
                char *str = (char *)[text2 UTF8String];
                str[3] = 'U';
                text2 = [NSString stringWithUTF8String:str];
                
                [conNoList addObject:@{@"description": [self correctDigitCode:text2]}];
                return conNoList;
            }
            
            if ([self isMatchedPattern:@"[a-zA-Z]{4}" text:text2]) {
                [ownerGroup addObject:text2];
            } else {
                continue;
            }
        }
    }
    
    if (serialGroup.count == 0)  {
        for (NSString *text in ocrList) {
            //문자열에서 개행문자 제거, 공백문자 제거
            NSString *text2 = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            text2 = [text2 stringByReplacingOccurrencesOfString:@" " withString:@""];
            //문자열 대문자로 변경
            text2 = [text2 uppercaseString];
            
            NSLog(@"[serialGroup]text2 = %@", text2);
            
            //문자열이 영문4자리 이면 owner 그룹에 추가
            if ([self isMatchedPattern:@"[0-9]{6,8}" text:text2]) {
                [serialGroup addObject:text2];
            } else {
                continue;
            }
        }
    }
    
    for (NSString *owner in ownerGroup) {
        for (NSString *serial in serialGroup) {
            [conNoList addObject:@{@"description": [NSString stringWithFormat:@"%@%@", owner, serial]}];
        }
    }
    
    NSMutableArray<NSDictionary *> *recommandList = [NSMutableArray new];
    for (NSDictionary *item in conNoList) {
        NSString *desc = [item objectForKey:@"description"];
        if (desc.length >= 10) {
            [recommandList addObject:@{@"description": [self correctDigitCode:desc]}];
        } else {
            [recommandList addObject:item];
        }
    }
    
    return recommandList;
}

- (BOOL)isMatchedPattern:(NSString *)pattern text:(NSString *)text {
    BOOL result = false;
    
    NSError *error;
    NSRegularExpression *regx = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regx numberOfMatchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    if (numberOfMatches > 0) result = true;
    
    return result;
}

- (NSString *)correctDigitCode:(NSString *)containerNumber {
    
    if (containerNumber.length < 10) return containerNumber;
    
    if (containerNumber.length >= 11) containerNumber = [containerNumber substringToIndex:11];
    
    return containerNumber;
}
@end
