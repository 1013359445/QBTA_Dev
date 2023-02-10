//
//  TALoginViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TALoginViewController.h"
#import "TALoginInterface.h"
#import "TAUserInfoDataModel.h"

@interface TALoginViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain)UIImageView*       bgImageView;
@property (nonatomic, retain)UIImageView*       frameImageView;
@property (nonatomic, retain)UIView*            tabView;
@property (nonatomic, retain)UIButton*          codeTab;
@property (nonatomic, retain)UIButton*          passwordTab;

@property (nonatomic, retain)UIView*            usernameInputVIew;
@property (nonatomic, retain)UITextField*       usernameTextField;

@property (nonatomic, retain)UIView*            passwordInputVIew;
@property (nonatomic, retain)UITextField*       passwordTextField;
@property (nonatomic, retain)UIButton*          eyeBtn;

@property (nonatomic, retain)UIView*            codeInputVIew;
@property (nonatomic, retain)UITextField*       codeTextField;
@property (nonatomic, retain)UIButton*          getCodeBtn;
@property (nonatomic, retain)UILabel*           countDown;

@property (nonatomic, retain)UIButton*          loginBtn;

@property (nonatomic, retain)UIButton*          agreeBtn;
@property (nonatomic, retain)UITextView*        agreementText;

@end

@implementation TALoginViewController

+ (NSString *)cmd{
    return @"login";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)layoutViews
{
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.bgImageView addSubview:self.frameImageView];
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(600));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(-90));
    }];
    
    [self.frameImageView addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(30));
        make.left.mas_equalTo(kRelative(50));
        make.width.mas_equalTo(kRelative(260));
        make.height.mas_equalTo(kRelative(60));
    }];
    
    [self.tabView addSubview:self.codeTab];
    [self.codeTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
    }];
    
    [self.tabView addSubview:self.passwordTab];
    [self.passwordTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
    }];
    
    [self.frameImageView addSubview:self.usernameInputVIew];
    [self.usernameInputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(50));
        make.right.mas_equalTo(kRelative(-50));
        make.height.mas_equalTo(kRelative(70));
        make.top.mas_equalTo(kRelative(120));
    }];
    
    [self.usernameInputVIew addSubview:self.usernameTextField];
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(30));
    }];
    
    [self.frameImageView addSubview:self.passwordInputVIew];
    [self.passwordInputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(50));
        make.right.mas_equalTo(kRelative(-50));
        make.height.mas_equalTo(kRelative(70));
        make.top.mas_equalTo(_usernameInputVIew.mas_bottom).mas_offset(kRelative(40));
        
    }];
    
    [self.passwordInputVIew addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-100));
    }];
    
    [self.passwordInputVIew addSubview:self.eyeBtn];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRelative(-30));
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(kRelative(50));
    }];
    
    [self.frameImageView addSubview:self.codeInputVIew];
    [self.codeInputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(_passwordInputVIew);
    }];
    
    [self.codeInputVIew addSubview:self.codeTextField];
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-100));
    }];
    
    [self.codeInputVIew addSubview:self.getCodeBtn];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRelative(-30));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.codeInputVIew addSubview:self.countDown];
    [self.countDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRelative(-30));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.frameImageView addSubview:self.loginBtn];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(50));
        make.right.mas_equalTo(kRelative(-50));
        make.height.mas_equalTo(kRelative(70));
        make.top.mas_equalTo(_passwordInputVIew.mas_bottom).mas_offset(kRelative(98));
    }];
    
    [self.frameImageView addSubview:self.agreeBtn];
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(32));
        make.left.mas_equalTo(kRelative(70));
        make.bottom.mas_equalTo(_frameImageView.mas_bottom).mas_offset(kRelative(-24));
    }];
    
    [self drawAgreementTextView];
    [self.agreementText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_agreeBtn.mas_right).mas_offset(kRelative(14));
        make.right.mas_equalTo(_frameImageView.mas_right).mas_offset(-30);
        make.height.mas_equalTo(kRelative(56));
        make.top.mas_equalTo(_agreeBtn.mas_top).mas_offset(kRelative(-12));

    }];
    [self.agreementText layoutIfNeeded];
}

#pragma mark 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if ([[URL scheme] isEqualToString:@"yonghuxieyi"]) {
        LRLog(@"富文本点击 用户协议");
    }else{
        LRLog(@"富文本点击 隐私政策");
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return NO;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark Action
- (void)codeTabClick:(UIButton *)sender
{
    LRWeakSelf(self);
    [UIView animateWithDuration:0.2 animations:^{
        weakself.codeTab.selected = YES;
        [weakself.codeTab.titleLabel setFont:[UIFont systemFontOfSize:14]];
        weakself.passwordTab.selected = NO;
        [weakself.passwordTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [weakself.tabView layoutIfNeeded];
        [weakself.tabView layoutSubviews];
    }];
}

- (void)passwordTabClick:(UIButton *)sender
{
    LRWeakSelf(self);
    [UIView animateWithDuration:0.2 animations:^{
        
        weakself.passwordTab.selected = YES;
        [weakself.passwordTab.titleLabel setFont:[UIFont systemFontOfSize:14]];
        weakself.codeTab.selected = NO;
        [weakself.codeTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [weakself.tabView layoutIfNeeded];
        [weakself.tabView layoutSubviews];
    }];
}

- (void)eyeBtnClick:(UIButton *)sender
{
    
}

- (void)getCodeBtnClick:(UIButton *)sender
{

}



- (void)loginBtnClick:(UIButton *)sender
{
    LRWeakSelf(self);
    [[TALoginInterface shareInstance] loginWithParmModel:nil dataModelClass:[TAUserInfoDataModel class] finishedBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response) {
        
        weakself.taskFinishBlock(response);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself goBack];
        });


    } failedBlock:^(NSDictionary * _Nonnull response) {
        weakself.taskFinishBlock(response);
    }];
}

