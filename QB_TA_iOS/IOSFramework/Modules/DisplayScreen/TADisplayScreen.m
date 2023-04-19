//
//  TADisplayScreen.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/17.
//

#import "TADisplayScreen.h"
#import "TARoomManager.h"

@interface TADisplayScreen ()

@property (nonatomic, retain)UIView     *remoteView;
@property (nonatomic, retain)UIButton   *closeBtn;
@property (nonatomic, retain)UIButton   *mikeState;

@end

@implementation TADisplayScreen

+ (TACmdModel *)cmd{
    TACmdModel *cmdModel = [TACmdModel new];
    cmdModel.cmd = @"displayScreen";
    cmdModel.animated = YES;
    return cmdModel;
}

+ (CGSize)viewSize
{
    CGFloat height = SCREEN_HEIGHT - kRelative(50);
    return CGSizeMake(height * (16.0/9.0), height);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;
        //注册监听
        [[TARoomManager shareInstance] addObserver:self forKeyPath:@"isStartLocalAudio" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc{
    [[TARoomManager shareInstance] removeObserver:self forKeyPath:@"isStartLocalAudio"];
}

//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    self.mikeState.selected = [TARoomManager shareInstance].isStartLocalAudio;
}

- (void)loadSubViews
{
    self.userInteractionEnabled = YES;

    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = kBundleImage(@"display_screen", @"Other");
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    bgImageView.clipsToBounds = YES;
    bgImageView.layer.cornerRadius = kRelative(35);

    [bgImageView addSubview:self.remoteView];
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo([TADisplayScreen viewSize].width);
        make.center.mas_equalTo(0);
    }];
        
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];
    
    [self addSubview:self.mikeState];
    [self.mikeState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(60));
        make.right.mas_equalTo(kRelative(30));
        make.centerY.mas_equalTo(0);
    }];

    [[TARoomManager shareInstance] seeUserVideoWithRemoteView:self.remoteView];
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

- (void)mikeStatetBtnClick
{
    //自己开闭麦
    if ([TARoomManager shareInstance].isStartLocalAudio) {
        [[TARoomManager shareInstance] stopLocalAudio];
    }else {
        [[TARoomManager shareInstance] startLocalAudio];
    }
}

#pragma mark - lazy load
-(UIView*)remoteView
{
    if(!_remoteView){
        _remoteView = [UIView new];
        _remoteView.userInteractionEnabled = YES;
    }
    return _remoteView;
}

-(UIButton       *)closeBtn
{
    if (!_closeBtn)
    {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton       *)mikeState{
    if (!_mikeState){
        _mikeState = [UIButton new];
        [_mikeState setImage:kBundleImage(@"tmenu_mike_disable_b", @"ControlPanel") forState:UIControlStateNormal];
        [_mikeState setImage:kBundleImage(@"tmenu_mike_enable_b", @"ControlPanel") forState:UIControlStateSelected];
        [_mikeState addTarget:self action:@selector(mikeStatetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _mikeState.backgroundColor = [UIColor whiteColor];
        _mikeState.clipsToBounds = YES;
        _mikeState.layer.cornerRadius = kRelative(30);
    }
    return _mikeState;
}

@end
