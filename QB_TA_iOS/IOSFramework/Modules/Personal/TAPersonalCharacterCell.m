//
//  TAPersonalCharacterCell.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/8.
//

#import "TAPersonalCharacterCell.h"
#import "TAMacroDefinition.h"//宏定义
#import "Masonry.h"//布局
#import "TACommonColor.h"

@interface TAPersonalCharacterCell()
@property (nonatomic, retain)UIView *headSelectShadowView;
@property (nonatomic, retain)UIImageView *headImageView;

@end

@implementation TAPersonalCharacterCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.clipsToBounds = NO;
        self.clipsToBounds = NO;

        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
//    NSString *imageName = [NSString stringWithFormat:@"role_head_%d",i];
//    [roleHead setImage:kBundleImage(imageName, @"Role") forState:UIControlStateNormal];
//    [roleHead addTarget:self action:@selector(roleHeadClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgImageView addSubview:roleHead];
//
    [self.contentView addSubview:self.headSelectShadowView];
    [self.headSelectShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(-3));
        make.centerX.mas_equalTo(0);
        make.width.height.mas_equalTo(kRelative(86));
    }];
    [self.contentView addSubview:self.headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)setIsSelected:(BOOL)isSelected
{
//    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundView.backgroundColor = [UIColor clearColor];
//    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];

    _isSelected = isSelected;
    if (isSelected) {
        self.headSelectShadowView.hidden = NO;
    }else{
        self.headSelectShadowView.hidden = YES;
    }
}

-(void)setImage:(NSString *)image
{
    _image = image;
    if (image) {
        self.headImageView.image = kBundleImage(image, @"Role");
    }
}
-(UIView *)headSelectShadowView
{
    if (!_headSelectShadowView) {
        _headSelectShadowView = [[UIView alloc] init];
        _headSelectShadowView.clipsToBounds = NO;
        _headSelectShadowView.backgroundColor = [UIColor clearColor];
        _headSelectShadowView.layer.borderWidth = kRelative(2);
        _headSelectShadowView.layer.borderColor = kTAColor.c_49.CGColor;
        _headSelectShadowView.layer.cornerRadius = kRelative(43);
    }
    return _headSelectShadowView;
}

-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
    }
    return _headImageView;
}

@end
