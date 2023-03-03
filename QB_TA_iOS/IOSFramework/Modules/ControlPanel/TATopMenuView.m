//
//  TATopMenuView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TATopMenuView.h"

int const IconID_Setting        = 1001;
int const IconID_File           = 1002;
int const IconID_Member         = 1003;
int const IconID_Mike           = 1004;
int const IconID_Large_Screen   = 1005;
int const IconID_Share_Screen   = 1006;

@interface TATopMenuView ()

@property (nonatomic, retain)UIImageView    *frameImageView;
@property (nonatomic, retain)NSArray        *iconArray;

@end

@implementation TATopMenuView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(500), kRelative(80));
}

- (void)loadSubViews
{
    self.backgroundColor = [UIColor colorWithRed:30 green:30 blue:220 alpha:0.2];

    self.iconArray = [self iconConfig];

    [self addSubview:self.frameImageView];
    [self.frameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(kRelative(80*self.iconArray.count));
    }];
    
    //添加icon
    UIButton *temp = nil;
    for (UIButton *icon in _iconArray) {
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
            
        }
            break;
        case IconID_Large_Screen:
        {
            
        }
            break;
        case IconID_Share_Screen:
        {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - lazy load
-(UIImageView*)frameImageView{
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
    NSArray *config = [self iconConfig];
    NSMutableArray *iconArray = [NSMutableArray array];

    //根据配置创建icon
    for (NSDictionary *btnConfig in config) {

        BOOL authority = [[btnConfig objectForKey:@"authority"] boolValue];
        if (!authority) {
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
                
        //加竖线
        if ([config indexOfObject:btnConfig] < config.count) {
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
    
    return iconArray;}

- (NSArray *)iconConfig
{
    return
    @[
        @{
            @"icon_name":@"setting",
            @"icon_id":@(IconID_Setting),
            @"normal":@"tmenu_setting_b",//常规
            @"highlight":@"tmenu_setting_g",//按下
            @"disable":@"tmenu_setting_g",//无效
            @"authority":@"1",//权限-显示隐藏
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
            @"icon_name":@"mike",
            @"icon_id":@(IconID_Mike),
            @"normal":@"tmenu_mike_disable_b",
            @"selected":@"tmenu_mike_enable_b",
            @"highlight":@"",//不需要
            @"disable":@"",//不需要
            @"authority":@"1",
            @"isEnabled":@"1"
        },
        @{
            @"icon_name":@"large_screen",
            @"icon_id":@(IconID_Large_Screen),
            @"normal":@"tmenu_large_g",//缺
            @"highlight":@"tmenu_large_g",
            @"disable":@"tmenu_large_g",
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
        }
    ];
}

@end
