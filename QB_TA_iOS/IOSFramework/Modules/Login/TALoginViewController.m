//
//  TALoginViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TALoginViewController.h"
#import "TALoginPresenter.h"

#import "TAUserAgreementView.h"
#import "TALoginView.h"

#import "TACreatRoleViewController.h"

@interface TALoginViewController () <TAUserAgreementViewDelegate, TALoginViewDelegate>
@property (nonatomic, retain)TALoginPresenter*  presenter;

@property (nonatomic, retain)UIImageView*       bgImageView;
@property (nonatomic, retain)TAUserAgreementView*   userAgreementView;
@property (nonatomic, retain)TALoginView*           loginView;

@end

@implementation TALoginViewController

+ (NSString *)cmd{
    return @"login";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.bgImageView addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([TALoginView viewSize].width);
        make.height.mas_equalTo([TALoginView viewSize].height);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(self.bgImageView).mas_offset(kRelative(-90));
    }];

    [self.bgImageView addSubview:self.userAgreementView];
    [self.userAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([TAUserAgreementView viewSize].width);
        make.height.mas_equalTo([TAUserAgreementView viewSize].height);
        make.centerY.mas_equalTo(0).offset(SCREENH_HEIGHT);
        make.right.mas_equalTo(self.loginView.mas_right);
    }];
}

- (void)onLoginSuccess:(id)data jsonStr:(NSString *)jsonStr
{
    if (self.taskFinishBlock) {
        self.taskFinishBlock(jsonStr);
    }
    
    [self.presenter getRoleData];
}

- (void)getVCodeSuccess:(id)data
{
    //开始倒计时
    [self.loginView startCountdown];
}

#pragma mark - TAUserAgreementViewDelegate
- (void)userAgreementViewDidClickCloseBtn
{
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
        }];
        [weakself.userAgreementView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0).offset(SCREENH_HEIGHT);
        }];
        [weakself.bgImageView layoutIfNeeded];
        [weakself.bgImageView layoutSubviews];
    }];
}

- (void)userAgreementViewDidClickOKBtn
{
    [self.loginView agreeBtnSelected];//同意隐私协议
}

#pragma mark - TALoginViewDelegate
- (void)loginViewDidClickUserAgreement:(NSString *)scheme
{
    if ([scheme isEqualToString:@"yonghuxieyi"]) {
    }else{
    }
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.loginView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0).offset(-SCREENH_HEIGHT);
        }];
        [weakself.userAgreementView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
        }];
        [weakself.bgImageView layoutIfNeeded];
        [weakself.bgImageView layoutSubviews];
    }];
}

#pragma mark - lazy load
-(TALoginPresenter*)presenter
{
    if (!_presenter){
        _presenter = [[TALoginPresenter alloc] initWithView:self];
    }
    return _presenter;
}

-(TALoginView*)loginView{
    if (!_loginView){
        _loginView = [TALoginView new];
        _loginView.presenter = self.presenter;
        _loginView.delegate = self;
    }
    return _loginView;
}

-(TAUserAgreementView*)userAgreementView{
    if (!_userAgreementView){
        _userAgreementView = [TAUserAgreementView new];
        _userAgreementView.delegate = self;
    }
    return _userAgreementView;
}

-(UIImageView*)bgImageView{
    if (!_bgImageView){
        _bgImageView = [UIImageView new];

        UIImage *image = kBundleImage(@"login_bg", @"Login");
        [_bgImageView setImage:image];
        [_bgImageView setUserInteractionEnabled:YES];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _bgImageView;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
