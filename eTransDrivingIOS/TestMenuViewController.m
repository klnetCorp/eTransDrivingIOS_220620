//
//  TestMenuViewController
//  eTransDrivingIOS
//
//  Created by macbook pro 2017 on 04/03/2020.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "TestMenuViewController.h"
#import "AVCamCameraViewController.h"
#import "CloudVisionViewController.h"

typedef NS_ENUM(NSInteger, PhotoType) {
    PHOTO_CONTAINER_NO = 0
    ,PHOTO_SEAL_NO
};

@interface MenuTableCell : UITableViewCell {
    
}

@property (nonatomic, strong) IBOutlet UILabel* name;
@property (nonatomic, strong) IBOutlet UIImageView* image;

@end

@implementation MenuTableCell
- (void)configure:(NSString*)name {
    
    [self.name setText:name];
}
@end

@interface TestMenuViewController ()
{
    NSMutableArray *menus_;
}

@property (nonatomic, strong) NSData* imageData;

@end

@implementation TestMenuViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    menus_ = [NSMutableArray arrayWithObjects:@"Container No"
              , @"Seal No"
              , @"Test Menu..."
              , nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menus_ count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableCell *cell = (MenuTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    cell = [[MenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    cell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (indexPath.row > [menus_ count]) return cell;
    
    [cell configure:[menus_ objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = [indexPath row];
    switch(row) {
        case 0:
            [self goTakePhoto:PHOTO_CONTAINER_NO];
            break;
        case 1:
            [self goTakePhoto:PHOTO_SEAL_NO];
            break;
        case 2:
            break;
    }
}

- (void)goTakePhoto:(NSInteger)photoType {
    if(photoType==PHOTO_CONTAINER_NO) {
        AVCamCameraViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                instantiateViewControllerWithIdentifier:@"AVCamCameraViewController"];
        vc.delegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    } else if(photoType==PHOTO_SEAL_NO) {
        
    }
}

#pragma mark - AVCamCameraViewController delegate
- (void)onStillImageSaved:(UIViewController*)vc data:(NSData*)data {
    NSLog(@"[%s], data length=%ld", __FUNCTION__, [data length]);
    
    dispatch_async( dispatch_get_main_queue(), ^{
        self.imageData = [NSData dataWithData:data];
        CloudVisionViewController *cvvc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                           instantiateViewControllerWithIdentifier:@"CloudVisionViewController"];
        [cvvc setImageData:self.imageData];
        cvvc.delegate = self;
        [vc presentViewController:cvvc animated:NO completion:nil];
    } );
}


#pragma mark - CloudVisionViewController delegate
- (void)onClosed:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    UIViewController *parentvc = (UIViewController*)[sender presentingViewController];
    if(parentvc!=nil) [parentvc dismissViewControllerAnimated:NO completion:nil];
}

- (void)onReTakePhoto:(id)sender {
    NSLog(@"%s", __FUNCTION__);
    [(UIViewController*)sender dismissViewControllerAnimated:YES completion:nil];
}

- (void)onSelectedData:(id)sender data:(NSString*)data {
    NSLog(@"%s, selected data=%@", __FUNCTION__, data);
    [(UIViewController*)sender dismissViewControllerAnimated:YES completion:nil];

}

@end
