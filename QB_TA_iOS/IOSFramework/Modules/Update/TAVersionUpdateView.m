//
//  TAVersionUpdateView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/28.
//

#import "TAVersionUpdateView.h"

@interface TAVersionUpdateView () <UITextViewDelegate>

@property (nonatomic, retain)UIImageView    *bgImageView;
@property (nonatomic, retain)UILabel        *titleLabel;
@property (nonatomic, retain)UITextView     *textView;
@property (nonatomic, retain)UIButton       *closeBtn;
@property (nonatomic, retain)UIButton       *okBtn;

@end

@implementation TAVersionUpdateView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1000), kRelative(590));
}

- (void)loadSubViews
{
}

#pragma mark - lazy load
-(UIImageView*)bgImageView{
    if (!_bgImageView){
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        UIImage *image = kBundleImage(@"login_agreement", @"Login");
        [_bgImageView setImage:image];
        [_bgImageView setUserInteractionEnabled:YES];
        [_bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _bgImageView;
}

-(UILabel        *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
    }
    return _titleLabel;
}
-(UITextView     *)textView
{
    if (!_textView)
    {
        _textView = [UITextView new];
    }
    return _textView;
}
-(UIButton       *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton new];
    }
    return _closeBtn;
}
-(UIButton       *)okBtn
{
    if (!_okBtn)
    {
        _okBtn = [UIButton new];
    }
    return _okBtn;
}


@end
