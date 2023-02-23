//
//  TAUserAgreementView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TAUserAgreementView.h"

@interface TAUserAgreementView () <UITextViewDelegate>

@property (nonatomic, retain)UIImageView    *bgImageView;
@property (nonatomic, retain)UILabel        *titleLabel;
@property (nonatomic, retain)UITextView     *textView;
@property (nonatomic, retain)UIButton       *closeBtn;

@property (nonatomic, retain)UIView         *bottomView;
@property (nonatomic, retain)UIButton       *cancelBtn;
@property (nonatomic, retain)UIButton       *okBtn;

@end

@implementation TAUserAgreementView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1000), kRelative(590));
}

- (void)loadSubViews
{
    [self addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo([TAUserAgreementView viewSize]);
    }];
    [self.bgImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(kRelative(60));
        make.top.mas_equalTo(kRelative(24));
    }];
    [self.bgImageView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.width.height.mas_equalTo(kRelative(66));
        make.right.mas_equalTo(kRelative(-12));
    }];
    
    [self.bgImageView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(100));
        make.left.mas_equalTo(kRelative(40));
        make.right.mas_equalTo(kRelative(-40));
        make.bottom.mas_equalTo(kRelative(-38));
    }];
    
    [self.bgImageView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(100));
        make.left.mas_equalTo(kRelative(40));
        make.right.mas_equalTo(kRelative(-40));
        make.bottom.mas_equalTo(kRelative(-38));
    }];

    
    [self.textView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.contentSize.height);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo([TAUserAgreementView viewSize].width);
        make.height.mas_equalTo(kRelative(100));
    }];

    [self.bottomView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(445));
        make.height.mas_equalTo(kRelative(70));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(40));
    }];
    
    [self.bottomView addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.mas_equalTo(self.cancelBtn);
        make.right.mas_equalTo(kRelative(-40));
    }];
}

- (void)setTitle:(NSString *)title ContentText:(NSString *)content
{
    self.titleLabel.text = title;
    self.textView.text = content;
    [self updateBottomViewConstraints];
}

- (void)setAttributedContent:(NSAttributedString *)attributedString{
//    NSString *htmlString = @"HeaderSubheader<p>Some text</p><img src='http://blogs.babble.com/famecrawler/files/2010/11/mickey_mouse-1097.jpg' width=70 height=100 />";
//    attributedString = [[NSAttributedString alloc]
//              initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
//                   options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
//        documentAttributes: nil
//                     error: nil
//    ];
    
    self.textView.attributedText = attributedString;
    [self updateBottomViewConstraints];
}

- (void)updateBottomViewConstraints
{
    [self.textView layoutSubviews];
    CGSize textViewContentSize = self.textView.contentSize;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textViewContentSize.height);
    }];
    [self.textView setContentSize:CGSizeMake(textViewContentSize.width, textViewContentSize.height + kRelative(100))];
}

- (void)closeBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAgreementViewDidClickCloseBtn)]) {
        [self.delegate userAgreementViewDidClickCloseBtn];
    }
}

- (void)okBtnClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(userAgreementViewDidClickOKBtn)]) {
        [self.delegate userAgreementViewDidClickOKBtn];
    }
    [self closeBtnClick];
}

- (void)cancelBtnClick
{
    [self closeBtnClick];
}

#pragma mark - Getter/Setter
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
    if (!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor jk_colorWithHex:0x49494A];
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

-(UITextView*   )textView{
    if (!_textView){
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.textColor = [UIColor jk_colorWithHex:0x49494A];
        _textView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.delegate = self;
    }
    return _textView;
}

-(UIButton*     )closeBtn{
    if (!_closeBtn){
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIView         *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor redColor];
    }
    return _bottomView;
}

-(UIButton*     )cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0xF0F0F3]] forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"不继续" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_cancelBtn setTitleColor:[UIColor jk_colorWithHex:0x49494A] forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = kRelative(35);
        _cancelBtn.layer.borderWidth = 1;
        _cancelBtn.layer.borderColor = [UIColor jk_colorWithHex:0x49494A].CGColor;
        _cancelBtn.layer.masksToBounds = YES;

        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton*     )okBtn{
    if (!_okBtn){
        _okBtn = [UIButton new];
        [_cancelBtn setImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x49494A]] forState:UIControlStateNormal];
        [_okBtn setTitle:@"同意并继续" forState:UIControlStateNormal];
        [_okBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_okBtn setTitleColor:[UIColor jk_colorWithHex:0xF0F0F3] forState:UIControlStateNormal];
        _okBtn.layer.cornerRadius = kRelative(35);
        _okBtn.layer.masksToBounds = YES;
        [_okBtn setBackgroundImage:[UIImage jk_imageWithColor:[UIColor jk_colorWithHex:0x9C9C9E]] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

@end


