/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 View controller for camera interface.
 */

@import UIKit;

@protocol AVCamCameraViewControllerDelegate

- (void)onStillImageSaved:(UIViewController*)vc data:(NSData*)data;

@end

@interface AVCamCameraViewController : UIViewController
@property (nonatomic) id delegate;
@end
