//
//  NSData+AES.h
//  eTransDrivingIOS
//
//  Created by Weed on 2020/08/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (AES)

- (NSData *) AES128Encrypt: (NSString *) key;
- (NSData *) AES128Decrypt: (NSString *) key;

- (NSData *) AES256Encrypt: (NSString *) key;
- (NSData *) AES256Decrypt: (NSString *) key;

@end

NS_ASSUME_NONNULL_END
