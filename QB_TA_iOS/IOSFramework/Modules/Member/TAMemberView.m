//
//  TAMemberView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import "TAMemberView.h"
#import "TAMemberTableViewCell.h"
#import "TARoomManager.h"
#import "TALoginViewController.h"
#import "TAAlert.h"
#import "TAMemberModel.h"
#import "TASocketManager.h"

@interface TAMemberView () <UITableViewDelegate, UITableViewDataSource, TAMemberTableViewCellProtocol>
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

- (void)dealloc{
    if (self.isAdmin){
        [[TADataCenter shareInstance] removeObserver:self forKeyPath:@"isProhibition"];
    }else{
        [[TARoomManager shareInstance] removeObserver:self forKeyPath:@"isStartLocalAudio"];
    }
    [[TADataCenter shareInstance] removeObserver:self forKeyPath:@"membersList"];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;

        //注册监听
        if (self.isAdmin){
            [[TADataCenter shareInstance] addObserver:self forKeyPath:@"isProhibition" options:NSKeyValueObservingOptionNew context:nil];
        }else{
            [[TARoomManager shareInstance] addObserver:self forKeyPath:@"isStartLocalAudio" options:NSKeyValueObservingOptionNew context:nil];
        }
        [[TADataCenter shareInstance] addObserver:self forKeyPath:@"membersList" options:NSKeyValueObservingOptionNew context:nil];
        
        //获取成员列表
        TAClientRoomDataParmModel *parm = [TAClientRoomDataParmModel new];
        parm.range = @"room";
        [[TASocketManager shareInstance] SendClientMembers:parm];
    }
    return self;
}

//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([@"isProhibition" isEqualToString:keyPath]) {
        self.leftBtn.selected = self.isProhibition;
    }
    if ([@"isStartLocalAudio" isEqualToString:keyPath]) {
        self.leftBtn.selected = self.isStartLocalAudio;
    }
    if ([@"membersList" isEqualToString:keyPath]) {
        [self.tableView reloadData];
    }
}

- (void)loadSubViews
{
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(600));
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(600));
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
        make.width.mas_equalTo(kRelative(225));
        make.height.mas_equalTo(kRelative(60));
        make.left.mas_equalTo(kRelative(60));
        make.bottom.mas_equalTo(kRelative(-30));
    }];
    
    [self.contentView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.mas_equalTo(_leftBtn);
        make.right.mas_equalTo(kRelative(-60));
    }];
}

# pragma mark - action
- (void)leftBtnClick{
    if (self.isAdmin){
        NSString *msg = self.isProhibition ? @"所有成员以及新加入的成员可自由发言" : @"所有成员以及新加入的成员将被静音";
        NSString *actionText = self.isProhibition ? @"解除全体静音" : @"全体静音";
        [TAAlert alertWithTitle:@"" msg:msg actionText_1:@"取消" actionText_2:actionText action:^(NSInteger index) {
            if (index == 1)
            {
                TAClientMembersVocieParmModel *parm = [TAClientMembersVocieParmModel new];
                parm.range = @"room";
                parm.voice = self.isProhibition ? 1 : 0;
                [[TASocketManager shareInstance] SendClientMembersVoice:parm];
            }
        }];
    }else{
        if ([TARoomManager shareInstance].isStartLocalAudio) {
            [[TARoomManager shareInstance] stopLocalAudio];
        }else {
            [[TARoomManager shareInstance] startLocalAudio];
        }
    }
}

- (void)rightBtnClick
{
    [TAToast showTextDialog:kWindow msg:@"敬请期待"];
}

- (void)cellDidClickKickOut:(TAMemberModel *)data
{
    if (data.kick == 1){
        [TAAlert alertWithTitle:@"移出活动" msg:[NSString stringWithFormat:@"确定将%@移出活动吗？",data.nickname] actionText_1:@"取消" actionText_2:@"确定" action:^(NSInteger index) {
            if (index == 1)
            {
                TAClientMembersKickParmModel *parm = [TAClientMembersKickParmModel new];
                parm.kick = 1;
                parm.phone = data.phone;
                parm.range = @"room";
                [[TASocketManager shareInstance] SendClientMembersKick:parm];
            }
        }];
    }else{
        [TAToast showTextDialog:kWindow msg:@"主持人无法被移出"];
    }
}

