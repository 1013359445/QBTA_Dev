//
//  TAChatView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TAChatView.h"
#import "TADataCenter.h"
#import "IQKeyboardManager.h"
#import "NSString+Size.h"
#import "TASocketManager.h"
#import "TAChatDataModel.h"

@interface TAChatView () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
{
    float animatedDistance;
}
@property (nonatomic, retain)UIView         *bgView;
@property (nonatomic, retain)UIView         *msgHeaderView;
@property (nonatomic, retain)UITableView    *msgTableView;
@property (nonatomic, retain)UIView         *inputView;
@property (nonatomic, retain)UITextField    *inputTextField;
@property (nonatomic, retain)UIButton       *sendBtn;

@end

@implementation TAChatView

+ (CGSize)viewSize
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}
- (void)dealloc{
    [[TADataCenter shareInstance] removeObserver:self forKeyPath:@"membersList"];
    [[TADataCenter shareInstance] removeObserver:self forKeyPath:@"chatMessages"];
    [TADataCenter shareInstance].isChatViewVisible = NO;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;

        //注册监听
        [[TADataCenter shareInstance] addObserver:self forKeyPath:@"membersList" options:NSKeyValueObservingOptionNew context:nil];
        [[TADataCenter shareInstance] addObserver:self forKeyPath:@"chatMessages" options:NSKeyValueObservingOptionNew context:nil];
        
        [TADataCenter shareInstance].isChatViewVisible = YES;
    }
    return self;
}

//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([@"membersList" isEqualToString:keyPath]) {
        [self chatPeopleWhoSpeakChange];
    }else{
        [self.msgTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.msgTableView.contentSize.height > self.msgTableView.bounds.size.height) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[TADataCenter shareInstance].chatMessages.count-1 inSection:0];
                [self.msgTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
        });
    }
}

+ (TACmdModel *)cmd{
    TACmdModel *cmdModel = [TACmdModel new];
    cmdModel.cmd = @"chat";
    cmdModel.animated = YES;
    return cmdModel;
}

- (void)loadSubViews
{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self addSubview:self.msgTableView];
    [self.msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(120));
        make.top.mas_equalTo(kRelative(120));
        make.bottom.mas_equalTo(kRelative(-120));
        make.width.mas_equalTo(kRelative(420));
    }];
    
    [self addSubview:self.inputView];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(130));
        make.right.mas_equalTo(kRelative(-130));
        make.height.mas_equalTo(kRelative(70));
        make.bottom.mas_equalTo(kRelative(-30));
    }];
    
    [self.inputView addSubview:self.inputTextField];
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(20));
        make.right.mas_equalTo(kRelative(-80));
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.inputView addSubview:self.sendBtn];
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(70));
        make.top.mas_equalTo(kRelative(5));
        make.right.mas_equalTo(kRelative(-5));
        make.bottom.mas_equalTo(kRelative(-5));
    }];
    
    [self chatPeopleWhoSpeakChange];
    
    //获取消息列表
    [[TASocketManager shareInstance] GetHistoricalMessages];
    
    if (![TADataCenter shareInstance].membersList){
        //获取成员列表
        TAClientRoomDataParmModel *parm = [TAClientRoomDataParmModel new];
        parm.range = @"room";
        [[TASocketManager shareInstance] SendClientMembers:parm];
    }
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == _bgView) {
        if ([_inputTextField isFirstResponder]) {
            [self.inputTextField resignFirstResponder];
        }else{
            [self hideViewAnimated:YES];
        }
    }
}

- (void)chatPeopleWhoSpeakChange
{
    UILabel *titleLabel = [self.msgHeaderView viewWithTag:1991];
    NSArray *array = [TADataCenter shareInstance].microphoneUserList;
    NSString *name = @"";
    if (array.count == 0) {
        self.msgTableView.tableHeaderView = nil;
        return;
    }else if (array.count == 1){
        TAMemberModel *model = array[0];
        name = model.nickname;
    }else if (array.count == 2){
        TAMemberModel *model_0 = array[0];
        TAMemberModel *model_1 = array[1];
        name = [NSString stringWithFormat:@"%@和%@",model_0.nickname,model_1.nickname];
    }else{
        TAMemberModel *model_0 = array[0];
        TAMemberModel *model_1 = array[1];
        name = [NSString stringWithFormat:@"%@、%@等%ld名成员",model_0.nickname,model_1.nickname,array.count];
    }
    titleLabel.text = [NSString stringWithFormat:@"%@正在讲话",name];
    self.msgTableView.tableHeaderView = self.msgHeaderView;
}

- (void)sendBtnClick:(UIButton *)sender
{
    NSString *msg = self.inputTextField.text;
    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (msg.length == 0) {
        return;
    }
    //发送消息
    [[TASocketManager shareInstance] SendClientChatEvent:msg];
    self.inputTextField.text = @"";
    [self.inputTextField resignFirstResponder];
}

- (void)showView:(UIView *)superView animated:(BOOL)animated
{
    if (self.superview) {
        return;
    }else {
        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([[self class] viewSize].width);
            make.height.mas_equalTo([[self class] viewSize].height);
            make.centerX.mas_offset(0);
            make.centerY.mas_offset(0).mas_offset(SCREEN_HEIGHT);
        }];
        [self.superview layoutIfNeeded];
        [self.superview layoutSubviews];
    }
    if (!animated) {
        return;
    }
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.25 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //淡入淡出
                     animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0);
        }];
        [self.superview layoutIfNeeded];
        [self.superview layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished)
        {
            self.bgView.alpha = 1;
        }
    }];
}