- (void)agreeBtnClick:(UIButton *)sender
{
    
}

#pragma mark Getter/Setter
-(UIImageView*)bgImageView{
    if (!_bgImageView){
        _bgImageView = [UIImageView new];
//        NSBundle *containnerBundle = [NSBundle bundleForClass:[self class]];
//
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"IOSFramework" ofType:@"framework" inDirectory:@"Frameworks"];
//        NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
//        NSLog(@"bundle1");
//
//        if (!bundle) {
//            bundlePath = [bundlePath stringByAppendingPathComponent:@"/TABundle.bundle"];
//            bundle = [NSBundle bundleWithPath:bundlePath];
//            NSLog(@"bundle2");
//        }
//        if (!bundle) {
//            bundlePath = [[NSBundle mainBundle] pathForResource:@"TABundle" ofType:@"bundle"];
//            bundle = [NSBundle bundleWithPath:bundlePath];
//            NSLog(@"bundle3");
//        }
//        if (!bundle) {
//            bundle = [NSBundle bundleWithIdentifier:@"TABundle.bundle"];
//            NSLog(@"bundle4");
//        }
//        if (!bundle) {
//            bundle = [NSBundle bundleWithIdentifier:@"TABundle"];
//            NSLog(@"bundle5");
//        }
//        if (!bundle) {
//            NSBundle *containnerBundle = [NSBundle bundleForClass:[self class]];
//            bundle = [NSBundle bundleWithPath:[containnerBundle pathForResource:@"TABundle" ofType:@"bundle"]];
//            NSLog(@"bundle6");
//        }
//
//        UIImage *rImage = nil;
//        UIImage *image = [UIImage imageNamed:@"login_bg" inBundle:bundle compatibleWithTraitCollection:nil];
//        NSLog(@"image1:%@",image);
//        rImage = image?: rImage;
//
//        NSString *imagePath = [bundle pathForResource:@"login_bg" ofType:@"png"];
//        image = [UIImage imageWithContentsOfFile:imagePath];
//        NSLog(@"image1:%@",image);
//        rImage = image?: rImage;
//
//        imagePath = [bundle pathForResource:@"login_bg@2x" ofType:@"png"];
//        image = [UIImage imageWithContentsOfFile:imagePath];
//        NSLog(@"image2:%@",image);
//        rImage = image?: rImage;

        
        
        [_bgImageView setImage:[UIImage imageNamed:@"login_bg"]];
        [_bgImageView setUserInteractionEnabled:YES];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _bgImageView;
}

-(UIImageView*)frameImageView{
    if (!_frameImageView){
        _frameImageView = [UIImageView new];
        [_frameImageView setImage:[UIImage imageNamed:@"login_frame"]];
        [_frameImageView setUserInteractionEnabled:YES];
    }
    return _frameImageView;
}

- (UIView *)tabView
{
    if (!_tabView){
        _tabView = [UIView new];
    }
    return _tabView;
}

-(UIButton*   )codeTab{
    if (!_codeTab){
        _codeTab = [UIButton buttonWithType:UIButtonTypeCustom];
        [_codeTab setTitle:@"验证码登录" forState:UIControlStateNormal];
        [_codeTab.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_codeTab setTitleColor:[UIColor jk_colorWithHex:0x9C9C9E] forState:UIControlStateNormal];
        [_codeTab setTitleColor:[UIColor jk_colorWithHex:0x49494A] forState:UIControlStateSelected];
        [_codeTab addTarget:self action:@selector(codeTabClick:) forControlEvents:UIControlEventTouchUpInside];
        _codeTab.selected = YES;
    }
    return _codeTab;
}

