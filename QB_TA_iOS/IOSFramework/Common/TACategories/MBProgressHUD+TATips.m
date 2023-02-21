//
//  MBProgressHUD+Tips.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/13.
//

#import "MBProgressHUD+TATips.h"
#import "JKUIKit.h"
#import "TAMacroDefinition.h"
#import "Masonry.h"

@implementation MBProgressHUD (TATips)

+ (void)showTextDialog:(UIView *)view msg:(NSString *)msg
{
    msg = [NSString stringWithFormat:@"  %@  ",msg];
    //显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //下面的2行代码必须要写，如果不写就会导致指示器的背景永远都会有一层透明度为0.5的背景
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:0];
    hud.userInteractionEnabled = NO;
    //设置自定义样式的mode
    hud.mode = MBProgressHUDModeCustomView;
    CGRect rect = [msg boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    hud.minSize = CGSizeMake(rect.size.width+30, 35);
    hud.bezelView.layer.masksToBounds = NO;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = msg;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.9];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.layer.cornerRadius = kRelative(35);
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.minimumScaleFactor = 0.3;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [hud.bezelView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(view.bounds.size.height/2 - kRelative(60));
        make.width.mas_equalTo(kRelative(500));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    hud.margin = 20.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
}

@end
