//
//  TALoginView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import "TALoginView.h"


@interface TALoginView () <UITextFieldDelegate, UITextViewDelegate>

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
@property (nonatomic, retain)UILabel*           countDownLabel;

@property (nonatomic, retain)UIButton*          loginBtn;
@property (nonatomic, retain)UIButton*          agreeBtn;

@property (nonatomic, retain)UITextView*        agreementText;

@property (nonatomic, retain)NSTimer*           timer;
@property (nonatomic, assign)int                cd;
@property (nonatomic, assign)BOOL               isPasswordMode;

@end

@implementation TALoginView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(600), kRelative(600));
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadSubViews
{
    [self addSubview:self.frameImageView];
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
        make.left.mas_equalTo([TALoginView viewSize].width*2);
        make.top.mas_equalTo(_phoneNumInputVIew.mas_bottom).mas_offset(kRelative(40));
        make.height.mas_equalTo(kRelative(70));
        make.width.mas_equalTo(_phoneNumInputVIew.mas_width);

    }];
    
    [self.passwordInputVIew addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-100));
    }];
    
    [self.passwordInputVIew addSubview:self.eyeBtn];
    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRelative(-30));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(50));
        make.height.mas_equalTo(kRelative(50));
    }];
    
    [self.frameImageView addSubview:self.codeInputVIew];
    [self.codeInputVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(50));
        make.top.mas_equalTo(_phoneNumInputVIew.mas_bottom).mas_offset(kRelative(40));
        make.height.mas_equalTo(kRelative(70));
        make.width.mas_equalTo(_phoneNumInputVIew.mas_width);
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
    
    [self.codeInputVIew addSubview:self.countDownLabel];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.phoneNumTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.codeTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];
}

- (void)updateSubViews{
    BOOL isAgreeStr = @([self.presenter getDefaultAgreement].integerValue).boolValue;
    [_agreeBtn setSelected:isAgreeStr];
    
    NSString *defaultPassword = [self.presenter getDefaultPassword];
    if (defaultPassword) {
        _passwordTextField.text = defaultPassword;
    }
    
    NSString *defaultPhoneNumber = [self.presenter getDefaultPhoneNumber];
    if (defaultPhoneNumber) {
        _phoneNumTextField.text = defaultPhoneNumber;
    }
    
    NSString *defaultLoginMode = [self.presenter getDefaultLoginMode];
    if (!defaultLoginMode ) {
        [self codeTabClick:nil];
    }else if (defaultLoginMode.integerValue == 1) {
        [self codeTabClick:nil];
    }else{
        [self passwordTabClick:nil];
    }
}

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    [self verification:NO];
}

#pragma mark - 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
    interaction:(UITextItemInteraction)interaction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewDidClickUserAgreement:)]) {
        [self.delegate loginViewDidClickUserAgreement:[URL scheme]];
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self verification:NO];
    return true;
}

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
    if (!_isPasswordMode) {
        return;
    }
    [self endEditing:YES];
    _isPasswordMode = NO;
    kWeakSelf(self);

    void (^change)(void)  = ^{
        [weakself.codeTab setSelected:YES];
        [weakself.codeTab.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [weakself.passwordTab setSelected:NO];
        [weakself.passwordTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
    };
    if (sender == nil) {
        change ();
        [self.passwordInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([TALoginView viewSize].width*2);
        }];
        [self.codeInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(50));
        }];
        [self verification:NO];
        return;
    }
    

    [UIView animateWithDuration:0.2f animations:^{
        weakself.passwordInputVIew.alpha = 0.5;

        [weakself.passwordInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([TALoginView viewSize].width*2);
        }];
        
        [weakself.frameImageView layoutIfNeeded];
        [weakself.frameImageView layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2f animations:^{
                weakself.passwordInputVIew.alpha = 1;

                [weakself.codeInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kRelative(50));
                }];
                [weakself.frameImageView layoutIfNeeded];
                [weakself.frameImageView layoutSubviews];
            }];
        }
    }];

    [UIView animateWithDuration:0.25 animations:^{
        change();
        [weakself.tabView layoutIfNeeded];
        [weakself.tabView layoutSubviews];
    }];
    [self verification:NO];
}