- (void)cellDidClickMikeStatet:(TAMemberModel *)data{
    NSString *nickname = [TADataCenter shareInstance].userInfo.nickname;
    if ([data.nickname isEqualToString:nickname]) {
        //自己开闭麦
        if ([TARoomManager shareInstance].isStartLocalAudio) {
            [[TARoomManager shareInstance] stopLocalAudio];
        }else {
            [[TARoomManager shareInstance] startLocalAudio];
        }
    }else{
        //控制别人开闭麦
        if (!self.isAdmin || data.isAdmin){
            [TAToast showTextDialog:kWindow msg:@"您没有权限对TA静音"];
            return;
        }
        if (data.voice == 0){
//            [TAToast showTextDialog:kWindow msg:[NSString stringWithFormat:@"成员%@已被静音",data.nickname]];
//            return;
            [TAAlert alertWithTitle:@"" msg:[NSString stringWithFormat:@"确定将%@解除静音吗？",data.nickname] actionText_1:@"取消" actionText_2:@"确定" action:^(NSInteger index) {
                if (index == 1)
                {
                    TAClientMembersVocieParmModel *parm = [TAClientMembersVocieParmModel new];
                    parm.voice = 1;
                    parm.phone = data.phone;
                    parm.range = @"room";
                    [[TASocketManager shareInstance] SendClientMembersVoice:parm];
                }
            }];
        }else{
            [TAAlert alertWithTitle:@"" msg:[NSString stringWithFormat:@"确定将%@静音吗？",data.nickname] actionText_1:@"取消" actionText_2:@"确定" action:^(NSInteger index) {
                if (index == 1)
                {
                    TAClientMembersVocieParmModel *parm = [TAClientMembersVocieParmModel new];
                    parm.voice = 0;
                    parm.phone = data.phone;
                    parm.range = @"room";
                    [[TASocketManager shareInstance] SendClientMembersVoice:parm];
                }
            }];
        }
    }
}

# pragma mark - UITableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *TAMemberTableViewCellIdIdentifier = @"TAMemberTableViewCellIdIdentifier";
    TAMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TAMemberTableViewCellIdIdentifier];
    if (cell == nil) {
        cell = [[TAMemberTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TAMemberTableViewCellIdIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    TAMemberModel *data = [TADataCenter shareInstance].membersList[indexPath.row];
    cell.data = data;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [TADataCenter shareInstance].membersList.count;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld人",count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kRelative(90);
}

# pragma mark - getter
- (BOOL)isAdmin
{
    return [TADataCenter shareInstance].userInfo.admin;
}
- (BOOL)isStartLocalAudio
{
    return [TARoomManager shareInstance].isStartLocalAudio;
}
- (BOOL)isProhibition
{
    return [TADataCenter shareInstance].isProhibition;
}
- (UIView     *)contentView
{
    if (!_contentView){
        _contentView = [UIView new];
        _contentView.backgroundColor = kTAColor.c_F0;
        _contentView.userInteractionEnabled = YES;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton    *)leftBtn
{
    if (!_leftBtn){
        _leftBtn = [UIButton new];
        _leftBtn.layer.borderColor = kTAColor.c_49.CGColor;
        _leftBtn.layer.borderWidth = 0.5;
        _leftBtn.layer.cornerRadius = kRelative(30);
        _leftBtn.layer.masksToBounds = YES;
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_leftBtn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_leftBtn jk_setBackgroundColor:kTAColor.c_F0 forState:UIControlStateNormal];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_leftBtn jk_setBackgroundColor:kTAColor.c_49 forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.isAdmin){
            [_leftBtn setTitle:@"全体静音" forState:UIControlStateNormal];
            [_leftBtn setTitle:@"解除全体静音" forState:UIControlStateSelected];
        }else{
            [_leftBtn setTitle:@"解除静音" forState:UIControlStateNormal];
            [_leftBtn setTitle:@"静音" forState:UIControlStateSelected];
        }
        if (self.isAdmin) {
            _leftBtn.selected = self.isProhibition;
        }else {
            _leftBtn.selected = self.isStartLocalAudio;
        }
    }
    return _leftBtn;
}

- (UIButton    *)rightBtn
{
    if (!_rightBtn){
        _rightBtn = [UIButton new];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _rightBtn.layer.borderColor = kTAColor.c_49.CGColor;
        _rightBtn.layer.borderWidth = 0.5;
        _rightBtn.layer.cornerRadius = kRelative(30);
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_rightBtn jk_setBackgroundColor:kTAColor.c_F0 forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_rightBtn jk_setBackgroundColor:kTAColor.c_49 forState:UIControlStateHighlighted];
        [_rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitle:@"邀请" forState:UIControlStateNormal];
    }
    return _rightBtn;
}

# pragma mark - 显示与隐藏
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
            make.right.mas_equalTo(kRelative(600));
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([touches anyObject].view == self) {
        [self hideViewAnimated:YES];
    }
}

@end
