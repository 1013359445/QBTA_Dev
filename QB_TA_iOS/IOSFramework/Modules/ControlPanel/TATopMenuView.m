//
//  TATopMenuView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TATopMenuView.h"
#import "TASettingView.h"
#import "TARoomManager.h"
#import "TAFileListView.h"
#import "TAMemberView.h"
#import "TAAlert.h"

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShareScreenStatusChange) name:IOSFrameworkShareScreenStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocalAudioStatusChange) name:IOSFrameworkLocalAudioStatusChangeNotification object:nil];

    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = YES;
        
    [self addSubview:self.frameImageView];
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(0);
    }];
    [self reLoadMenus];
}

- (void)reLoadMenus
{
    for (UIView *view in [self.frameImageView subviews]) {
        [view removeFromSuperview];
    }
    self.iconArray = [self iconArray];
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat width = self.iconArray.count * kRelative(80);
        make.width.mas_equalTo(width);
    }];
    [self.superview layoutIfNeeded];
    [self.superview layoutSubviews];
    [self.frameImageView mas_updateConstraints:^(MASConstraintMaker *make) {
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
            [[TARouter shareInstance] autoTaskWithCmdModel:[TASettingView cmd] responseBlock:nil];
        }
            break;
        case IconID_File:
        {
            [[TARouter shareInstance] autoTaskWithCmdModel:[TAFileListView cmd] responseBlock:nil];
        }
            break;
        case IconID_Member:
        {
            [[TARouter shareInstance] autoTaskWithCmdModel:[TAMemberView cmd] responseBlock:nil];
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
                    if ([TARoomManager shareInstance].isStartLocalAudio) {
                        [[TARoomManager shareInstance] stopLocalAudio];
                    }else{
                        [[TARoomManager shareInstance] startLocalAudio];
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
//            BOOL isUser = rand() % 2;
//            TAChatDataModel *dataModel = [TAChatDataModel new];
//            dataModel.nickname = isUser ? @"abc":@"系统消息";;
//            dataModel.phone = isUser ? @"15077833133":@"11100000000";
//            dataModel.datetime = @"20230515180101";
//            dataModel.content = isUser ? @"测试通知" : @"xxx进入了房间";
//            [[TADataCenter shareInstance] setValue:dataModel forKey:@"clientMessageEvent"];

//            if ([TARoomManager shareInstance].shareScreenStatus == ScreenStart) {
//                [TAAlert alertWithTitle:@"温馨提示" msg:@"确定结束分享屏幕吗？" actionText_1:@"取消" actionText_2:@"确定" action:^(NSInteger index) {
//                    if (index == 1){
//                        [[TARoomManager shareInstance] stopShareScreen];
//                    }
//                }];
//            }else{
//                [[TARoomManager shareInstance] startShareScreen];
//            }
        }
            break;
        default:
            break;
    }
}

- (void)onShareScreenStatusChange
{
    UIButton *btn = [self.frameImageView viewWithTag:IconID_Share_Screen];

    if ([TARoomManager shareInstance].shareScreenStatus == ScreenStart) {
        btn.selected = YES;
    }else if ([TARoomManager shareInstance].shareScreenStatus == ScreenStop) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
}

- (void)onLocalAudioStatusChange
{
    UIButton *btn = [self.frameImageView viewWithTag:IconID_Mike];
    if ([TARoomManager shareInstance].isStartLocalAudio == YES) {
        btn.selected = YES;
    }else{
        btn.selected = NO;
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
        
        BOOL visible = [[btnConfig objectForKey:@"visible"] boolValue];
        if (!visible) {
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
            @"visible":@"1",//是否显示
            @"isEnabled":@"1"//是否有效
        },
        @{
            @"icon_name":@"file",
            @"icon_id":@(IconID_File),
            @"normal":@"tmenu_file_b",
            @"highlight":@"tmenu_file_g",
            @"disable":@"tmenu_file_g",
            @"visible":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"member",
            @"icon_id":@(IconID_Member),
            @"normal":@"tmenu_member_b",
            @"highlight":@"",
            @"disable":@"",
            @"visible":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"share_screen",
            @"icon_id":@(IconID_Share_Screen),
            @"normal":@"tmenu_shar_b",
            @"selected":@"tmenu_shar_g",
            @"highlight":@"tmenu_shar_g",
            @"disable":@"tmenu_shar_g",
            @"visible":@"0",
            @"isEnabled":@"0"
        },
        @{
            @"icon_name":@"mike",
            @"icon_id":@(IconID_Mike),
            @"normal":@"tmenu_mike_disable_b",
            @"selected":@"tmenu_mike_enable_b",
            @"highlight":@"",//不需要
            @"disable":@"",//不需要
            @"visible":@"1",
            @"isEnabled":@"1"
        },
    ]];
    
    for (int i = 0; i < config.count; i++) {
        NSDictionary *btnConfig = config[i];
        int visible = [[btnConfig objectForKey:@"visible"] intValue];
        if (visible == 0) {
            [config removeObject:btnConfig];
            i--;
        }
    }
    return config;
}

@end
