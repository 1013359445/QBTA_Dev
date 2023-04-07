//
//  TASettingView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TASettingView.h"
#import "TASettingBasicsView.h"
#import "TASettingAboutView.h"
#import "TASettingPictureQualityView.h"
#import "TASettingVoiceView.h"
#import "TAUserAgreementView.h"

@interface TASettingView () <TAUserAgreementViewDelegate, TASettingAboutViewDelegate>
@property (nonatomic, retain)TAUserAgreementView *userAgreementView;

@property (nonatomic, retain)UIImageView    *bgImageView;
@property (nonatomic, retain)UIView         *leftView;
@property (nonatomic, retain)UIButton       *closeBtn;
@property (nonatomic, retain)UIImageView    *selectBGView;
@property (nonatomic, retain)NSMutableArray *leftItemsArray;

@property (nonatomic, retain)TASettingBasicsView    *basicsView;
@property (nonatomic, retain)TASettingAboutView     *aboutView;
//@property (nonatomic, retain)TASettingPictureQualityView *pictureQuality;
@property (nonatomic, retain)TASettingVoiceView     *voicView;

@end

@implementation TASettingView

+ (TACmdModel *)cmd{
    TACmdModel *cmdModel = [TACmdModel new];
    cmdModel.cmd = @"setting";
    cmdModel.animated = YES;
    return cmdModel;
}

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1100), kRelative(570));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;
    }
    return self;
}

- (void)loadSubViews
{
    self.leftItemsArray = [NSMutableArray array];
    self.userInteractionEnabled = YES;
    
    [self addSubview:self.userAgreementView];
    [self.userAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([TAUserAgreementView viewSize].width);
        make.height.mas_equalTo([TAUserAgreementView viewSize].height);
        make.centerY.mas_equalTo(0).offset(SCREEN_HEIGHT);
        make.centerX.mas_equalTo(0);
    }];

    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([TASettingView viewSize].width);
        make.height.mas_equalTo([TASettingView viewSize].height);
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];

    [self.bgImageView addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(kRelative(0));
        make.width.mas_equalTo(kRelative(280));
    }];
    [self.leftView addSubview:self.selectBGView];
    [self.selectBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(56));
        make.left.mas_equalTo(kRelative(23));
        make.width.mas_equalTo(kRelative(208));
        make.height.mas_equalTo(kRelative(88));
    }];

    NSArray *items = @[@"时空场景",@"声音",@"关于我们"];
    for (NSString *text in items) {
        NSInteger index = [items indexOfObject:text];
        UIView *blockView = [[UIView alloc] init];
        blockView.layer.borderWidth = kRelative(2);
        blockView.layer.borderColor = kTAColor.c_49.CGColor;
        blockView.transform = CGAffineTransformMakeRotation(M_PI_4);
        [self.leftView insertSubview:blockView belowSubview:self.selectBGView];
        [blockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(94) + kRelative(index * 90));
            make.left.mas_equalTo(kRelative(59));
            make.width.height.mas_equalTo(kRelative(12));
        }];
        UIButton *btn = [UIButton new];
        [btn setTitle:text forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.leftView insertSubview:btn aboveSubview:self.selectBGView];
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
    
    [self.bgImageView addSubview:self.basicsView];
    [self.basicsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo([TASettingBasicsView viewSize].width);
        make.height.mas_equalTo([TASettingBasicsView viewSize].height);
    }];
    [self.bgImageView addSubview:self.voicView];
    [self.voicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.width.height.mas_equalTo(self.basicsView);
    }];
    //    [self.bgImageView addSubview:self.pictureQuality];
    //    [self.pictureQuality mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.top.width.height.mas_equalTo(self.basicsView);
    //    }];
    [self.bgImageView addSubview:self.aboutView];
    [self.aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.width.height.mas_equalTo(self.basicsView);
    }];

    [self.bgImageView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];

    [self showContentWithSelectedIndex:0];
}

-(void)showContentWithSelectedIndex:(NSInteger)index
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.25 animations:^{
        for (UIButton *btn in self.leftItemsArray) {
            [btn setSelected:NO];
        }
        UIButton *sender = self.leftItemsArray[index];
        [sender setSelected:YES];

        [self.selectBGView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(56) + kRelative(index * 90));
        }];
        [self.leftView layoutIfNeeded];
        [self.leftView layoutSubviews];
    }];
    
    //右侧内容变化
    for (int tag = 100; tag < 103; tag++) {
        UIView *view = [self viewWithTag:tag];
        if (view){
            if (tag - 100 == index) {
                view.hidden = NO;
            }else{
                view.hidden = YES;
            }
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

#pragma mark - TAUserAgreementViewDelegate
- (void)userAgreementViewDidClickCloseBtn
{
    kWeakSelf(self);
    [UIView animateWithDuration:0.25 animations:^{
        [weakself.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
        }];
        [weakself.userAgreementView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0).offset(SCREEN_HEIGHT);
        }];
        [weakself layoutIfNeeded];
        [weakself layoutSubviews];
    }];
}

#pragma mark - TASettingAboutViewDelegate
- (void)settingAboutViewDidClickUserAgreement:(NSString *)scheme
{
    [self.userAgreementView setAttributedContentWithHTML:scheme];

    kWeakSelf(self);
    [UIView animateWithDuration:0.25 animations:^{
        [weakself.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0).offset(-SCREEN_HEIGHT);
        }];
        [weakself.userAgreementView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
        }];
        [weakself layoutIfNeeded];
        [weakself layoutSubviews];
    }];
}

#pragma mark - lazy load
-(TAUserAgreementView*)userAgreementView{
    if (!_userAgreementView){
        _userAgreementView = [TAUserAgreementView new];
        _userAgreementView.delegate = self;
        _userAgreementView.hiddenBottom = YES;
    }
    return _userAgreementView;
}

-(TASettingAboutView     *)aboutView
{
    if (!_aboutView){
        _aboutView = [TASettingAboutView new];
        _aboutView.delegate = self;
        _aboutView.tag = 102;
    }
    return _aboutView;
}
//-(TASettingPictureQualityView *)pictureQuality
//{
//    if (!_pictureQuality)
//    {
//        _pictureQuality = [TASettingPictureQualityView new];
//        _pictureQuality.tag = 102;
//    }
//    return _pictureQuality;
//}
-(TASettingVoiceView     *)voicView
{
    if (!_voicView)
    {
        _voicView = [TASettingVoiceView new];
        _voicView.tag = 101;
    }
    return _voicView;
}

-(TASettingBasicsView *)basicsView
{
    if(!_basicsView){
        _basicsView = [TASettingBasicsView new];
        _basicsView.tag = 100;
    }
    return _basicsView;
}

-(UIImageView *)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = kBundleImage(@"frame_view_bg", @"Commom");
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

-(UIView *)leftView
{
    if (!_leftView)
    {
        _leftView = [UIView new];
        _leftView.userInteractionEnabled = YES;
    }
    return _leftView;
}

@end