- (void)passwordTabClick:(UIButton *)sender
{
    if (_isPasswordMode) {
        return;
    }
    _isPasswordMode = YES;
    kWeakSelf(self);

    void (^change)(void)  = ^{
        [weakself.passwordTab setSelected:YES];
        [weakself.passwordTab.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [weakself.codeTab setSelected:NO];
        [weakself.codeTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
    };
    
    if (sender == nil) {
        change ();
        [self.passwordInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(50));
        }];
        [self.codeInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([TALoginView viewSize].width*2);
        }];
        [self verification:NO];
        return;
    }
    
    [UIView animateWithDuration:0.2f animations:^{
        weakself.codeInputVIew.alpha = 0.5;
        [weakself.codeInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([TALoginView viewSize].width*2);
        }];
        [weakself.frameImageView layoutIfNeeded];
        [weakself.frameImageView layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:0.2f animations:^{
                weakself.codeInputVIew.alpha = 1;

                [weakself.passwordInputVIew mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(kRelative(50));
                }];
                [weakself.frameImageView layoutIfNeeded];
                [weakself.frameImageView layoutSubviews];
            }];
        }
    }];
        
    [UIView animateWithDuration:0.25 animations:^{
        change();
        [weakself.tabView layoutIfNeeded];
        [weakself.tabView layoutSubviews];
    }];
    [self verification:NO];
}

- (void)eyeBtnClick:(UIButton *)sender
{
    //明文/密文切换
    self.passwordTextField.secureTextEntry = sender.isSelected;
    [sender setSelected:!sender.isSelected];
}

- (void)agreeBtnClick:(UIButton *)sender
{
    [self.agreeBtn setSelected:!sender.isSelected];

    [self.presenter setDefaultAgreement:@((int)self.agreeBtn.isSelected).stringValue];
    [self verification:NO];
}

- (void)agreeBtnSelected
{
    [self.agreeBtn setSelected:YES];
    [self.presenter setDefaultAgreement:@((int)self.agreeBtn.isSelected).stringValue];
    [self verification:NO];
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
        [TAToast showTextDialog:self.frameImageView msg:tipString];
        return;
    }

    TACaptchaParmModel *parmModel = [[TACaptchaParmModel alloc] init];
    parmModel.phone = self.phoneNumTextField.text;
    parmModel.type = @"2";

    [self.presenter getVCodeWithParam:parmModel];
}

#pragma mark 登录
- (void)loginBtnClick:(UIButton *)sender
{
    if (![self verification:YES]) {
        return;
    }
    
    TALoginParmModel *parmModel = [[TALoginParmModel alloc] init];
    parmModel.phone = self.phoneNumTextField.text;
    if (_isPasswordMode) {
        parmModel.loginMode = @"0";
        parmModel.password = (NSString *)self.passwordTextField.text;

    }else {
        parmModel.loginMode = @"1";
        parmModel.captcha = self.codeTextField.text;
    }
    
    [self.presenter loginWithParam:parmModel];

    [self endEditing:YES];
}


- (void)startCountdown
{
    //收到验证码，开始倒计时
    [self.codeTextField becomeFirstResponder];

    if (!_timer) {
        _cd = 60;
        self.getCodeBtn.hidden = YES;
        self.countDownLabel.hidden = NO;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownAction) userInfo:nil repeats:YES];
    }
}

- (void)countdownAction{
    if (_cd == 0) {
        [_timer invalidate];
        _timer = nil;
        self.getCodeBtn.hidden = NO;
        self.countDownLabel.hidden = YES;
    }
    self.countDownLabel.text = [NSString stringWithFormat:@"%ds", _cd];
    _cd --;
}

