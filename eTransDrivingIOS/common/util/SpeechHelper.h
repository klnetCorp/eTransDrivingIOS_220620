//
//  SpeechHelper.h
//  eTransDrivingIOS
//
//  Created by SeongWoo Lee on 2020/11/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SpeechCompletionBlock)(void);

@interface SpeechHelper : NSObject<AVSpeechSynthesizerDelegate>
@property(nonatomic, strong)SpeechCompletionBlock completion;
+ (void)speakString:(NSString *)str withCompletion:(SpeechCompletionBlock)completion;
@end

NS_ASSUME_NONNULL_END
