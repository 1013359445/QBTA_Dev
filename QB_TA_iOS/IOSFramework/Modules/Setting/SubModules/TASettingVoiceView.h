//
//  TASettingVoiceView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//  声音设置

#import "TABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TASettingVoiceView : TABaseView

@end


@ class TAVoiceView;
@protocol TAVoiceViewProtocol <NSObject>
- (void)voiceSliderView:(TAVoiceView *)view didiValueChange:(NSString *)value;
@end

@interface TAVoiceView : UIView
@property (nonatomic, retain)UISlider       *slider;
- (instancetype)initWithDelegate:(id)delegate title:(NSString *)title;
@end
NS_ASSUME_NONNULL_END
