//
//  TASettingPictureQualityView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASettingPictureQualityView.h"
#import "TASegmentedControl.h"

@interface TASettingPictureQualityView ()
@property (nonatomic, retain)UILabel    *effectTitle;
@property (nonatomic, retain)UIButton   *effect_1;
@property (nonatomic, retain)UIButton   *effect_2;

@property (nonatomic, retain)TASegmentedControl *juguang;//聚光灯
@property (nonatomic, retain)TASegmentedControl *taijie;//台阶灯
@property (nonatomic, retain)TASegmentedControl *yinxiang;//音响灯

@end

@implementation TASettingPictureQualityView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(816), kRelative(570));
}

- (void)loadSubViews
{
    [self addSubview:self.juguang];
    [self addSubview:self.taijie];
    [self addSubview:self.yinxiang];
    
    [_juguang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(120));
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(150));
        make.height.mas_equalTo(kRelative(60));
    }];
    [_taijie mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(_juguang);
        make.left.mas_equalTo(_juguang.mas_right).mas_offset(kRelative(50));
    }];
    [_yinxiang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.mas_equalTo(_juguang);
        make.left.mas_equalTo(_taijie.mas_right).mas_offset(kRelative(50));
    }];

    [self addSubview:self.effectTitle];
    [self addSubview:self.effect_1];
    [self addSubview:self.effect_2];
    [_effectTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(6));
        make.top.mas_equalTo(kRelative(248));
    }];
    [_effect_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(0));
        make.top.mas_equalTo(_effectTitle.mas_bottom).mas_offset(kRelative(10));
        make.width.mas_equalTo(kRelative(152));
        make.height.mas_equalTo(kRelative(60));
    }];
    [_effect_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_effect_1.mas_right).mas_offset(kRelative(30));
        make.top.width.height.mas_equalTo(_effect_1);
    }];
    
    [_effect_1 setSelected:YES];
}

- (void)effectClick:(UIButton *)sender
{
    [_effect_1 setSelected:NO];
    [_effect_2 setSelected:NO];
    
    [sender setSelected:YES];
}

-(UILabel    *)effectTitle{
    if (!_effectTitle){
        _effectTitle = [UILabel new];
        _effectTitle.text = @"特效";
        _effectTitle.textColor = kTAColor.c_49;
        _effectTitle.font = [UIFont systemFontOfSize:11];
    }
    return _effectTitle;
}

-(UIButton   *)effect_1{
    if (!_effect_1){
        _effect_1 = [UIButton new];
        _effect_1.tag = 1001;
        [_effect_1 setBackgroundImage:[UIImage jk_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_effect_1 setBackgroundImage:[UIImage jk_imageWithColor:kTAColor.c_49] forState:UIControlStateSelected];
        [_effect_1 setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_effect_1 setTitleColor:kTAColor.c_F0 forState:UIControlStateSelected];
        [_effect_1 setImage:kBundleImage(@"rmenu_confetti_b", @"ControlPanel") forState:UIControlStateNormal];
        [_effect_1 setImage:kBundleImage(@"rmenu_confetti_g", @"ControlPanel") forState:UIControlStateSelected];
        [_effect_1 setTitle:@"礼花" forState:UIControlStateNormal];
        [_effect_1 setImageEdgeInsets:UIEdgeInsetsMake(kRelative(12), kRelative(12), kRelative(12), kRelative(104))];
        _effect_1.layer.cornerRadius = kRelative(30);
        _effect_1.layer.masksToBounds = YES;
        _effect_1.titleLabel.font = [UIFont systemFontOfSize:12];
        [_effect_1 addTarget:self action:@selector(effectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _effect_1;
}

-(UIButton   *)effect_2{
    if (!_effect_2){
        _effect_2 = [UIButton new];
        _effect_2.tag = 1002;
        [_effect_2 setBackgroundImage:[UIImage jk_imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_effect_2 setBackgroundImage:[UIImage jk_imageWithColor:kTAColor.c_49] forState:UIControlStateSelected];
        [_effect_2 setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_effect_2 setTitleColor:kTAColor.c_F0 forState:UIControlStateSelected];
        [_effect_2 setImage:kBundleImage(@"rmenu_applause_b", @"ControlPanel") forState:UIControlStateNormal];
        [_effect_2 setImage:kBundleImage(@"rmenu_applause_g", @"ControlPanel") forState:UIControlStateSelected];
        [_effect_2 setTitle:@"鼓掌" forState:UIControlStateNormal];
        [_effect_2 setImageEdgeInsets:UIEdgeInsetsMake(kRelative(12), kRelative(12), kRelative(12), kRelative(104))];
        _effect_2.layer.cornerRadius = kRelative(30);
        _effect_2.layer.masksToBounds = YES;
        _effect_2.titleLabel.font = [UIFont systemFontOfSize:12];
        [_effect_2 addTarget:self action:@selector(effectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _effect_2;
}

-(TASegmentedControl *)juguang//聚光灯
{
    if (!_juguang){
        _juguang = [[TASegmentedControl alloc] initWithTitle:@"聚光灯"];
        [_juguang.segmented setSelectedSegmentIndex:1];
    }
    return _juguang;
}
-(TASegmentedControl *)taijie//台阶灯
{
    if (!_taijie){
        _taijie = [[TASegmentedControl alloc] initWithTitle:@"台阶灯"];
        [_taijie.segmented setSelectedSegmentIndex:1];
    }
    return _taijie;
}
-(TASegmentedControl *)yinxiang//音响灯
{
    if (!_yinxiang){
        _yinxiang = [[TASegmentedControl alloc] initWithTitle:@"音响灯"];
        [_yinxiang.segmented setSelectedSegmentIndex:1];
    }
    return _yinxiang;
}

@end
