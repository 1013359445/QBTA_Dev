//
//  TAPersonalInfoView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAPersonalInfoView.h"
#import "TATextFieldView.h"

@interface TAPersonalInfoView () <UITextFieldDelegate>

@property (nonatomic, retain)TATextFieldView    *phoneTextField;
@property (nonatomic, retain)TATextFieldView    *nameTextField;
@property (nonatomic, retain)UIButton       *logOutBtn;

@end

@implementation TAPersonalInfoView

- (void)loadSubViews
{
    self.userInteractionEnabled = YES;

    [self addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kRelative(120));
        make.width.mas_equalTo(kRelative(580));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    [self addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_phoneTextField.mas_bottom).mas_offset(kRelative(66));
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@"name"]) {
        [self.presenter modifyInfo:textField.text];
    }
    return YES;
}

-(TATextFieldView    *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField = [[TATextFieldView alloc] initWithDelegate:self title:@"手机号"];
        _phoneTextField.userInteractionEnabled = NO;
        _phoneTextField.text = @"176****0001";
    }
    return _phoneTextField;
}

-(TATextFieldView    *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField = [[TATextFieldView alloc] initWithDelegate:self title:@"昵称"];
        _nameTextField.textField.returnKeyType = UIReturnKeyDone;
        _nameTextField.text = @"name";
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
