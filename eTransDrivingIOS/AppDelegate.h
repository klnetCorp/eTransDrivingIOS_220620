//
//  AppDelegate.h
//  eTransDrivingIOS
//
//  Created by macbook pro 2017 on 04/03/2020.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) UIWindow *window;
- (void)saveContext;


@end

