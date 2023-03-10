//
//  TASettingView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TASettingView.h"
#import "TASettingBasicsView.h"
#import "TASettingPrivacyView.h"
#import "TASettingAboutView.h"
#import "TASettingLightView.h"
#import "TASettingVoiceView.h"

@interface TASettingView ()

@property (nonatomic, retain)UIImageView    *bgImageView;
@property (nonatomic, retain)UIButton       *closeBtn;
@property (nonatomic, retain)UIImageView    *selectBGView;
@property (nonatomic, retain)NSMutableArray *leftItemsArray;

@property (nonatomic, retain)TASettingBasicsView    *basicsView;
@property (nonatomic, retain)TASettingPrivacyView   *privacyView;
@property (nonatomic, retain)TASettingAboutView     *aboutView;
@property (nonatomic, retain)TASettingLightView     *lightView;
@property (nonatomic, retain)TASettingVoiceView     *voicView;

@end

@implementation TASettingView

+ (NSString *)cmd{
    return @"setting";
}

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1100), kRelative(570));
}

- (void)loadSubViews
{
    self.leftItemsArray = [NSMutableArray array];
    self.userInteractionEnabled = YES;
    [self showEffectView:YES];
    
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.bgImageView addSubview:self.selectBGView];
    [self.selectBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(56));
        make.left.mas_equalTo(kRelative(23));
        make.width.mas_equalTo(kRelative(208));
        make.height.mas_equalTo(kRelative(88));
    }];

    NSArray *items = @[@"时空场景",@"声音",@"场景控制",@"关于我们",@"隐私条款"];
    for (NSString *text in items) {
        NSInteger index = [items indexOfObject:text];
        UIView *blockView = [[UIView alloc] init];
        blockView.layer.borderWidth = kRelative(2);
        blockView.layer.borderColor = kTAColor.c_49.CGColor;
        blockView.transform = CGAffineTransformMakeRotation(M_PI_4);
        [self.bgImageView insertSubview:blockView belowSubview:self.selectBGView];
        [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(94) + kRelative(index * 90));
            make.left.mas_equalTo(kRelative(59));
            make.width.height.mas_equalTo(kRelative(12));
        }];
        UIButton *btn = [UIButton new];
        [btn setTitle:text forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.bgImageView insertSubview:btn aboveSubview:self.selectBGView];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(blockView.mas_centerY);
            make.width.mas_equalTo(kRelative(208));
            make.height.mas_equalTo(kRelative(88));
            make.left.mas_equalTo(kRelative(23));
        }];
        btn.tag = 1001 + index;
        [btn addTarget:self action:@selector(leftItemsClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [btn setTitleColor:kTAColor.c_F0 forState:UIControlStateSelected];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, kRelative(57), 0, 0);
        
        [self.leftItemsArray addObject:btn];
    }
    
    [self addSubview:self.basicsView];
    [self.basicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo([TASettingBasicsView viewSize].width);
        make.height.mas_equalTo([TASettingBasicsView viewSize].height);
    }];
    
    [self addSubview:self.privacyView];
    [self.privacyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.width.height.mas_equalTo(self.basicsView);
    }];
    [self addSubview:self.aboutView];
    [self.aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.width.height.mas_equalTo(self.basicsView);
    }];
    [self addSubview:self.lightView];
    [self.lightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.width.height.mas_equalTo(self.basicsView);
    }];
    [self addSubview:self.voicView];
    [self.voicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.width.height.mas_equalTo(self.basicsView);
    }];
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];

    [self showContentWithSelectedIndex:0];
}

-(void)showContentWithSelectedIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        for (UIButton *btn in self.leftItemsArray) {
            [btn setSelected:NO];
        }
        UIButton *sender = self.leftItemsArray[index];
        [sender setSelected:YES];

        [self.selectBGView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(56) + kRelative(index * 90));
        }];
        [self.bgImageView layoutIfNeeded];
        [self.bgImageView layoutSubviews];
    }];
    
    //右侧内容变化
    for (int tag = 100; tag < 105; tag++) {
        UIView *view = [self viewWithTag:tag];
        if (tag - 100 == index) {
            view.hidden = NO;
        }else{
            view.hidden = YES;
        }
    }
}


-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

-(void)leftItemsClick:(UIButton *)sender
{
    NSInteger index = sender.tag - 1001;
    [self showContentWithSelectedIndex:index];
}

#pragma mark - lazy load
-(TASettingBasicsView *)basicsView
{
    if(!_basicsView){
        _basicsView = [TASettingBasicsView new];
        _basicsView.tag = 100;
    }
    return _basicsView;
}
-(TASettingPrivacyView   *)privacyView
{
    if (!_privacyView)
    {
        _privacyView = [TASettingPrivacyView new];
        _privacyView.tag = 104;
    }
    return _privacyView;
}
-(TASettingAboutView     *)aboutView
{
    if (!_aboutView)
    {
        _aboutView = [TASettingAboutView new];
        _aboutView.tag = 103;
    }
    return _aboutView;
}
-(TASettingLightView     *)lightView
{
    if (!_lightView)
    {
        _lightView = [TASettingLightView new];
        _lightView.tag = 102;
    }
    return _lightView;
}
-(TASettingVoiceView     *)voicView
{
    if (!_voicView)
    {
        _voicView = [TASettingVoiceView new];
        _voicView.tag = 101;
    }
    return _voicView;
}

-(UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = kBundleImage(@"setting_bg", @"Setting");
        _bgImageView.layer.cornerRadius = kRelative(35);
        _bgImageView.layer.masksToBounds = YES;
        [_bgImageView setContentMode:UIViewContentModeScaleToFill];
    }
    return _bgImageView;
}

-(UIButton *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIImageView *)selectBGView
{
    if (!_selectBGView)
    {
        _selectBGView = [UIImageView new];
        _selectBGView.image = kBundleImage(@"setting_select_bg", @"Setting");
    }
    return _selectBGView;
}

@end



//@interface TASettingView ()
//
//@property (nonatomic, retain)UIImageView    *bgImageView;
//@property (nonatomic, retain)UIButton       *closeBtn;
//
//@end
//
//@implementation TASettingView
//
//+ (NSString *)cmd{
//    return @"setting";
//}
//
//+ (CGSize)viewSize
//{
//    return CGSizeMake(kRelative(1100), kRelative(570));
//}
//
//- (void)loadSubViews
//{
//    self.userInteractionEnabled = YES;
//    [self showEffectView:YES];
//
//    [self addSubview:self.bgImageView];
//    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
//
//    [self addSubview:self.closeBtn];
//    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(kRelative(12));
//        make.right.mas_equalTo(kRelative(-12));
//        make.width.height.mas_equalTo(kRelative(66));
//    }];
//
//}
//
//-(void)closeBtnClick
//{
//    [self hideViewAnimated:YES];
//}
//
//#pragma mark - lazy load
//-(UIImageView*)bgImageView
//{
//    if(!_bgImageView){
//        _bgImageView = [UIImageView new];
//        _bgImageView.userInteractionEnabled = YES;
//        _bgImageView.image = kBundleImage(@"personal_bg", @"Personal");
//        _bgImageView.layer.cornerRadius = kRelative(35);
//        _bgImageView.layer.masksToBounds = YES;
//        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
//    }
//    return _bgImageView;
//}
//
//-(UIButton       *)closeBtn
//{
//    if (!_closeBtn)
//    {
//        _closeBtn = [UIButton new];
//        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
//        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _closeBtn;
//}
//@end
