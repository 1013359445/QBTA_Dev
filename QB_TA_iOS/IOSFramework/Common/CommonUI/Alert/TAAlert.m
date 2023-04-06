//
//  TAAlert.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import "TAAlert.h"
#import "CommInterface.h"
#import "TAMacroDefinition.h"

@implementation TAAlert

+ (UIAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg sure:(NSString *)sure
{
    return [self alertWithTitle:title msg:msg actionTitle_1:sure action_1:nil  actionTitle_2:nil action_2:nil];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg
           actionTitle:(NSString *)actionTitle action:(void (^)(UIAlertAction *action))action
{
    return [self alertWithTitle:title msg:msg actionTitle_1:actionTitle action_1:action actionTitle_2:nil action_2:nil];
}

+ (UIAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg
                        actionTitle_1:(NSString *)actionTitle_1
                             action_1:(void (^__nullable)(UIAlertAction *action))action_1
                        actionTitle_2:(NSString * __nullable)actionTitle_2
                             action_2:(void (^__nullable)(UIAlertAction *action))action_2;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (!actionTitle_1) {
        actionTitle_1 = @"OK";
    }
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:actionTitle_1 style:UIAlertActionStyleDefault handler:action_1];
    [alert addAction:noAction];

    if (actionTitle_2){
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:actionTitle_2 style:UIAlertActionStyleDefault handler:action_2];
        [alert addAction:sureAction];
    }

    [[CommInterface shareInstance].iOSViewController presentViewController:alert animated:YES completion:nil];
    
    return alert;
}

@end
