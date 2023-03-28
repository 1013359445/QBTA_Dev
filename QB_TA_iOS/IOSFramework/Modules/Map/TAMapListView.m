//
//  TAMapListView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/27.
//

#import "TAMapListView.h"
#import "TATextFieldView.h"
#import "TASharScreenManager.h"

@interface TAMapListView () <UITextFieldDelegate>
@property (nonatomic, retain)UIImageView *bgView;
@property (nonatomic, retain)UIButton   *closeBtn;
@property (nonatomic, retain)TATextFieldView *changeRoomTextField;
@end

@implementation TAMapListView

+ (NSString *)cmd{
    return @"mapList";
}

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1100), kRelative(570));
}

- (void)loadSubViews
{
    self.layer.cornerRadius = kRelative(35);
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    [self showEffectView:YES];

    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
        
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];
    
    
    [self.bgView addSubview:self.changeRoomTextField];
    [self.changeRoomTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(800));
        make.height.mas_equalTo(kRelative(70));
    }];

    
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [[TASharScreenManager shareInstance] changeRomeWithRomeId:textField.text.intValue];
    textField.text = @"";
    
    return YES;
}

#pragma mark - lazy load
-(TATextFieldView*)changeRoomTextField
{
    if(!_changeRoomTextField){
        _changeRoomTextField = [[TATextFieldView alloc] initWithDelegate:self title:@"更换房间"];
        _changeRoomTextField.textField.placeholder = @"请输入房间id(建议5-7位数字)";
        _changeRoomTextField.userInteractionEnabled = YES;
        _changeRoomTextField.textField.returnKeyType = UIReturnKeyDone;
    }
    return _changeRoomTextField;
}

-(UIImageView*)bgView
{
    if(!_bgView){
        _bgView = [UIImageView new];
        _bgView.image = kBundleImage(@"frame_view_bg", @"Commom");
        [_bgView setContentMode:UIViewContentModeScaleAspectFill];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

-(UIButton       *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
