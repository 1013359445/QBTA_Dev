//
//  TALoginViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TALoginViewController.h"
#import "TALoginInterface.h"
#import "TAUserInfoDataModel.h"
#import "TALoginParmModel.h"
#import "TACaptchaParmModel.h"
#import "TACaptchaInterface.h"

@interface TALoginViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, retain)UIImageView*       bgImageView;
@property (nonatomic, retain)UIImageView*       frameImageView;
@property (nonatomic, retain)UIView*            tabView;
@property (nonatomic, retain)UIButton*          codeTab;
@property (nonatomic, retain)UIButton*          passwordTab;

@property (nonatomic, retain)UIView*            phoneNumInputVIew;
@property (nonatomic, retain)UITextField*       phoneNumTextField;

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
    
    [self.frameImageView addSubview:self.phoneNumInputVIew];
    [self.phoneNumInputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(50));
        make.right.mas_equalTo(kRelative(-50));
        make.height.mas_equalTo(kRelative(70));
        make.top.mas_equalTo(kRelative(120));
    }];
    
    [self.phoneNumInputVIew addSubview:self.phoneNumTextField];
    [self.phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(30));
    }];
    
    [self.frameImageView addSubview:self.passwordInputVIew];
    [self.passwordInputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(50));
        make.right.mas_equalTo(kRelative(-50));
        make.height.mas_equalTo(kRelative(70));
        make.top.mas_equalTo(_phoneNumInputVIew.mas_bottom).mas_offset(kRelative(40));
        
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
        make.right.mas_equalTo(_frameImageView.mas_right);
        make.height.mas_equalTo(kRelative(56));
        make.top.mas_equalTo(_agreeBtn.mas_top).mas_offset(kRelative(-12));

    }];
    [self.agreementText layoutIfNeeded];
}

#pragma mark - 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    if ([[URL scheme] isEqualToString:@"yonghuxieyi"]) {
        LRLog(@"富文本点击 用户协议");
    }else{
        LRLog(@"富文本点击 隐私政策");
    }
    
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self verification:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self verification:NO];

    return YES;
}

#pragma mark - UIButton Actions
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
        
        weakself.passwordInputVIew.hidden = YES;
        weakself.codeInputVIew.hidden = NO;
    }];
    [self verification:NO];
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
        
        weakself.passwordInputVIew.hidden = NO;
        weakself.codeInputVIew.hidden = YES;
    }];
    [self verification:NO];
}

- (void)eyeBtnClick:(UIButton *)sender
{
    //避免明文/密文切换后光标位置偏移
    self.passwordTextField.enabled = NO;    // the first one;
    self.passwordTextField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
    self.passwordTextField.enabled = YES;  // the second one;
    [self.passwordTextField becomeFirstResponder]; // the third one
}

#pragma mark 获取验证码
- (void)getCodeBtnClick:(UIButton *)sender
{
    NSString *tipString = nil;
    if (self.phoneNumTextField.text.length == 0) {
        tipString = @"请输入手机号";
    }else if (self.phoneNumTextField.text.length != 11) {
        tipString = @"手机号格式错误";
    }
    if (tipString) {
        [MBProgressHUD showTextDialog:self.frameImageView msg:tipString];
        return;
    }

    TACaptchaParmModel *parmModel = [[TACaptchaParmModel alloc] init];
    parmModel.phone = self.phoneNumTextField.text;
    parmModel.type = @"2";

    kShowHUDAndActivity;
    LRWeakSelf(self);
    [[TACaptchaInterface shareInstance] requestWithParmModel:parmModel dataModelClass:nil succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response) {
        //收到验证码
        
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response) {
        [MBProgressHUD showTextDialog:weakself.frameImageView msg:msg];
    } finishedBlock:^{
        kHiddenHUDAndAvtivity;
        [weakself.codeTextField becomeFirstResponder];
    }];
    [self.codeTextField becomeFirstResponder];
}

#pragma mark 登录
- (void)loginBtnClick:(UIButton *)sender
{
    if (![self verification:YES]) {
        return;
    }
    
    TALoginParmModel *parmModel = [[TALoginParmModel alloc] init];
    parmModel.phone = self.phoneNumTextField.text;
    if (self.passwordInputVIew.isHidden == NO) {
        parmModel.loginMode = @"0";
        parmModel.password = self.passwordTextField.text;

    }else {
        parmModel.loginMode = @"1";
        parmModel.captcha = self.codeTextField.text;
    }
    
    kShowHUDAndActivity;
    LRWeakSelf(self);
    [[TALoginInterface shareInstance] requestWithParmModel:parmModel dataModelClass:[TAUserInfoDataModel class] succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response) {
        
        weakself.taskFinishBlock(response);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself goBack];
        });
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response) {
        weakself.taskFinishBlock(response);
        [MBProgressHUD showTextDialog:weakself.frameImageView msg:msg];
    } finishedBlock:^{
        kHiddenHUDAndAvtivity;
    }];
}

