//
//  SpeechHelper.m
//  eTransDrivingIOS
//
//  Created by SeongWoo Lee on 2020/11/23.
//  Copyright © 2020 macbook pro 2017. All rights reserved.
//

#import "SpeechHelper.h"

@implementation SpeechHelper
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    if (_completion) {
        _completion();
    }
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    NSLog(@"willSpeakRangeOfSpeechString");
}

- (void)performSpeech:(NSString *)str {
    
    if (str == nil || str.length == 0 || ![str containsString:@"#TTS#"]) return;
    
    NSString *ttsStr = [str componentsSeparatedByString:@"#TTS#"][0];
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:ttsStr];
    utterance.rate = AVSpeechUtteranceDefaultSpeechRate;
    utterance.volume = 90.0f;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"ko-KR"];
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc] init];
    synthesizer.delegate = self;
    [synthesizer speakUtterance:utterance];
}

- (void)speakString:(NSString *)str withCompletion:(SpeechCompletionBlock)completion {
    _completion = completion;
    [self performSpeech:str];
}

+ (void)speakString:(NSString *)str withCompletion:(SpeechCompletionBlock)completion {
    [[self new] speakString:str withCompletion:completion];
}
@end
