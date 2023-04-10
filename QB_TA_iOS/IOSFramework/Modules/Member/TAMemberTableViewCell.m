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
        make.width.height.mas_equalTo(kRelative(50));
        make.left.mas_equalTo(kRelative(30));
        make.centerY.mas_equalTo(0);
    }];
    
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(90));
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

- (void)setMikeEnable:(BOOL)mikeEnable
{
    _mikeEnable = mikeEnable;
    _mikeState.selected = mikeEnable;
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLabel.text = name;
}

- (void)kickOutBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellDidClickKickOut:)]){
        [self.delegate cellDidClickKickOut:self.nameLabel.text];
    }
}

- (UIImageView    *)headImage{
    if (!_headImage){
        _headImage = [UIImageView new];
        _headImage.backgroundColor = [UIColor grayColor];
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

- (UIButton       *)mikeState{
    if (!_mikeState){
        _mikeState = [UIButton new];
        [_mikeState setImage:kBundleImage(@"tmenu_mike_disable_b", @"ControlPanel") forState:UIControlStateNormal];
        [_mikeState setImage:kBundleImage(@"tmenu_mike_enable_b", @"ControlPanel") forState:UIControlStateSelected];
        _mikeState.userInteractionEnabled = NO;
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
