//
//  TARightMenuView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TARightMenuView.h"
#import "TARoomManager.h"
#import "TADisplayScreen.h"

int const IconID_Hi             = 1001;//hi
int const IconID_Emoji          = 1002;//表情
int const IconID_Wave           = 1003;//举手
int const IconID_Applause       = 1004;//鼓掌
int const IconID_Large_Screen   = 1005;//大屏
int const IconID_Confetti       = 1006;//喝彩

@interface TARightMenuView ()

@property (nonatomic, retain)NSArray        *iconArray;

@end

@implementation TARightMenuView

+ (CGSize)viewSize
{
    CGFloat height = [TARightMenuView iconConfig].count * kRelative(80);
    return CGSizeMake(kRelative(60), height);
}

- (void)loadSubViews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShareScreenStatusChange) name:IOSFrameworkShareScreenStatusChangeNotification object:nil];
    
    [self setUserInteractionEnabled:YES];
    self.clipsToBounds = YES;

    self.iconArray = [self iconArray];

    //添加icon
    UIButton *temp = nil;
    for (UIButton *icon in _iconArray) {
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(kRelative(60));
            if (temp) {
                make.top.mas_equalTo(temp.mas_bottom).mas_offset(kRelative(20));
            }else{
                make.top.mas_equalTo(0);
            }
        }];
        temp = icon;
    }
}

#pragma mark - icon点击
- (void)iconDidClick:(UIButton *)sender
{
    switch (sender.tag) {
        case IconID_Hi://hi
        {}break;
        case IconID_Emoji://表情
        {}break;
        case IconID_Wave://举手
        {}break;
        case IconID_Applause://鼓掌
        {}break;
        case IconID_Large_Screen://大屏
        {
            [[TARouter shareInstance] autoTaskWithCmdModel:[TADisplayScreen cmd] responseBlock:nil];
        }break;
        case IconID_Confetti://喝彩
        {}break;
        default:
            break;
    }
}

- (void)onShareScreenStatusChange
{
    UIButton *btn = [self viewWithTag:IconID_Large_Screen];

    if ([TARoomManager shareInstance].shareScreenStatus == ScreenStart) {
        [btn setEnabled:NO];
    }else if ([TARoomManager shareInstance].shareScreenStatus == ScreenStop) {
        [btn setEnabled:YES];
    }else{
        [btn setEnabled:YES];
    }
}

#pragma mark - 配置
- (NSArray *)iconArray
{
    NSArray *config = [TARightMenuView iconConfig];
    NSMutableArray *iconArray = [NSMutableArray array];

    //根据配置创建icon
    for (NSDictionary *btnConfig in config) {

        BOOL visible = [[btnConfig objectForKey:@"visible"] boolValue];
        if (!visible) {
            continue;
        }

        NSString *n = [btnConfig objectForKey:@"normal"];
        NSString *h = [btnConfig objectForKey:@"highlight"];
        NSString *d = [btnConfig objectForKey:@"disable"];
        NSString *s = [btnConfig objectForKey:@"selected"];
        NSString *icon_id = [btnConfig objectForKey:@"icon_id"];
        
        UIButton *icon = [[UIButton alloc] init];
        [icon setImage:kBundleImage(n, @"ControlPanel") forState:UIControlStateNormal];
        [icon setImage:kBundleImage(h, @"ControlPanel") forState:UIControlStateHighlighted];
        [icon setImage:kBundleImage(d, @"ControlPanel") forState:UIControlStateDisabled];
        [icon setImage:kBundleImage(s, @"ControlPanel") forState:UIControlStateSelected];
        
        [icon addTarget:self action:@selector(iconDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isEnabled = [[btnConfig objectForKey:@"isEnabled"] boolValue];
        [icon setEnabled:isEnabled];
        
        [icon setTag:icon_id.integerValue];
        
        [iconArray addObject:icon];
    }
    
    return iconArray;
}

+ (NSArray *)iconConfig
{
    NSMutableArray *config = [NSMutableArray arrayWithArray:
    @[
        @{
            @"icon_name":@"Hi",//Hi
            @"icon_id":@(IconID_Hi),
            @"normal":@"rmenu_hi_b",//常规
            @"highlight":@"rmenu_hi_g",//按下
            @"disable":@"rmenu_hi_b",//无效
            @"visible":@"1",//是否显示
            @"isEnabled":@"1"//是否有效
        },
        @{
            @"icon_name":@"Emoji",
            @"icon_id":@(IconID_Emoji),
            @"normal":@"rmenu_emoji_b",
            @"highlight":@"rmenu_emoji_g",
            @"disable":@"rmenu_emoji_g",
            @"visible":@"0",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"Wave",//举手
            @"icon_id":@(IconID_Wave),
            @"normal":@"rmenu_wave_b",
            @"highlight":@"rmenu_wave_g",
            @"disable":@"rmenu_wave_g",
            @"visible":@"0",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"Applause",//鼓掌
            @"icon_id":@(IconID_Applause),
            @"normal":@"rmenu_applause_b",
            @"highlight":@"rmenu_applause_g",
            @"disable":@"rmenu_applause_g",
            @"visible":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"Large_Screen",
            @"icon_id":@(IconID_Large_Screen),
            @"normal":@"rmenu_large",
            @"selected":@"rmenu_large",
            @"highlight":@"",//不需要
            @"disable":@"",//不需要
            @"visible":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"Confetti",//喝彩
            @"icon_id":@(IconID_Confetti),
            @"normal":@"rmenu_confetti_b",
            @"highlight":@"rmenu_confetti_g",
            @"disable":@"rmenu_confetti_g",
            @"visible":@"0",
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