- (BOOL)verification:(BOOL)tips
{
    NSString *tipString = nil;
    
    if (self.phoneNumTextField.text.length == 0) {
        tipString = @"请输入手机号";
    }else if (self.phoneNumTextField.text.length != 11) {
        tipString = @"手机号格式错误";
    }else if (_isPasswordMode) {
        if (self.passwordTextField.text.length == 0) {
            tipString = @"请输入密码";
        }
    }else if (!_isPasswordMode) {
        if (self.codeTextField.text.length == 0) {
            tipString = @"请输入验证码";
        }
    }
    
    if (self.agreeBtn.isSelected == NO) {
        tipString = @"请阅读并同意《用户协议》和《隐私政策》";
    }
    if (tips && tipString) {
        [TAToast showTextDialog:self.frameImageView msg:tipString];
        return NO;
    }

    
    BOOL isCorrect = !tipString ? YES : NO;
    if (isCorrect) {
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:kTAColor.c_49] forState:UIControlStateNormal];
    }else{
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:kTAColor.c_9C] forState:UIControlStateNormal];
    }
    
    return isCorrect;
}

#pragma mark - lazy load
-(UIImageView*)frameImageView{
    if (!_frameImageView){
        _frameImageView = [UIImageView new];
        [_frameImageView setImage:kBundleImage(@"login_frame", @"Login")];
        [_frameImageView setUserInteractionEnabled:YES];
        _frameImageView.clipsToBounds = YES;
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
        [_codeTab setTitleColor:kTAColor.c_9C forState:UIControlStateNormal];
        [_codeTab setTitleColor:kTAColor.c_49 forState:UIControlStateSelected];
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
        [_passwordTab setTitleColor:kTAColor.c_9C forState:UIControlStateNormal];
        [_passwordTab setTitleColor:kTAColor.c_49 forState:UIControlStateSelected];
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
        _phoneNumTextField.textColor = kTAColor.c_49;
        _phoneNumTextField.font = [UIFont systemFontOfSize:12];

        _phoneNumTextField.jk_maxLength = 11;
    }
    return _phoneNumTextField;
}

-(UIView*     )passwordInputVIew{
    if (!_passwordInputVIew){
        _passwordInputVIew = [UIView new];
        _passwordInputVIew.layer.cornerRadius = kRelative(35);
        _passwordInputVIew.layer.masksToBounds = YES;
        _passwordInputVIew.backgroundColor = [UIColor whiteColor];
//        _passwordInputVIew.alpha = 0;
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
        _passwordTextField.textColor = kTAColor.c_49;
        _passwordTextField.font = [UIFont systemFontOfSize:12];
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
        _codeTextField.textColor = kTAColor.c_49;
        _codeTextField.font = [UIFont systemFontOfSize:12];
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
        [_getCodeBtn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

-(UILabel*    )countDownLabel{
    if (!_countDownLabel){
        _countDownLabel = [UILabel new];
        _countDownLabel.textColor = kTAColor.c_629C;
        _countDownLabel.font = [UIFont systemFontOfSize:12];

    }
    return _countDownLabel;
}

-(UIButton*   )loginBtn{
    if (!_loginBtn){
        _loginBtn = [UIButton new];
        [_loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_loginBtn setTitleColor:kTAColor.c_F0 forState:UIControlStateNormal];
        _loginBtn.layer.cornerRadius = kRelative(35);
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn setBackgroundImage:[UIImage jk_imageWithColor:kTAColor.c_9C] forState:UIControlStateNormal];
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
    
    UIColor *gray = kTAColor.c_49;
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
    
    [attributedString addAttribute:NSLinkAttributeName value:@"yhxy://" range:NSMakeRange(strA.length,strB.length)];
    [attributedString addAttribute:NSLinkAttributeName value:@"yszc://" range:NSMakeRange(strA.length+strB.length+strC.length,strD.length)];
    
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
