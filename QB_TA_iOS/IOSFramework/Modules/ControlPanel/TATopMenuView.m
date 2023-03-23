//
//  TATopMenuView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TATopMenuView.h"
#import "TASettingView.h"
#import "TAVoiceChat.h"

int const IconID_Setting        = 1001;
int const IconID_File           = 1002;
int const IconID_Member         = 1003;
int const IconID_Mike           = 1004;
int const IconID_Share_Screen   = 1006;


@interface TATopMenuView ()

@property (nonatomic, retain)UIImageView    *frameImageView;
@property (nonatomic, retain)NSArray        *iconArray;

@end

@implementation TATopMenuView

+ (CGSize)viewSize
{
    CGFloat width = [TATopMenuView iconConfig].count * kRelative(80);
    return CGSizeMake(width, kRelative(80));
}

- (void)loadSubViews
{    
    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = YES;
    
    self.iconArray = [self iconArray];
    
    [self addSubview:self.frameImageView];
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(80*self.iconArray.count));
    }];
    
    //添加icon
    UIButton *temp = nil;
    for (UIButton *icon in self.iconArray) {
        [self.frameImageView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.width.height.mas_equalTo(kRelative(50));
            if (temp) {
                make.right.mas_equalTo(temp.mas_left).mas_offset(kRelative(-30));
            }else{
                make.right.mas_equalTo(kRelative(-15));
            }
        }];
        temp = icon;
    }
}

