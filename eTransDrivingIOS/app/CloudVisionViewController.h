//
//  CloudVIsionViewController.h
//  eTransDrivingIOS
//
//  Created by macbook pro 2017 on 04/03/2020.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CloudVisionViewControllerDelegate

- (void)onClosed:(id)sender;
- (void)onReTakePhoto:(id)sender;
- (void)onSelectedData:(id)sender data:(NSString*)data;
@end

@interface CloudVisionViewController : UIViewController

@property (nonatomic) id delegate;

- (void)setImageData:(NSData*)data;

@end

