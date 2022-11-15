//
//  SignViewController.m
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/20.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "SignViewController.h"
#import "LCPaintView.h"

@interface SignViewController ()
{
    
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *btnClear;
@property (weak, nonatomic) IBOutlet UIButton *btnComplete;
@property (nonatomic, weak) LCPaintView *paintView;
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnClear.layer.cornerRadius = 25;
    self.btnComplete.layer.cornerRadius = 25;
    
    LCPaintView *paintView = ({
        LCPaintView *paintView = [[LCPaintView alloc] init];
        paintView.lineWidth = 5.0f;
        paintView.lineColor = [UIColor blackColor];
        paintView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        [self.contentView insertSubview:paintView atIndex:0];
        self.paintView = paintView;
    });
    
    
    
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)clickClose:(UIButton *)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)clickClear:(UIButton *)sender {
    
    [self.paintView clear];
}
- (IBAction)clickComplete:(UIButton *)sender {
    UIImage *image = [self.paintView asImage];
    
    NSDictionary *userInfo = @{@"signImage": image};
    
    NSNotificationCenter * noti = [NSNotificationCenter defaultCenter];
    [noti postNotificationName:@"sendSignImage" object:nil userInfo:userInfo];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)asImage {
    UIGraphicsBeginImageContextWithOptions(self.contentView.bounds.size, false, 0.0);
    [self.contentView.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    UIImageView * iv = [[UIImageView alloc] initWithImage:img];
    [self.contentView addSubview:iv];
    
    return img;
}
@end