- (void)agreeBtnClick:(UIButton *)sender
{
    [sender setSelected:!sender.selected];
    
    [self verification:NO];
}

- (BOOL)verification:(BOOL)tips
{
    NSString *tipString = nil;
    
    if (self.phoneNumTextField.text.length == 0) {
        tipString = @"请输入手机号";
    }else if (self.phoneNumTextField.text.length != 11) {
        tipString = @"手机号格式错误";
    }else if (self.passwordInputVIew.isHidden == NO && self.passwordTextField.text.length == 0) {
        tipString = @"请输入密码";
    }else if (self.codeInputVIew.isHidden == NO && self.codeTextField.text.length == 0) {
        tipString = @"请输入验证码";
    }else if (self.agreeBtn.selected == NO) {
        tipString = @"请阅读并同意《用户协议》和《隐私政策》";
    }
    
    if (tips && tipString) {
        [MBProgressHUD showTextDialog:self.frameImageView msg:tipString];
    }
    
    BOOL isCorrect = !tipString ? YES : NO;
    
    if (isCorrect) {
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x49494A]] forState:UIControlStateNormal];
    }else{
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x9C9C9E]] forState:UIControlStateNormal];
    }
    
    return isCorrect;
}

#pragma mark Getter/Setter
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

-(UIImageView*)frameImageView{
    if (!_frameImageView){
        _frameImageView = [UIImageView new];
        [_frameImageView setImage:kBundleImage(@"login_frame", @"Login")];
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

-(UIView*     )phoneNumInputVIew{
    if (!_phoneNumInputVIew){
        _phoneNumInputVIew = [UIView new];
        _phoneNumInputVIew.layer.cornerRadius = kRelative(35);
        _phoneNumInputVIew.layer.masksToBounds = YES;
        _phoneNumInputVIew.backgroundColor = [UIColor whiteColor];
    }
    return _phoneNumInputVIew;
}

-(UITextField*)phoneNumTextField{
    if (!_phoneNumTextField){
        _phoneNumTextField = [UITextField new];
        _phoneNumTextField.delegate = self;
        _phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumTextField.placeholder = @"请输入手机号";
        _phoneNumTextField.returnKeyType = UIReturnKeyNext;
    }
    return _phoneNumTextField;
}

-(UIView*     )passwordInputVIew{
    if (!_passwordInputVIew){
        _passwordInputVIew = [UIView new];
        _passwordInputVIew.layer.cornerRadius = kRelative(35);
        _passwordInputVIew.layer.masksToBounds = YES;
        _passwordInputVIew.backgroundColor = [UIColor whiteColor];
        _passwordInputVIew.hidden = YES;
    }
    return _passwordInputVIew;
}

-(UITextField*)passwordTextField{
    if (!_passwordTextField){
        _passwordTextField = [UITextField new];
        _passwordTextField.delegate = self;
        _passwordTextField.keyboardType = UIKeyboardTypeASCIICapable;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.returnKeyType = UIReturnKeyDone;
    }
    return _passwordTextField;
}

-(UIButton*   )eyeBtn{
    if (!_eyeBtn){
        _eyeBtn = [UIButton new];
        [_eyeBtn setImage:kBundleImage(@"login_closeEyes", @"Login") forState:UIControlStateNormal];
        [_eyeBtn setImage:kBundleImage(@"login_openEyes", @"Login") forState:UIControlStateSelected];
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
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.placeholder = @"请输入验证码";
        _codeTextField.returnKeyType = UIReturnKeyDone;
        if (@available(iOS 12.0, *)) {
            _codeTextField.textContentType = UITextContentTypeOneTimeCode;
        }
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
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x9C9C9E]] forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

-(UIButton*   )agreeBtn{
    if (!_agreeBtn){
        _agreeBtn = [[UIButton alloc] init];
        [_agreeBtn setImage:kBundleImage(@"login_agree_n", @"Login") forState:UIControlStateNormal];
        [_agreeBtn setImage:kBundleImage(@"login_agree_s", @"Login") forState:UIControlStateSelected];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_agreeBtn setSelected:NO];
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
