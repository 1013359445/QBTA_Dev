//
//  TASettingAboutView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASettingAboutView.h"

@interface TASettingAboutView ()
@property (nonatomic, retain)UILabel *titleLabel;
@property (nonatomic, retain)UITextView *textView;
@end

@implementation TASettingAboutView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(816), kRelative(570));
}

- (void)loadSubViews
{
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(0));
        make.top.mas_equalTo(kRelative(80));
    }];
    
    [self addSubview:self.textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(0));
        make.top.mas_equalTo(_titleLabel.mas_bottom).mas_offset(kRelative(20));
        make.right.mas_equalTo(kRelative(-58));
        make.bottom.mas_equalTo(kRelative(-60));
    }];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    self.textView.text = content;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [UITextView new];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = kTAColor.c_49;
        _textView.font = [UIFont systemFontOfSize:11];
        [_textView setShowsHorizontalScrollIndicator:NO];
        [_textView setShowsVerticalScrollIndicator:NO];
    }
    return _textView;
}

-(UILabel    *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kTAColor.c_49;
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}
@end
