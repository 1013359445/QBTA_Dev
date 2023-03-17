//
//  TASettingBasicsView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASettingBasicsView.h"
#import "TATextFieldView.h"

@interface TASettingBasicsView () <UITextFieldDelegate>

@property (nonatomic, retain)TATextFieldView    *nameText;
@property (nonatomic, retain)TATextFieldView    *storeyText;

@end

@implementation TASettingBasicsView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(816), kRelative(570));
}

- (void)loadSubViews
{
    [self addSubview:self.nameText];
    [self.nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(kRelative(115));
        make.height.mas_equalTo(kRelative(70));
        make.right.mas_equalTo(kRelative(-54));
    }];
    
    [self addSubview:self.storeyText];
    [self.storeyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(_nameText.mas_bottom).mas_offset(kRelative(75));
        make.height.mas_equalTo(kRelative(70));
        make.right.mas_equalTo(kRelative(-54));
    }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@"name"]) {
//        [self.presenter modifyInfo:textField.text];
    }
    return YES;
}

- (TATextFieldView *)nameText
{
    if (!_nameText) {
        _nameText = [[TATextFieldView alloc] initWithDelegate:self title:@"时空名称"];
        _nameText.text = @"房间名称";
        _nameText.userInteractionEnabled = YES;
        _nameText.textField.returnKeyType = UIReturnKeyDone;
    }
    return _nameText;
}

- (TATextFieldView *)storeyText
{
    if (!_storeyText) {
        _storeyText = [[TATextFieldView alloc] initWithDelegate:self title:@"所属楼层"];
        _storeyText.text = @"102层";
        _storeyText.userInteractionEnabled = NO;
    }
    return _storeyText;
}

@end
