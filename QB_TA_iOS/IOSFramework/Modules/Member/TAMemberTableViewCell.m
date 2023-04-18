//
//  TAMemberTableViewCell.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/7.
//

#import "TAMemberTableViewCell.h"
#import "TAMacroDefinition.h"//宏定义
#import "Masonry.h"//布局
#import "TACommonColor.h"
#import "UIImageView+WebCache.h"

@interface TAMemberTableViewCell()
@property (nonatomic, retain)UIImageView    *headImage;
@property (nonatomic, retain)UILabel        *nameHead;
@property (nonatomic, retain)UILabel        *nameLabel;
@property (nonatomic, retain)UIButton       *mikeState;
@property (nonatomic, retain)UIButton       *kickOut;

@property (nonatomic, assign)BOOL   isAdmin;
@end


@implementation TAMemberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.isAdmin = [TADataCenter shareInstance].userInfo.admin;
        [self initSubView];
    }
    return self;
}

- (void)initSubView
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.headImage];
    [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(60));
        make.left.mas_equalTo(kRelative(30));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.headImage addSubview:self.nameHead];
    [self.nameHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(54));
        make.center.mas_equalTo(0);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(100));
    }];
    
    [self addSubview:self.mikeState];
    [self.mikeState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        CGFloat right = _isAdmin ? -150 : -80;
        make.right.mas_equalTo(kRelative(right));
    }];
    
    [self addSubview:self.kickOut];
    [self.kickOut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(-80));
    }];
}

- (void)setData:(TAMemberModel *)data
{
    _data = data;

    NSString *nickname = [TADataCenter shareInstance].userInfo.nickname;
    if (_isAdmin){
        self.kickOut.hidden = [data.nickname isEqualToString:nickname];
    }else{
        self.kickOut.hidden = YES;
    }
    
    self.nameLabel.text = data.nickname;
    
    self.nameHead.text = data.roleName;

    if (_isAdmin){
        if (data.voice == 0){
            self.mikeState.selected = NO;
            [_mikeState setImage:kBundleImage(@"tmenu_mike_forbidden", @"ControlPanel") forState:UIControlStateNormal];
        }else if (data.voice == 1){
            self.mikeState.selected = NO;
            [_mikeState setImage:kBundleImage(@"tmenu_mike_disable_b", @"ControlPanel") forState:UIControlStateNormal];
        }else if (data.voice == 2){
            self.mikeState.selected = YES;
        }
    }else{
        self.mikeState.selected = (data.voice == 2);
    }
    
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:data.headUrl]];
}

- (void)kickOutBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClickKickOut:)]){
        [self.delegate cellDidClickKickOut:_data];
    }
}

- (void)mikeStatetBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClickMikeStatet:)]){
        [self.delegate cellDidClickMikeStatet:_data];
    }
}

- (UIImageView    *)headImage{
    if (!_headImage){
        _headImage = [UIImageView new];
        _headImage.backgroundColor = [UIColor whiteColor];
        _headImage.layer.cornerRadius = kRelative(25);
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}

- (UILabel        *)nameLabel{
    if (!_nameLabel){
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}
- (UILabel        *)nameHead{
    if (!_nameHead){
        _nameHead = [UILabel new];
        _nameHead.adjustsFontSizeToFitWidth = YES;
        _nameHead.minimumScaleFactor = 0.2;
        _nameHead.numberOfLines = 1;
        _nameHead.textAlignment = NSTextAlignmentCenter;
        _nameHead.textColor = [UIColor blackColor];
    }
    return _nameHead;
}

- (UIButton       *)mikeState{
    if (!_mikeState){
        _mikeState = [UIButton new];
        [_mikeState setImage:kBundleImage(@"tmenu_mike_disable_b", @"ControlPanel") forState:UIControlStateNormal];
        [_mikeState setImage:kBundleImage(@"tmenu_mike_enable_b", @"ControlPanel") forState:UIControlStateSelected];
        [_mikeState addTarget:self action:@selector(mikeStatetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mikeState;
}

- (UIButton       *)kickOut{
    if (!_kickOut){
        _kickOut = [UIButton new];
        _kickOut.hidden = !_isAdmin;
        [_kickOut setImage:kBundleImage(@"iocn_kickOut_b", @"Commom") forState:UIControlStateNormal];
        [_kickOut setImage:kBundleImage(@"iocn_kickOut_g", @"Commom") forState:UIControlStateHighlighted];
        [_kickOut addTarget:self action:@selector(kickOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kickOut;
}

@end
