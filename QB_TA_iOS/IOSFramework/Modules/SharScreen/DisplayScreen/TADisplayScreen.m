//
//  TADisplayScreen.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/17.
//

#import "TADisplayScreen.h"
#import "TASharScreenManager.h"

@interface TADisplayScreen ()

@property (nonatomic, retain)UIView     *remoteView;
@property (nonatomic, retain)UIButton   *closeBtn;

@end

@implementation TADisplayScreen

+ (NSString *)cmd{
    return @"displayScreen";
}

+ (CGSize)viewSize
{
    
    return CGSizeMake(SCREEN_HEIGHT * (16.0/9.0), SCREEN_HEIGHT);
}

- (void)loadSubViews
{
    self.layer.cornerRadius = kRelative(35);
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    [self showEffectView:YES];

    UIImageView *bgImageView = [UIImageView new];
    bgImageView.image = kBundleImage(@"display_screen", @"Other");
    [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self addSubview:self.remoteView];
    [self.remoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
        
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];
    
    [[TASharScreenManager shareInstance] seeUserVideoWithRemoteView:self.remoteView];
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
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

@end
