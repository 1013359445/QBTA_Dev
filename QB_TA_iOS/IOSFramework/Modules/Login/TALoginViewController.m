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
#import "TAUserAgreementView.h"
#import "CommInterface.h"
#import "TACreatRoleViewController.h"

NSNotificationName const IOSFrameworkWaitingRoleDataNotification = @"getRoleData";
NSNotificationName const IOSFrameworkCreatRoleRoleNotification = @"creatRoleData";

extern NSString * const UserAgreementString = @"用户协议：\n到家了甲方i啊金额临汾IE登记理发手机打给哦in飞机卡拉季阿卡到哪国际卡垃圾发古拉克发几个四大金刚开了房间卡古拉； 1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。";
extern NSString * const PrivacyPolicyString = @"隐私政策：\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。冻干粉金佛IG久啊发i加更；啊咖啡馆打客服金卡价；发is接待；放假四大金刚i及哦合计溶剂热i哦换季很尬办法金卡赌官方解决而韩国i和很尬hiu额和隔热管";

@interface TALoginViewController () <UITextFieldDelegate, UITextViewDelegate, TAUserAgreementViewDelegate>

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
@property (nonatomic, retain)UILabel*           countDownLabel;

@property (nonatomic, retain)UIButton*          loginBtn;

@property (nonatomic, retain)UIButton*          agreeBtn;
@property (nonatomic, retain)UITextView*        agreementText;

@property (nonatomic, retain)NSTimer*           timer;
@property (nonatomic, assign)int                cd;


@property (nonatomic, retain)TAUserAgreementView*userAgreementView;
@end

@implementation TALoginViewController

+ (NSString *)cmd{
    return @"login";
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutViews];
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
        make.right.mas_equalTo(self.bgImageView).mas_offset(kRelative(-90));
    }];
    
    [self.bgImageView addSubview:self.userAgreementView];
    [self.userAgreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([TAUserAgreementView viewSize].width);
        make.height.mas_equalTo([TAUserAgreementView viewSize].height);
        make.centerY.mas_equalTo(0).offset(SCREENH_HEIGHT);
        make.right.mas_equalTo(self.bgImageView).mas_offset(kRelative(-90));
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
    [self.eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRelative(-30));
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(50));
        make.height.mas_equalTo(kRelative(50));
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

- (void)textFieldTextDidChange:(NSNotification *)notification
{
    [self verification:NO];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 富文本点击事件
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
    interaction:(UITextItemInteraction)interaction {
    [self.view endEditing:YES];
    
    if ([[URL scheme] isEqualToString:@"yonghuxieyi"]) {
    }else{
    }
    [_userAgreementView setTitle:@"《用户协议》及《隐私政策》" ContentText:[NSString stringWithFormat:@"%@\n\n\n%@", UserAgreementString, PrivacyPolicyString]];

    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.frameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0).offset(-SCREENH_HEIGHT);
        }];
        [weakself.userAgreementView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
        }];
        [weakself.bgImageView layoutIfNeeded];
        [weakself.bgImageView layoutSubviews];
    }];
    
    return YES;
}

