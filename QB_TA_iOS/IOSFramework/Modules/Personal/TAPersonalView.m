//
//  TAPersonalView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAPersonalView.h"
#import "TAPersonalInfoView.h"
#import "TAPersonalCharacterView.h"

#import "TAPersonalPresenter.h"

@interface TAPersonalView () <TAPersonalCharacterViewDelegate>
@property (nonatomic, retain)UIImageView             *bgImageView;
@property (nonatomic, retain)UIImageView             *roleImageView;

@property (nonatomic, retain)UIButton                *changeContentBtn;

@property (nonatomic, retain)TAPersonalInfoView      *personalInfoView;
@property (nonatomic, retain)TAPersonalCharacterView *personalCharacterView;
@property (nonatomic, retain)UIButton                *closeBtn;

@property (nonatomic, assign)BOOL isShowInfo;

@property (nonatomic, retain)TAPersonalPresenter     *personalPresenter;
@property (nonatomic, retain)id     characterData;

@end

@implementation TAPersonalView

+ (TACmdModel *)cmd{
    TACmdModel *cmdModel = [TACmdModel new];
    cmdModel.cmd = @"personal";
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
    self.characterData = @"123";//获取角色信息

    self.userInteractionEnabled = YES;
    self.isShowInfo = YES;

    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.bgImageView addSubview:self.roleImageView];
    [self.roleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(123));
        make.bottom.mas_equalTo(kRelative(-42));
        make.width.mas_equalTo(kRelative(154));
        make.height.mas_equalTo(kRelative(453));
    }];
    
    [self.bgImageView addSubview:self.changeContentBtn];
    [self.changeContentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(kRelative(20));
        make.width.height.mas_equalTo(kRelative(60));
    }];
    
    [self.bgImageView addSubview:self.personalInfoView];
    [self.personalInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(446));
        make.top.bottom.right.mas_equalTo(0);
    }];

    [self.bgImageView addSubview:self.personalCharacterView];
    [self.personalCharacterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(446));
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    [self.bgImageView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];
}

- (void)changeCharacter:(id)character
{
    self.characterData = character;//新的角色信息
    character = [character stringByReplacingOccurrencesOfString:@"_head" withString:@""];//根据点击角色头像改变角色立相
    _roleImageView.image = kBundleImage(character, @"Role");
}

- (void)changeContentBtnClick:(UIButton *)sender
{
    self.isShowInfo = !self.isShowInfo;
    
    if (self.isShowInfo) {
        if (![self.characterData isEqualToString:@"123"])//如果角色信息有改变
        {
            [self.personalPresenter modifyCharacter:@"321"];//保存角色信息
        }

        [_changeContentBtn setImage:kBundleImage(@"personal_change_btn_w", @"Personal") forState:UIControlStateNormal];
        _personalInfoView.hidden = NO;
        _personalCharacterView.hidden = YES;
    }else {
        [_changeContentBtn setImage:kBundleImage(@"personal_change_btn_b", @"Personal") forState:UIControlStateNormal];
        _personalCharacterView.hidden = NO;
        _personalInfoView.hidden = YES;
    }
}


-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

#pragma mark - lazy load
-(UIImageView*)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = kBundleImage(@"personal_bg", @"Personal");
        _bgImageView.layer.cornerRadius = kRelative(35);
        _bgImageView.layer.masksToBounds = YES;
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _bgImageView;
}

-(UIImageView             *)roleImageView
{
    if (!_roleImageView){
        _roleImageView = [UIImageView new];
        _roleImageView.image = kBundleImage(@"role_1", @"Role");
        [_roleImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _roleImageView;
}

-(TAPersonalInfoView      *)personalInfoView
{
    if (!_personalInfoView){
        _personalInfoView = [TAPersonalInfoView new];
        _personalInfoView.presenter = self.personalPresenter;
    }
    return _personalInfoView;
}

-(TAPersonalCharacterView *)personalCharacterView
{
    if (!_personalCharacterView){
        _personalCharacterView = [TAPersonalCharacterView new];
        _personalCharacterView.hidden = YES;
        _personalCharacterView.presenter = self.personalPresenter;
        _personalCharacterView.delegate = self;
    }
    return _personalCharacterView;
}

-(UIButton *)changeContentBtn
{
    if (!_changeContentBtn) {
        _changeContentBtn = [UIButton new];
        [_changeContentBtn setImage:kBundleImage(@"personal_change_btn_w", @"Personal") forState:UIControlStateNormal];
        [_changeContentBtn addTarget:self action:@selector(changeContentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeContentBtn;
}

- (TAPersonalPresenter     *)personalPresenter
{
    if (!_personalPresenter) {
        _personalPresenter = [[TAPersonalPresenter alloc] initWithView:self];
    }
    return _personalPresenter;
}


-(UIButton       *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