#pragma mark - icon点击
- (void)iconDidClick:(UIButton *)sender
{
    switch (sender.tag) {
        case IconID_Setting:
        {
            TACmdModel *cmd = [TACmdModel new];
            cmd.cmd = [TASettingView cmd];
            cmd.animated = YES;
            [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:nil];
        }
            break;
        case IconID_File:
        {
            
        }
            break;
        case IconID_Member:
        {
            
        }
            break;
        case IconID_Mike:
        {
            
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
            switch (authStatus) {
                case AVAuthorizationStatusNotDetermined:{
                    //没有询问是否开启麦克风
                    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {}];
                }   break;
                case AVAuthorizationStatusRestricted:
                    //未授权，家长限制
                    [TAToast showTextDialog:kWindow msg:@"家长限制，App无法访问麦克风"];
                    break;
                case AVAuthorizationStatusDenied:{
                    //玩家未授权
                    [TAToast showTextDialog:kWindow msg:@"App无法访问麦克风，请到设置中授权后才能使用语音功能"];
                }   break;
                case AVAuthorizationStatusAuthorized:{
                    //玩家已授权
                    [sender setSelected:!sender.isSelected];
                    if ([TAVoiceChat shareInstance].isStartLocalAudio) {
                        [[TAVoiceChat shareInstance] stopLocalAudio];
                    }else{
                        [[TAVoiceChat shareInstance] startLocalAudio];
                    }
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case IconID_Share_Screen:
        {
//            self.trtcCloud = [TRTCCloud sharedInstance];
//            // 将 denny 的主路画面切换到一个悬浮的小窗口中（假如该迷你小窗口为 miniFloatingView）
//            [self.trtcCloud updateRemoteView:miniFloatingView streamType:TRTCVideoStreamTypeBig forUser:@"denny"];
//            // 将远端用户 denny 的主路画面设置为填充模式，并开启左右镜像模式
//            TRTCRenderParams *param = [[TRTCRenderParams alloc] init];
//            param.fillMode     = TRTCVideoFillMode_Fill;
//            param.mirrorType   = TRTCVideoMirrorTypeDisable;
//            [self.trtcCloud setRemoteRenderParams:@"denny" streamType:TRTCVideoStreamTypeBig params:param];

        }
            break;
        default:
            break;
    }
}

#pragma mark - lazy load
- (UIImageView*)frameImageView{
    if (!_frameImageView){
        _frameImageView = [UIImageView new];
        //设置拉伸位置
        UIImage *handsomeImage = kBundleImage(@"frame_white_80", @"Commom");
        handsomeImage = [handsomeImage stretchableImageWithLeftCapWidth:handsomeImage.size.width / 2 topCapHeight:handsomeImage.size.width / 2];
        
        [_frameImageView setImage:handsomeImage];
        [_frameImageView setUserInteractionEnabled:YES];
    }
    return _frameImageView;
}

#pragma mark - 配置
- (NSArray *)iconArray
{
    NSArray *config = [TATopMenuView iconConfig];
    NSMutableArray *iconArray = [NSMutableArray array];
    
    //根据配置创建icon
    for (NSDictionary *btnConfig in config) {
        
        BOOL authority = [[btnConfig objectForKey:@"authority"] boolValue];
        if (!authority) {
            continue;
        }
        
        UIButton *icon = [[UIButton alloc] init];
        
        NSString *n = [btnConfig objectForKey:@"normal"];
        NSString *h = [btnConfig objectForKey:@"highlight"];
        NSString *d = [btnConfig objectForKey:@"disable"];
        NSString *s = [btnConfig objectForKey:@"selected"];
        if (n) {
            [icon setImage:kBundleImage(n, @"ControlPanel") forState:UIControlStateNormal];
        }
        if (h) {
            [icon setImage:kBundleImage(h, @"ControlPanel") forState:UIControlStateHighlighted];
        }
        if (d) {
            [icon setImage:kBundleImage(d, @"ControlPanel") forState:UIControlStateDisabled];
        }
        if (s) {
            [icon setImage:kBundleImage(s, @"ControlPanel") forState:UIControlStateSelected];
        }
        
        BOOL isEnabled = [[btnConfig objectForKey:@"isEnabled"] boolValue];
        [icon setEnabled:isEnabled];
        
        NSString *icon_id = [btnConfig objectForKey:@"icon_id"];
        [icon setTag:icon_id.integerValue];
        
        [icon addTarget:self action:@selector(iconDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //加竖线
        if ([config indexOfObject:btnConfig] < config.count - 1) {
            UIView *line = [UIView new];
            line.backgroundColor = [UIColor whiteColor];
            [icon addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kRelative(1));
                make.height.mas_equalTo(kRelative(30));
                make.left.mas_offset(kRelative(-15.5));
                make.centerY.mas_equalTo(0);
            }];
        }
        
        [iconArray addObject:icon];
    }
    
    return iconArray;
}

+ (NSArray *)iconConfig
{
    NSMutableArray *config = [NSMutableArray arrayWithArray:
                              @[
        @{
            @"icon_name":@"setting",
            @"icon_id":@(IconID_Setting),
            @"normal":@"tmenu_setting_b",//常规
            @"highlight":@"tmenu_setting_g",//按下
            @"disable":@"tmenu_setting_g",//无效
            @"authority":@"1",//权限-1：普通权限 0：管理员权限
            @"isEnabled":@"1"//是否有效
        },
        @{
            @"icon_name":@"file",
            @"icon_id":@(IconID_File),
            @"normal":@"tmenu_file_b",
            @"highlight":@"tmenu_file_g",
            @"disable":@"tmenu_file_g",
            @"authority":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"member",
            @"icon_id":@(IconID_Member),
            @"normal":@"tmenu_member_b",
            @"highlight":@"",//缺
            @"disable":@"",
            @"authority":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"share_screen",
            @"icon_id":@(IconID_Share_Screen),
            @"normal":@"tmenu_shar_b",
            @"highlight":@"tmenu_shar_g",
            @"disable":@"tmenu_shar_g",
            @"authority":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"mike",
            @"icon_id":@(IconID_Mike),
            @"normal":@"tmenu_mike_disable_b",
            @"selected":@"tmenu_mike_enable_b",
            @"highlight":@"",//不需要
            @"disable":@"",//不需要
            @"authority":@"1",
            @"isEnabled":@"1"
        },
    ]];
    
    //伪代码
    if(@"如果不是管理员"){
        for (int i = 0; i < config.count; i++) {
            NSDictionary *btnConfig = config[i];
            int authority = [[btnConfig objectForKey:@"authority"] intValue];
            if (authority == 0) {
                [config removeObject:btnConfig];
                i--;
            }
        }
    }
    return config;
}

@end
