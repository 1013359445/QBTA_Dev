//
//  TAMemberView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import "TAMemberView.h"
#import "TAAlertViewController.h"

@interface TAMemberView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain)UIView     *contentView;
@property (nonatomic, retain)UILabel    *titleLabel;
@property (nonatomic, retain)UILabel    *numberLabel;
@property (nonatomic, retain)UITableView*tableView;
@property (nonatomic, retain)UIButton   *leftBtn;
@property (nonatomic, retain)UIButton   *rightBtn;
//@property (nonatomic, retain)UIView     *tableHeaderView;
@end

@implementation TAMemberView

+ (TACmdModel *)cmd{
    TACmdModel *cmdModel = [TACmdModel new];
    cmdModel.cmd = @"member";
    cmdModel.animated = YES;
    return cmdModel;
}

+ (CGSize)viewSize
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;
    }
    return self;
}

- (void)loadSubViews
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(640));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(640));
    }];
    
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(24));
        make.height.mas_equalTo(kRelative(40));
        make.centerX.mas_equalTo(0);
    }];
    
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_titleLabel);
        make.height.mas_equalTo(kRelative(22));
        make.left.mas_equalTo(_titleLabel.mas_right).offset(kRelative(10));
    }];
    
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(88));
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(kRelative(-110));
    }];
    
    [self.contentView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(205));
        make.height.mas_equalTo(kRelative(60));
        make.left.mas_equalTo(kRelative(30));
        make.bottom.mas_equalTo(kRelative(-30));
    }];
    
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.mas_equalTo(_leftBtn);
        make.right.mas_equalTo(kRelative(-30));
    }];
    
//    UIAlertViewController *controller = [[UIAlertViewController alloc] init];
//    [controller setTitle:@"温馨提示"];
//    [controller setViewContent:@"alert的提示内容区域"];
//    [controller alertActionBlock:^BOOL(NSInteger index) {
//        return YES;
//    }];
//    [controller showInViewController:self];
}

- (void)showView:(UIView *)superView animated:(BOOL)animated
{
    if (self.superview) {
        return;
    }else {
        [superView addSubview:self.effectView];
        self.effectView.hidden = !self.showEffectView;

        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([[self class] viewSize].width);
            make.height.mas_equalTo([[self class] viewSize].height);
            make.center.mas_offset(0);
        }];
    }
    if (!animated) {
        return;
    }
    if (self.inAnimateds) {
        return;
    }
    self.inAnimateds = YES;

    [self layoutIfNeeded];
    [self layoutSubviews];
    self.effectView.alpha = 0.3;
    kWeakSelf(self);
    [UIView animateWithDuration:0.25 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //弹入弹出
                     animations:^{
        //从右侧滑入
        [weakself.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
        [weakself layoutIfNeeded];
        [weakself layoutSubviews];
        weakself.effectView.alpha = 0.8;
    } completion:^(BOOL finished) {
        if (finished)
        {
            weakself.inAnimateds = NO;
        }
    }];
}

- (void)hideViewAnimated:(BOOL)animated
{
    if (!animated) {
        [self.effectView removeFromSuperview];
        [self removeFromSuperview];
        return;
    }
    if (self.inAnimateds) {
        return;
    }
    self.inAnimateds = YES;

    kWeakSelf(self);
    [UIView animateWithDuration:0.25 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //弹入弹出
                     animations:^{
        //从右侧滑出
        [weakself.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(kRelative(640));
        }];
        [weakself layoutIfNeeded];
        [weakself layoutSubviews];
        weakself.effectView.alpha = 0.3;
    } completion:^(BOOL finished) {
        if (finished)
        {
            weakself.inAnimateds = NO;
            [weakself.effectView removeFromSuperview];
            [weakself removeFromSuperview];
        }
    }];
}

- (void)leftBtnClick{
    
}

- (void)rightBtnClick{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self hideViewAnimated:YES];
}

- (UIView     *)contentView
{
    if (!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = kTAColor.c_F0;
    }
    return _contentView;
}

- (UILabel     *)titleLabel
{
    if (!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.text = @"参会人员";
        _titleLabel.textColor = kTAColor.c_49;
    }
    return _titleLabel;
}

- (UILabel     *)numberLabel
{
    if (!_numberLabel){
        _numberLabel = [UILabel new];
        _numberLabel.font = [UIFont systemFontOfSize:8];
        _numberLabel.textColor = kTAColor.c_49;
    }
    return _numberLabel;
}

- (UITableView *)tableView
{
    if (!_tableView){
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (UIButton    *)leftBtn
{
    if (!_leftBtn){
        _leftBtn = [UIButton new];
        _leftBtn.backgroundColor = kTAColor.c_49;
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton    *)rightBtn
{
    if (!_rightBtn){
        _rightBtn = [UIButton new];
        _rightBtn.backgroundColor = kTAColor.c_F0;
        _rightBtn.layer.borderColor = kTAColor.c_49.CGColor;
        _rightBtn.layer.borderWidth = 0.5;
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightBtn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return nil;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

@end
