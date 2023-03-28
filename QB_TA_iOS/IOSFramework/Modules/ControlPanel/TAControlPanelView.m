//
//  TAControlPanelView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import "TAControlPanelView.h"
#import "TATopMenuView.h"
#import "TARightMenuView.h"
#import "TAAnnouncementView.h"
#import "TAMiniMapView.h"
#import "TAPersonalView.h"
#import "TAChatView.h"
#import "TASharScreenManager.h"
#import "TAMapListView.h"

@interface TAControlPanelView ()
@property (nonatomic, retain)UIImageView        *headImageView;

@property (nonatomic, retain)TATopMenuView      *topMenuView;
@property (nonatomic, retain)TARightMenuView    *rightMenuView;

@property (nonatomic, retain)UIButton           *putAwayBtn;
@property (nonatomic, assign)BOOL               isPutAway;

@property (nonatomic, retain)TAAnnouncementView *announcementView;
//@property (nonatomic, retain)TAMiniMapView      *miniMapView;
@property (nonatomic, retain)UIButton           *changeSpaceBtn;
@property (nonatomic, retain)UIButton           *chatBtn;

@end

@implementation TAControlPanelView

+ (NSString *)cmd{
    return @"controlPanel";
}

- (void)loadSubViews
{
    //加入默认房间
    [TASharScreenManager shareInstance];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TASharScreenManager shareInstance] enterRoom:332244];
    });
    
    self.userInteractionEnabled = YES;
    self.isPutAway = NO;
    
    [self addSubview:self.headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(80));
        make.top.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-60));
    }];
    
    [self addSubview:self.topMenuView];
    [_topMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([TATopMenuView viewSize]);
        make.centerY.mas_equalTo(_headImageView.mas_centerY);
        make.right.mas_equalTo(_headImageView.mas_left).mas_offset(kRelative(-30));
    }];

    [self addSubview:self.rightMenuView];
    [_rightMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([TARightMenuView viewSize]);
        make.centerX.mas_equalTo(_headImageView.mas_centerX);
        make.top.mas_equalTo(_headImageView.mas_bottom).mas_offset(kRelative(30));
    }];

    [self addSubview:self.putAwayBtn];
    [_putAwayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(60));
        make.centerX.mas_equalTo(_rightMenuView.mas_centerX);
        make.top.mas_equalTo(_rightMenuView.mas_bottom);
    }];
    
    
    [self addSubview:self.changeSpaceBtn];
    [_changeSpaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(80));
        make.left.mas_equalTo(kRelative(60));
        make.top.mas_equalTo(kRelative(30));
    }];
    
    [self addSubview:self.announcementView];
    [_announcementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(800));
        make.height.mas_equalTo(kRelative(80));
        make.left.mas_equalTo(_changeSpaceBtn.mas_right).offset(kRelative(30));
        make.centerY.mas_equalTo(_changeSpaceBtn.mas_centerY);
    }];
    
    [self addSubview:self.chatBtn];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(44));
        make.left.mas_equalTo(kRelative(80));
        make.bottom.mas_equalTo(kRelative(-30));
    }];
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}


#pragma mark - action
- (void)headClick
{
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = [TAPersonalView cmd];
    cmd.animated = YES;
    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:nil];
}

//切换场景
- (void)changeSpaceBtnClick
{
    //测试代码
    [[TAAnnouncementView shareInstance] addContent:@"模拟公告发送-官方公告：欢迎来到无尽之塔Amazing space无限拓展户外空间，您可在此空间举行。文字过长滚动显示"];
    
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = [TAMapListView cmd];
    cmd.animated = YES;
    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:nil];
}

- (void)chatBtnClick
{
    //测试代码
    [[TAAnnouncementView shareInstance] addContent:@"模拟公告发送：欢迎来到无尽之塔Amazing space无限拓展户外空间"];
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = [TAChatView cmd];
    cmd.animated = YES;
    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:nil];
}

//收起、展开
- (void)putAwayBtnClick
{
    self.isPutAway = !self.isPutAway;
    
    CGFloat rotation;
    CGFloat width;
    CGFloat height;
    CGFloat alpha;
    
    if (self.isPutAway) {
        rotation = M_PI;
        width = 0;
        height = 0;
        alpha = 0.2;
    }else{
        rotation = 0;
        width = [TATopMenuView viewSize].width;
        height = [TARightMenuView viewSize].height;
        alpha = 1;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        self.putAwayBtn.transform = CGAffineTransformMakeRotation(rotation);
        self.topMenuView.alpha = alpha;
        self.rightMenuView.alpha = alpha;
        
        [self.topMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [self.rightMenuView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        [self layoutIfNeeded];
        [self layoutSubviews];
    }];
}

#pragma mark - lazy load
-(TATopMenuView *)topMenuView{
    if (!_topMenuView){
        _topMenuView = [TATopMenuView new];
    }
    return _topMenuView;
}

-(TARightMenuView *)rightMenuView{
    if (!_rightMenuView){
        _rightMenuView = [TARightMenuView new];
    }
    return _rightMenuView;
}

-(UIButton           *)putAwayBtn
{
    if (!_putAwayBtn){
        _putAwayBtn = [UIButton new];
        [_putAwayBtn setImage:kBundleImage(@"arrow_up", @"ControlPanel") forState:UIControlStateNormal];
        [_putAwayBtn addTarget:self action:@selector(putAwayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _putAwayBtn;
}

-(UIImageView        *)headImageView
{
    if (!_headImageView){
        _headImageView = [UIImageView new];
        _headImageView.backgroundColor = [UIColor grayColor];
        _headImageView.layer.cornerRadius = kRelative(40);
        _headImageView.layer.masksToBounds = YES;
        _headImageView.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton new];
        [_headImageView addSubview:btn];
        [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _headImageView;
}

-(UIButton *)changeSpaceBtn
{
    if (!_changeSpaceBtn) {
        _changeSpaceBtn = [UIButton new];
        [_changeSpaceBtn setBackgroundImage:kBundleImage(@"frame_white_80", @"Commom") forState:UIControlStateNormal];
        [_changeSpaceBtn setImage:kBundleImage(@"icon_change_space", @"ControlPanel") forState:UIControlStateNormal];
        [_changeSpaceBtn addTarget:self action:@selector(changeSpaceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeSpaceBtn;
}

-(TAAnnouncementView *)announcementView
{
    if (!_announcementView) {
        _announcementView = [TAAnnouncementView shareInstance];
    }
    return _announcementView;
}

-(UIButton *)chatBtn
{
    if (!_chatBtn) {
        _chatBtn = [UIButton new];
        [_chatBtn setImage:kBundleImage(@"icon_chat", @"ControlPanel") forState:UIControlStateNormal];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}


@end
