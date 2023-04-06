//
//  TAAlert.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAlert : UIAlertController

+ (UIAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg sure:(NSString *)sure;

+ (UIAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg
           actionTitle:(NSString *)actionTitle action:(void (^__nullable)(UIAlertAction *action))action;

+ (UIAlertController *)alertWithTitle:(NSString *)title msg:(NSString *)msg
                        actionTitle_1:(NSString *)actionTitle_1
                             action_1:(void (^__nullable)(UIAlertAction *action))action_1
                        actionTitle_2:(NSString * __nullable)actionTitle_2
                             action_2:(void (^__nullable)(UIAlertAction *action))action_2;

@end

NS_ASSUME_NONNULL_END
