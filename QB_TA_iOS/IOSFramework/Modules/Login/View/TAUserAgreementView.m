//
//  TAUserAgreementView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TAUserAgreementView.h"

NSString * const UserAgreementString = @"用户协议：\n到家了甲方i啊金额临汾IE登记理发手机打给哦in飞机卡拉季阿卡到哪国际卡垃圾发古拉克发几个四大金刚开了房间卡古拉； 1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。";
NSString * const PrivacyPolicyString = @"隐私政策：\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。\n\n1。。。冻干粉金佛IG久啊发i加更；啊咖啡馆打客服金卡价；发is接待；放假四大金刚i及哦合计溶剂热i哦换季很尬办法金卡赌官方解决而韩国i和很尬hiu额和隔热管";

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
        make.width.mas_equalTo([TAUserAgreementView viewSize].width-kRelative(80));
        make.height.mas_equalTo(kRelative(100));
    }];

    [self.bottomView addSubview:self.cancelBtn];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(400));
        make.height.mas_equalTo(kRelative(70));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRelative(20));
    }];
    
    [self.bottomView addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.mas_equalTo(self.cancelBtn);
        make.right.mas_equalTo(-kRelative(20));
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setTitle:@"《用户协议》及《隐私政策》" ContentText:[NSString stringWithFormat:@"%@\n\n\n%@", UserAgreementString, PrivacyPolicyString]];
    });
}

- (void)setTitle:(NSString *)title ContentText:(NSString *)content
{
    self.titleLabel.text = title;
    self.textView.text = content;
    [self updateBottomViewConstraints];
}

- (void)setAttributedContent:(NSAttributedString *)attributedString{
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
    if (!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.textColor = kTAColor.c_49;
        _titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _titleLabel;
}

-(UITextView*   )textView{
    if (!_textView){
        _textView = [UITextView new];
        _textView.editable = NO;
        _textView.textColor = kTAColor.c_49;
        _textView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.2];
        _textView.font = [UIFont systemFontOfSize:13];
        _textView.delegate = self;

        _textView.layer.cornerRadius = kRelative(20);
        _textView.layer.masksToBounds = YES;
        CGFloat xMargin = kRelative(20), yMargin = kRelative(20);
        // 使用textContainerInset设置top、left、right
        _textView.textContainerInset = UIEdgeInsetsMake(yMargin, xMargin, 0, xMargin);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        _textView.contentInset = UIEdgeInsetsMake(0, 0, yMargin, 0);
        //防止在拼音打字时抖动
        _textView.layoutManager.allowsNonContiguousLayout=NO;
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
    }
    return _bottomView;
}

-(UIButton*     )cancelBtn{
    if (!_cancelBtn){
        _cancelBtn = [UIButton new];
        [_cancelBtn jk_setBackgroundColor:kTAColor.c_F0 forState:UIControlStateNormal];
        [_cancelBtn setTitle:@"不继续" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_cancelBtn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        _cancelBtn.layer.cornerRadius = kRelative(35);
        _cancelBtn.layer.borderWidth = kRelative(1);
        _cancelBtn.layer.borderColor = kTAColor.c_49.CGColor;
        _cancelBtn.layer.masksToBounds = YES;

        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIButton*     )okBtn{
    if (!_okBtn){
        _okBtn = [UIButton new];
        [_okBtn jk_setBackgroundColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_okBtn setTitle:@"同意并继续" forState:UIControlStateNormal];
        [_okBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_okBtn setTitleColor:kTAColor.c_F0 forState:UIControlStateNormal];
        _okBtn.layer.cornerRadius = kRelative(35);
        _okBtn.layer.masksToBounds = YES;
        [_okBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

@end
