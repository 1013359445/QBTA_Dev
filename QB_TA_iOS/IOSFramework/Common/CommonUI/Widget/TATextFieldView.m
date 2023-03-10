//
//  TATextFieldView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TATextFieldView.h"
#import "TAMacroDefinition.h"
#import "TACommonColor.h"

@interface TATextFieldView ()
@property (nonatomic, retain)UIImageView *editIcon;
@property (nonatomic, retain)UILabel *titleLabel;
@end

@implementation TATextFieldView

- (instancetype)initWithDelegate:(id)delegate title:(NSString *)title
{
    self = [super init];
    if (self) {
        self.textField = [UITextField new];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.layer.cornerRadius = kRelative(35);
        _textField.layer.masksToBounds = YES;
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRelative(30), 1)];
        _textField.leftView = paddingView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        _textField.textColor = kTAColor.c_49;
        _textField.font = [UIFont systemFontOfSize:12];
        _textField.delegate = delegate;
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];

        self.editIcon = [[UIImageView alloc] init];
        _editIcon.image = kBundleImage(@"icon_edit", @"Commom");
        [_textField addSubview:_editIcon];
        [_editIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kRelative(44));
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(kRelative(-20));
        }];
        
        self.titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.textColor = kTAColor.c_49;
        _titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(6));
            make.height.mas_equalTo(kRelative(30));
            make.bottom.mas_equalTo(self.mas_top).mas_offset(kRelative(-5));
        }];
        
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _textField.tag = tag;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    _editIcon.hidden = !userInteractionEnabled;
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == _textField) {
        [_textField becomeFirstResponder];
    }
    return hitView;
}

- (void)setText:(NSString *)text
{
    _text = text;
    _textField.text = text;
}

@end
