//
//  TAPersonalInfoView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAPersonalInfoView.h"

@interface TAPersonalInfoView () <UITextFieldDelegate>
@property (nonatomic, retain)UILabel        *phoneTitle;
@property (nonatomic, retain)UILabel        *nameTitle;
@property (nonatomic, retain)UITextField    *phoneTextField;
@property (nonatomic, retain)UITextField    *nameTextField;

@property (nonatomic, retain)UIButton       *logOutBtn;

@end

@implementation TAPersonalInfoView

- (void)loadSubViews
{
    self.userInteractionEnabled = YES;

    [self addSubview:self.phoneTitle];
    [self.phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kRelative(80));
    }];
    [self addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phoneTitle.mas_left);
        make.top.mas_equalTo(_phoneTitle.mas_bottom).mas_offset(kRelative(11));
        make.width.mas_equalTo(kRelative(580));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    [self addSubview:self.nameTitle];
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phoneTitle.mas_left);
        make.top.mas_equalTo(_phoneTitle.mas_top).mas_offset(kRelative(148));
    }];
    
    [self addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phoneTitle.mas_left);
        make.top.mas_equalTo(_nameTitle.mas_bottom).mas_offset(kRelative(11));
        make.width.mas_equalTo(kRelative(580));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    [self addSubview:self.logOutBtn];
    [self.logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(kRelative(460));
        make.height.mas_equalTo(kRelative(97));
        make.bottom.mas_equalTo(0);
    }];
}

-(void)logOutBtnClick
{
    [self.presenter logOut];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self.nameTextField) {
        [self.nameTextField becomeFirstResponder];
    }else {
        [self.nameTextField resignFirstResponder];
    }

    return hitView;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@"name"]) {
        [self.presenter modifyInfo:textField.text];
    }
    return YES;
}

-(UILabel        *)phoneTitle
{
    if (!_phoneTitle)
    {
        _phoneTitle = [UILabel new];
        _phoneTitle.text = @"手机号";
    }
    return _phoneTitle;
}

-(UILabel        *)nameTitle
{
    if (!_nameTitle)
    {
        _nameTitle = [UILabel new];
        _nameTitle.text = @"昵称";
    }
    return _nameTitle;
}

-(UITextField    *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField = [UITextField new];
        _phoneTextField.backgroundColor = [UIColor whiteColor];
        _phoneTextField.layer.cornerRadius = kRelative(35);
        _phoneTextField.layer.masksToBounds = YES;
        _phoneTextField.userInteractionEnabled = NO;
        _phoneTextField.text = @"176****0001";
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRelative(30), 1)];
        _phoneTextField.leftView = paddingView;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneTextField.textColor = kTAColor.c_49;
        _phoneTextField.font = [UIFont systemFontOfSize:12];
    }
    return _phoneTextField;
}

-(UITextField    *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField = [UITextField new];
        _nameTextField.backgroundColor = [UIColor whiteColor];
        _nameTextField.layer.cornerRadius = kRelative(35);
        _nameTextField.layer.masksToBounds = YES;
        _nameTextField.enabled = YES;
        _nameTextField.text = @"name";
        UIImageView *editIcon = [[UIImageView alloc] init];
        editIcon.image = kBundleImage(@"icon_edit", @"Commom");
        [_nameTextField addSubview:editIcon];
        [editIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kRelative(44));
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(kRelative(-20));
        }];
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRelative(30), 1)];
        _nameTextField.leftView = paddingView;
        _nameTextField.leftViewMode = UITextFieldViewModeAlways;
        _nameTextField.textColor = kTAColor.c_49;
        _nameTextField.font = [UIFont systemFontOfSize:12];
        
        _nameTextField.delegate = self;
        _nameTextField.returnKeyType = UIReturnKeyDone;

    }
    return _nameTextField;
}

-(UIButton       *)logOutBtn
{
    if (!_logOutBtn)
    {
        _logOutBtn = [UIButton new];
        [_logOutBtn setImage:kBundleImage(@"personal_logout_btn", @"Personal") forState:UIControlStateNormal];
        [_logOutBtn addTarget:self action:@selector(logOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logOutBtn;
}

@end