- (void)hideViewAnimated:(BOOL)animated
{
    if (!animated) {
        [self removeFromSuperview];
        return;
    }
    kWeakSelf(self);
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.25 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //淡入淡出
                     animations:^{
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_offset(0).mas_offset(SCREEN_HEIGHT);
        }];
        [self.superview layoutIfNeeded];
        [self.superview layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished)
        {
            [weakself removeFromSuperview];
        }
    }];
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect = [self convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self convertRect:self.bounds fromView:self];

    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;

    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }

    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }

    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-self->animatedDistance);
        }];
        [self layoutIfNeeded];
        [self layoutSubviews];
    } completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.frame;
    viewFrame.origin.y += animatedDistance;

    [UIView animateWithDuration:KEYBOARD_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(kRelative(-30));
        }];
        [self layoutIfNeeded];
        [self layoutSubviews];
    } completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendBtnClick:nil];
    return YES;
}

-(UIView *)bgView
{
    if (!_bgView){
        _bgView = [UIView new];
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        NSMutableArray *colors = [NSMutableArray arrayWithObjects:
                                  (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor,
                                  (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor,
                                  (id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,nil
                                  ];
        CAGradientLayer *gradLayer = [CAGradientLayer layer];
        [gradLayer setColors:colors];
        //渐变起止点，point表示向量
        [gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
        [gradLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
        [gradLayer setFrame:frame];
        [_bgView.layer addSublayer:gradLayer];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

-(UIView *)msgHeaderView
{
    if (!_msgHeaderView){
        _msgHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kRelative(420), kRelative(70))];
        _msgHeaderView.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        view.layer.cornerRadius = kRelative(16);
        view.layer.masksToBounds = YES;
        
        UIImageView *image = [UIImageView new];
        image.image = kBundleImage(@"chat_speaking", @"Chat");

        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.tag = 1991;
        titleLabel.numberOfLines = 1;

        [_msgHeaderView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kRelative(10));
            make.width.mas_equalTo(kRelative(400));
            make.bottom.mas_equalTo(0);
        }];
        
        [view addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(8));
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(kRelative(44));
        }];

        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(image.mas_right).mas_offset(kRelative(10));
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(kRelative(-15));
        }];
    }
    return _msgHeaderView;
}

-(UITableView *)msgTableView
{
    if (!_msgTableView){
        _msgTableView = [UITableView new];
        _msgTableView.delegate = self;
        _msgTableView.dataSource = self;
        _msgTableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        _msgTableView.layer.cornerRadius = kRelative(16);
        _msgTableView.layer.masksToBounds = YES;
        _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _msgTableView;
}

-(UIView *)inputView
{
    if (!_inputView){
        _inputView = [UIView new];
        _inputView.backgroundColor = [UIColor whiteColor];
        _inputView.layer.cornerRadius = kRelative(35);
        _inputView.layer.masksToBounds = YES;
        _inputView.userInteractionEnabled = YES;
    }
    return _inputView;
}

-(UITextField *)inputTextField
{
    if (!_inputTextField){
        _inputTextField = [UITextField new];
        _inputTextField.delegate = self;
        _inputTextField.returnKeyType = UIReturnKeySend;
        _inputTextField.placeholder = @"说点啥~";
        _inputTextField.textColor = kTAColor.c_32;
        _inputTextField.font = [UIFont systemFontOfSize:12];
    }
    return _inputTextField;
}

-(UIButton *)sendBtn
{
    if (!_sendBtn){
        _sendBtn = [UIButton new];
        [_sendBtn setImage:kBundleImage(@"chat_send_btn_b", @"Chat") forState:UIControlStateNormal];
        [_sendBtn setImage:kBundleImage(@"chat_send_btn_g", @"Chat") forState:UIControlStateDisabled];
        [_sendBtn addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *TAChatViewCellIdIdentifier = @"TAChatViewCellIdIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TAChatViewCellIdIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: TAChatViewCellIdIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        view.layer.cornerRadius = kRelative(16);
        view.layer.masksToBounds = YES;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.textColor = [UIColor yellowColor];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.tag = 999;
        titleLabel.numberOfLines = 0;

        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kRelative(10));
            make.width.mas_equalTo(kRelative(400));
            make.bottom.mas_equalTo(0);
        }];

        [view addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(kRelative(15));
            make.right.bottom.mas_equalTo(kRelative(-15));
        }];
    }
    UILabel *titleLabel = [cell.contentView viewWithTag:999];
    titleLabel.textColor = [UIColor yellowColor];
    TAChatDataModel *chatData = [TADataCenter shareInstance].chatMessages[indexPath.row];
    if (!chatData.nickname){
        chatData.nickname = @"神秘人";
    }
    NSString *text = [NSString stringWithFormat:@"%@:%@",chatData.nickname,chatData.content];
    NSMutableAttributedString *mAttString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:chatData.content];
    [mAttString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    titleLabel.attributedText = mAttString;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return [TADataCenter shareInstance].chatMessages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TAChatDataModel *chatData = [TADataCenter shareInstance].chatMessages[indexPath.row];
    if (!chatData.nickname){
        chatData.nickname = @"神秘人";
    }
    NSString *string = [NSString stringWithFormat:@"%@:%@",chatData.nickname,chatData.content];
    CGFloat singleHeight = [@"单行高度" heightWithLabelFont:[UIFont systemFontOfSize:11] withLabelWidth:kRelative(370)];
    CGFloat suggestedHeight = [string heightWithLabelFont:[UIFont systemFontOfSize:11] withLabelWidth:kRelative(370)];
    return kRelative(70) - singleHeight + suggestedHeight;
}
@end
