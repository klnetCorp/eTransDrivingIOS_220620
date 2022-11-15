//
//  ReportServiceManager.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/26.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReportServiceManager : NSObject <NSStreamDelegate>
+ (instancetype)sharedInstance;
- (void)startReportService;
- (void)stopReportService;
- (void)initNetworkCommunication;
- (void)sendPacket;
@end

NS_ASSUME_NONNULL_END
