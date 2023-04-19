//
//  TASettingVoiceView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASettingVoiceView.h"
#import "TASegmentedControl.h"
#import "TARoomManager.h"

@interface TASettingVoiceView () <TAVoiceViewProtocol>
@property (nonatomic, retain)TAVoiceView    *mainVoice;
@property (nonatomic, retain)TAVoiceView    *mikeVoice;
@property (nonatomic, retain)TASegmentedControl *switch3D;
@property (nonatomic, retain)TASegmentedControl *switchBGMusic;

@end

@implementation TASettingVoiceView
+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(816), kRelative(570));
}

- (void)loadSubViews
{
    [self addSubview:self.mainVoice];
    [_mainVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(120));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(-60));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    [self addSubview:self.mikeVoice];
    [_mikeVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mainVoice.mas_bottom).mas_offset(kRelative(80));
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(-60));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    [self addSubview:self.switch3D];
    [self addSubview:self.switchBGMusic];
    [_switch3D mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mikeVoice.mas_bottom).mas_offset(kRelative(80));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(150));
        make.height.mas_equalTo(kRelative(60));
    }];
    [_switchBGMusic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_switch3D.mas_right).mas_offset(kRelative(50));
        make.top.width.height.mas_equalTo(_switch3D);
    }];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *volume = [defaults objectForKey:DefaultsKeyAudioCaptureVolume];
    [self.mikeVoice setSliderValue:volume];
    
    volume = [defaults objectForKey:DefaultsKeyAudioPlayoutVolume];
    [self.mainVoice setSliderValue:volume];
}

- (void)voiceSliderView:(TAVoiceView *)view didiValueChange:(NSString *)value;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (view.tag == 1001){
        [[TRTCCloud sharedInstance] setAudioPlayoutVolume:value.intValue];
        [defaults setObject:value forKey:DefaultsKeyAudioPlayoutVolume];
    }else {
        [[TRTCCloud sharedInstance] setAudioCaptureVolume:value.intValue];
        [defaults setObject:value forKey:DefaultsKeyAudioCaptureVolume];
    }
}

-(TAVoiceView *)mainVoice
{
    if (!_mainVoice)
    {
        _mainVoice = [[TAVoiceView alloc] initWithDelegate:self title:@"主音量"];
        _mainVoice.tag = 1001;
    }
    return _mainVoice;
}

-(TAVoiceView *)mikeVoice
{
    if (!_mikeVoice)
    {
        _mikeVoice = [[TAVoiceView alloc] initWithDelegate:self title:@"麦克风音量"];
        _mikeVoice.tag = 1002;
    }
    return _mikeVoice;
}

-(TASegmentedControl *)switch3D
{
    if (!_switch3D){
        _switch3D = [[TASegmentedControl alloc] initWithTitle:@"3D范围语音"];
        [_switch3D.segmented setSelectedSegmentIndex:1];
    }
    return _switch3D;
}

-(TASegmentedControl *)switchBGMusic
{
    if (!_switchBGMusic){
        _switchBGMusic = [[TASegmentedControl alloc] initWithTitle:@"背景音乐"];
        [_switchBGMusic.segmented setSelectedSegmentIndex:0];
    }
    return _switchBGMusic;
}

@end

@interface TAVoiceView ()
@property (nonatomic, weak)id<TAVoiceViewProtocol> delegate;
@property (nonatomic, retain)UIImageView    *iconImageView;
@property (nonatomic, retain)UISlider       *slider;
@property (nonatomic, retain)UILabel        *valueLabel;
@property (nonatomic, retain)UILabel        *titleLabel;
@end

@implementation TAVoiceView
- (instancetype)initWithDelegate:(id)delegate title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;
        UIView *bgView = [UIView new];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        bgView.layer.cornerRadius = kRelative(35);
        bgView.layer.masksToBounds = YES;
        
        self.delegate = delegate;
        self.slider = [[UISlider alloc] init];
        //  最小值
        _slider.minimumValue = 0;
        //  最大值
        _slider.maximumValue = 100;
        //  滑动条有值部分颜色
        _slider.minimumTrackTintColor = kTAColor.c_49;
        //  滑动条没有值部分颜色
        _slider.maximumTrackTintColor = kTAColor.c_F0;
        //  滑块滑动的值变化触发ValueChanged事件 如果设置为滑动停止才触发则设置为false
        [_slider setContinuous:true];
        //  响应事件
        [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [_slider addTarget:self action:@selector(sliderEditingDidEnd:) forControlEvents:UIControlEventTouchUpInside];
        //  修改控制器图片
        [_slider setThumbImage:kBundleImage(@"setting_sound_slider", @"Setting") forState:UIControlStateNormal];
        [self addSubview:_slider];
        
        self.iconImageView = [UIImageView new];
        _iconImageView.image = kBundleImage(@"setting_horn_icon", @"Setting");
        [self addSubview:_iconImageView];

        self.valueLabel = [[UILabel alloc] init];
        _valueLabel.backgroundColor = kTAColor.c_49;
        _valueLabel.textColor = [UIColor whiteColor];
        _valueLabel.font = [UIFont systemFontOfSize:7];
        _valueLabel.layer.cornerRadius = kRelative(6);
        _valueLabel.layer.masksToBounds = YES;
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_valueLabel];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(26));
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo(kRelative(31));
            make.height.mas_equalTo(kRelative(33));
        }];
        
        [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kRelative(40));
            make.height.mas_equalTo(kRelative(24));
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_iconImageView.mas_right).mas_offset(kRelative(10));
        }];
        
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_valueLabel.mas_right).mas_offset(kRelative(20));
            make.right.mas_equalTo(kRelative(-30));
            make.height.mas_equalTo(kRelative(8));
            make.centerY.mas_equalTo(0);
        }];
        
        self.titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.textColor = kTAColor.c_49;
        _titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(6));
            make.height.mas_equalTo(kRelative(30));
            make.bottom.mas_equalTo(self.mas_top).mas_offset(kRelative(-5));
        }];
    }
    return self;
}

- (void)sliderValueChange:(UISlider *)sender
{
    NSString *valueStr = [NSString stringWithFormat:@"%d", (int)sender.value];
    self.valueLabel.text = valueStr;
}

- (void)setSliderValue:(NSString *)value
{
    self.valueLabel.text = value;
    self.slider.value = value.intValue;
}

- (void)sliderEditingDidEnd:(UISlider *)sender
{
    NSString *valueStr = [NSString stringWithFormat:@"%d", (int)sender.value];
    self.valueLabel.text = valueStr;

    if (self.delegate && [self.delegate respondsToSelector:@selector(voiceSliderView:didiValueChange:)]) {
        [self.delegate voiceSliderView:self didiValueChange:valueStr];
    }
}

@end
