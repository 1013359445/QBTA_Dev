//
//  TAToast.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/3.
//

#import "TAToast.h"
#import "UIView+JKToast.h"
#import "TAMacroDefinition.h"

@implementation TAToast

+ (void)showTextDialog:(UIView *)view msg:(NSString *)msg
{
    msg = [NSString stringWithFormat:@"  %@  ",msg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kRelative(500), kRelative(70))];
    titleLabel.text = msg;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.9];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.layer.cornerRadius = kRelative(35);
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.minimumScaleFactor = 0.3;
    titleLabel.adjustsFontSizeToFitWidth = YES;

    [view jk_showToast:titleLabel duration:1.5 position:JKToastPositionBottom];
}

@end