#pragma mark - TAUserAgreementViewDelegate
- (void)userAgreementViewDidClickCloseBtn
{
    kWeakSelf(self);
    [UIView animateWithDuration:0.5 animations:^{
        [weakself.frameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
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
    [self.agreeBtn setSelected:YES];
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
    kWeakSelf(self);
    [UIView animateWithDuration:0.2 animations:^{
        [weakself.codeTab setSelected:YES];
        [weakself.codeTab.titleLabel setFont:[UIFont systemFontOfSize:14]];

        [weakself.passwordTab setSelected:NO];
        [weakself.passwordTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        weakself.passwordInputVIew.alpha = 0;
        weakself.codeInputVIew.alpha = 1;

        [weakself.tabView layoutIfNeeded];
        [weakself.tabView layoutSubviews];
    }];
    [self verification:NO];
}

- (void)passwordTabClick:(UIButton *)sender
{
    kWeakSelf(self);
    [UIView animateWithDuration:0.2 animations:^{
        
        [weakself.passwordTab setSelected:YES];
        [weakself.passwordTab.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        [weakself.codeTab setSelected:NO];
        [weakself.codeTab.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        weakself.passwordInputVIew.alpha = 1;
        weakself.codeInputVIew.alpha = 0;
        
        [weakself.tabView layoutIfNeeded];
        [weakself.tabView layoutSubviews];
    }];
    [self verification:NO];
}

- (void)eyeBtnClick:(UIButton *)sender
{
    //避免明文/密文切换后光标位置偏移
    self.passwordTextField.enabled = NO;    // the first one;
    self.passwordTextField.secureTextEntry = sender.isSelected;
    [sender setSelected:!sender.isSelected];
    self.passwordTextField.enabled = YES;  // the second one;
    [self.passwordTextField becomeFirstResponder]; // the third one
}

- (void)agreeBtnClick:(UIButton *)sender
{
    [self.agreeBtn setSelected:!sender.isSelected];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(self.agreeBtn.isSelected).stringValue forKey:@"agreement"];
    
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
        [MBProgressHUD showTextDialog:self.frameImageView msg:tipString];
        return;
    }

    TACaptchaParmModel *parmModel = [[TACaptchaParmModel alloc] init];
    parmModel.phone = self.phoneNumTextField.text;
    parmModel.type = @"2";

    kShowHUDAndActivity;
    kWeakSelf(self);
    [[TACaptchaInterface shareInstance] requestWithParmModel:parmModel dataModelClass:nil succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response, NSString *jsonStr) {
        //收到验证码
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response, NSString *jsonStr) {
        [MBProgressHUD showTextDialog:weakself.frameImageView msg:msg];
    } finishedBlock:^{
        [weakself.codeTextField becomeFirstResponder];
        //开始倒计时
        [weakself startCountdown];
        
        kHiddenHUDAndAvtivity;
    }];
    
}

#pragma mark 登录
- (void)loginBtnClick:(UIButton *)sender
{
    if (![self verification:YES]) {
        return;
    }
    
    TALoginParmModel *parmModel = [[TALoginParmModel alloc] init];
    parmModel.phone = self.phoneNumTextField.text;
    if (self.passwordInputVIew.alpha == 1) {
        parmModel.loginMode = @"0";
        parmModel.password = self.passwordTextField.text;

    }else {
        parmModel.loginMode = @"1";
        parmModel.captcha = self.codeTextField.text;
    }
    
    kShowHUDAndActivity;
    kWeakSelf(self);
    [[TALoginInterface shareInstance] requestWithParmModel:parmModel dataModelClass:[TAUserInfoDataModel class] succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response, NSString *jsonStr) {
        if (weakself.taskFinishBlock) {
            weakself.taskFinishBlock(jsonStr);
        }
        kHiddenHUDAndAvtivity;
        [weakself getRoleData];
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response, NSString *jsonStr) {
        if (weakself.taskFinishBlock) {
            weakself.taskFinishBlock(jsonStr);
        }
        [MBProgressHUD showTextDialog:weakself.frameImageView msg:msg];
        kHiddenHUDAndAvtivity;
    } finishedBlock:^{
    }];
}

- (void)getRoleData{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRoleDataBack:) name:IOSFrameworkWaitingRoleDataNotification object:nil];
    //获取角色信息
    [[CommInterface shareInstance].ueDelegate sendMessagesToUE:@"getRoleData" type:2 notification:IOSFrameworkWaitingRoleDataNotification];
    kShowHUDAndActivity;
}

- (void)getRoleDataBack:(NSNotification*)notification
{
    kHiddenHUDAndAvtivity;
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"roleData"] == nil) {
        [self tocReatRoleView];
    }else{
        [self goBack];
    }
}

- (void)tocReatRoleView
{
//    修改路由
//    TACmdModel *cmd = [TACmdModel new];
//    cmd.cmd = @"creatRole";
//    cmd.animated = YES;
//
//    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:^(id  _Nonnull result) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatRoleDataBack:) name:IOSFrameworkCreatRoleRoleNotification object:nil];
//        //请求创建角色
//        [[CommInterface shareInstance].ueDelegate sendMessagesToUE:result type:2 notification:IOSFrameworkCreatRoleRoleNotification];
//        kShowHUDAndActivity;
//    }];
    
    TACreatRoleViewController *vc = [[TACreatRoleViewController alloc] init];
    vc.taskFinishBlock = ^(id  _Nonnull result) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatRoleDataBack:) name:IOSFrameworkCreatRoleRoleNotification object:nil];
        //请求创建角色
        [[CommInterface shareInstance].ueDelegate sendMessagesToUE:result type:2 notification:IOSFrameworkCreatRoleRoleNotification];
        kShowHUDAndActivity;
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)creatRoleDataBack:(NSNotification*)notification
{
    kHiddenHUDAndAvtivity;
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"roleData"]) {
        [self close];//未实现
    }else{
        [MBProgressHUD showTextDialog:kWindow msg:@"创建角色失败"];
    }
}

- (void)startCountdown{
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
    }else if (self.passwordInputVIew.alpha == 1) {
        if (self.passwordTextField.text.length == 0) {
            tipString = @"请输入密码";
        }
    }else if (self.codeInputVIew.alpha == 1) {
        if (self.codeTextField.text.length == 0) {
            tipString = @"请输入验证码";
        }
    }
    
    if (self.agreeBtn.isSelected == NO) {
        tipString = @"请阅读并同意《用户协议》和《隐私政策》";
    }
    if (tips && tipString) {
        [MBProgressHUD showTextDialog:self.frameImageView msg:tipString];
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

#pragma mark - Getter/Setter
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
    }
    return _phoneNumTextField;
}

-(UIView*     )passwordInputVIew{
    if (!_passwordInputVIew){
        _passwordInputVIew = [UIView new];
        _passwordInputVIew.layer.cornerRadius = kRelative(35);
        _passwordInputVIew.layer.masksToBounds = YES;
        _passwordInputVIew.backgroundColor = [UIColor whiteColor];
        _passwordInputVIew.alpha = 0;
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
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *isAgreeStr = [defaults objectForKey:@"agreement"];
        [_agreeBtn setSelected:isAgreeStr.boolValue];
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
