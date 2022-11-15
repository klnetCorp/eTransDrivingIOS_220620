//
//  PacketController.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PacketController : NSObject
- (void)clearPacket;
- (NSInteger)getGpsDataSize;
- (NSData *)makePacket;
- (NSInteger)makePeriodReportGpsData:(NSString *)strEventCode;
@end

NS_ASSUME_NONNULL_END
