//
//  TASettingAboutView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASettingAboutView.h"

@interface TASettingAboutView ()
@property (nonatomic, retain)UIImageView *icon;
@property (nonatomic, retain)UILabel     *version;
@property (nonatomic, retain)UILabel     *content;
@property (nonatomic, retain)UIButton    *yhxy;
@property (nonatomic, retain)UIButton    *yszc;
@end

@implementation TASettingAboutView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(816), kRelative(570));
}

- (void)loadSubViews
{
    [self addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kRelative(80));
        make.height.width.mas_equalTo(kRelative(90));
    }];
    
    [self addSubview:self.version];
    [self.version mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_icon.mas_bottom).mas_offset(kRelative(16));
        make.centerX.mas_equalTo(0);
    }];
    
    [self addSubview:self.content];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_version.mas_bottom).mas_offset(kRelative(40));
        make.width.mas_equalTo(kRelative(670));
        make.centerX.mas_equalTo(0);
    }];
    
    [self addSubview:self.yhxy];
    [self.yhxy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(kRelative(-110));
        make.right.mas_equalTo(self.mas_centerX).mas_offset(kRelative(-50));
    }];
    
    [self addSubview:self.yszc];
    [self.yszc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.yhxy);
        make.left.mas_equalTo(self.mas_centerX).mas_offset(kRelative(50));
    }];
}

- (void)userAgreement:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingAboutViewDidClickUserAgreement:)]) {
        [self.delegate settingAboutViewDidClickUserAgreement:(sender.tag == 1) ? @"yhxy":@"yszc"];
    }
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [UIImageView new];
        UIImage *image = [UIImage imageNamed:@"Icon1024"];
        if (!image){
            _icon.hidden = YES;
        }
        _icon.image = image;
        _icon.layer.cornerRadius = kRelative(8);
        _icon.layer.masksToBounds = YES;
    }
    return _icon;
}

- (UILabel *)version {
    if (!_version) {
        _version = [UILabel new];
        _version.textColor = kTAColor.c_49;
        _version.font = [UIFont systemFontOfSize:10];
        NSString *appVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        _version.text = [NSString stringWithFormat:@"当前版本:V%@",appVersion];
    }
    return _version;
}

- (UILabel *)content {
    if (!_content) {
        _content = [UILabel new];
        _content.textColor = kTAColor.c_49;
        _content.font = [UIFont systemFontOfSize:11];
        _content.text = @"无尽之塔作为元宇宙文明栖息地，充分发挥聚集效应，为入驻者提供相当数量的潜在受众群体，成为元宇宙发展的强劲驱动。在这个缤纷多彩的世界中，人们能以全新的方式体验元宇宙生活!";
        _content.numberOfLines = 0;
        _content.textAlignment = NSTextAlignmentCenter;
    }
    return _content;
}

- (UIButton *)yhxy {
    if (!_yhxy) {
        _yhxy = [UIButton new];
        _yhxy.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_yhxy setTitle:@"《用户协议》" forState:UIControlStateNormal];
        [_yhxy setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        _yhxy.tag = 1;
        [_yhxy addTarget:self action:@selector(userAgreement:) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [UIView new];
        line.backgroundColor = kTAColor.c_49;
        [_yhxy addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_yhxy.titleLabel);
            make.height.mas_equalTo(kRelative(2));
        }];
    }
    return _yhxy;
}

- (UIButton *)yszc {
    if (!_yszc) {
        _yszc = [UIButton new];
        _yszc.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [_yszc setTitle:@"《隐私政策》" forState:UIControlStateNormal];
        [_yszc setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        _yszc.tag = 2;
        [_yszc addTarget:self action:@selector(userAgreement:) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [UIView new];
        line.backgroundColor = kTAColor.c_49;
        [_yszc addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_yszc.titleLabel);
            make.height.mas_equalTo(kRelative(2));
        }];
    }
    return _yszc;
}




@end