-(UIButton*   )passwordTab{
    if (!_passwordTab){
        _passwordTab = [UIButton buttonWithType:UIButtonTypeCustom];
        [_passwordTab setTitle:@"密码登录" forState:UIControlStateNormal];
        [_passwordTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_passwordTab setTitleColor:[UIColor jk_colorWithHex:0x9C9C9E] forState:UIControlStateNormal];
        [_passwordTab setTitleColor:[UIColor jk_colorWithHex:0x49494A] forState:UIControlStateSelected];
        [_passwordTab addTarget:self action:@selector(passwordTabClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _passwordTab;
}

-(UIView*     )usernameInputVIew{
    if (!_usernameInputVIew){
        _usernameInputVIew = [UIView new];
        _usernameInputVIew.layer.cornerRadius = kRelative(35);
        _usernameInputVIew.layer.masksToBounds = YES;
        _usernameInputVIew.backgroundColor = [UIColor whiteColor];
    }
    return _usernameInputVIew;
}

-(UITextField*)usernameTextField{
    if (!_usernameTextField){
        _usernameTextField = [UITextField new];
        _usernameTextField.delegate = self;
        _usernameTextField.placeholder = @"请输入手机号";
        _usernameTextField.returnKeyType = UIReturnKeyNext;
    }
    return _usernameTextField;
}

-(UIView*     )passwordInputVIew{
    if (!_passwordInputVIew){
        _passwordInputVIew = [UIView new];
        _passwordInputVIew.layer.cornerRadius = kRelative(35);
        _passwordInputVIew.layer.masksToBounds = YES;
        _passwordInputVIew.backgroundColor = [UIColor whiteColor];
    }
    return _passwordInputVIew;
}

-(UITextField*)passwordTextField{
    if (!_passwordTextField){
        _passwordTextField = [UITextField new];
        _passwordTextField.delegate = self;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTextField;
}

-(UIButton*   )eyeBtn{
    if (!_eyeBtn){
        _eyeBtn = [UIButton new];
        [_eyeBtn setImage:[UIImage imageNamed:@"login_closeEyes"] forState:UIControlStateNormal];
        [_eyeBtn setImage:[UIImage imageNamed:@"login_openEyes"] forState:UIControlStateSelected];
        [_eyeBtn addTarget:self action:@selector(eyeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn;
}

-(UIView*     )codeInputVIew{
    if (!_codeInputVIew){
        _codeInputVIew = [UIView new];
        _codeInputVIew.layer.cornerRadius = kRelative(35);
        _codeInputVIew.layer.masksToBounds = YES;
        _codeInputVIew.backgroundColor = [UIColor whiteColor];
    }
    return _codeInputVIew;
}

-(UITextField *)codeTextField{
    if (!_codeTextField){
        _codeTextField = [UITextField new];
        _codeTextField.delegate = self;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.returnKeyType = UIReturnKeyDone;
    }
    return _codeTextField;
}

-(UIButton*   )getCodeBtn{
    if (!_getCodeBtn){
        _getCodeBtn = [UIButton new];
        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_getCodeBtn setTitleColor:[UIColor jk_colorWithHex:0x49494A] forState:UIControlStateNormal];
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

-(UILabel*    )countDown{
    if (!_countDown){
        _countDown = [UILabel new];
    }
    return _countDown;
}

-(UIButton*   )loginBtn{
    if (!_loginBtn){
        _loginBtn = [UIButton new];
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:26]];
        [_loginBtn setTitleColor:[UIColor jk_colorWithHex:0xF0F0F3] forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = kRelative(35);
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x49494A]] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x9C9C9E]] forState:UIControlStateDisabled];
        [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton*   )agreeBtn{
    if (!_agreeBtn){
        _agreeBtn = [UIButton new];
        [_agreeBtn setImage:[UIImage imageNamed:@"login_agree_n"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"login_agree_s"] forState:UIControlStateSelected];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreeBtn;
}

-(void)drawAgreementTextView{
    NSString *strA = @"我已阅读并同意";
    NSString *strB = @"《用户协议》";
    NSString *strC = @"和";
    NSString *strD = @"《隐私政策》";
    
    NSString *info_str =[NSString stringWithFormat:@"%@%@%@%@",strA,strB,strC,strD];
    
    self.agreementText = [[UITextView alloc] init];
    [self.frameImageView addSubview:self.agreementText];
    
    UIColor *gray = [UIColor jk_colorWithHex:0x49494A];
    UIColor *blue = [UIColor blueColor];
    self.agreementText.font = [UIFont systemFontOfSize:10];
    self.agreementText.text = info_str;
    self.agreementText.textColor = gray;
    self.agreementText.backgroundColor = [UIColor clearColor];
    self.agreementText.delegate = self;
    //必须禁止输入，否则点击将弹出输入键
    self.agreementText.editable = NO;
    self.agreementText.scrollEnabled = NO;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing= 5;
    
    NSDictionary*attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:paragraphStyle};
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.agreementText.text attributes:attributes];
    
    [attributedString addAttribute:NSLinkAttributeName value:@"yonghuxieyi://" range:NSMakeRange(strA.length,strB.length)];
    [attributedString addAttribute:NSLinkAttributeName value:@"yinsizhengce://" range:NSMakeRange(strA.length+strB.length+strC.length,strD.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:gray range:NSMakeRange(0,info_str.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:blue range:NSMakeRange(strA.length,strB.length)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:blue range:NSMakeRange(strA.length+strB.length+strC.length,strD.length)];
    
    self.agreementText.attributedText= attributedString;
    
    for (UIGestureRecognizer *recognizer in self.agreementText.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]){
            recognizer.enabled = YES;
        }else{
            recognizer.enabled = NO;
        }
    }
}

@end
