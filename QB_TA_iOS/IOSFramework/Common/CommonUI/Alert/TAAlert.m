//
//  TAAlert.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import "TAAlert.h"
#import "TAMacroDefinition.h"
#import "TACommonColor.h"
#import "UIButton+JKBlock.h"

@implementation TAAlert

+ (UIAlertController *)inputAlertWithTitle:(NSString *)title
                               placeholder:(NSString *)placeholder
                              actionText_1:(NSString *)actionText_1
                              actionText_2:(NSString *)actionText_2
                                    action:(void (^)(NSInteger index))block
{
    return nil;
}

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                         actionText_1:(NSString *)actionText_1
                         actionText_2:(NSString *)actionText_2
                               action:(void (^)(NSInteger index))block
{
    if (!title.length && msg.length) {
        title = msg;
        msg = @"";
    }
    if (!actionText_1.length && !actionText_2.length) {
        actionText_1 = @"OK";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (actionText_1){
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:actionText_1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(0);
        }];
        // 设置按钮背景图片
        UIImage *accessoryImage = [[UIImage imageNamed:@"selectRDImag.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        [cancelAction setValue:accessoryImage forKey:@"image"];

        [alert addAction:cancelAction];
    }
    if (actionText_2){
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:actionText_2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            block(1);
        }];
        [alert addAction:sureAction];
    }

    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange range = [title rangeOfString:title];
    [titleText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:range];
    [titleText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    [alert setValue:titleText forKey:@"attributedTitle"];
    // 使用富文本来改变alert的message字体大小和颜色
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:msg];
    range = [msg rangeOfString:msg];
    [messageText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
    [messageText addAttribute:NSForegroundColorAttributeName value:kTAColor.c_49 range:range];
    [alert setValue:messageText forKey:@"attributedMessage"];

    [[CommInterface shareInstance].iOSViewController presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

@end
