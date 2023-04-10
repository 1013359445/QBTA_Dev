//
//  TAAlert.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAAlert : UIAlertController

+ (UIAlertController *)inputAlertWithTitle:(NSString *)title
                               placeholder:(NSString *)placeholder
                              actionText_1:(NSString *)actionText_1
                              actionText_2:(NSString *)actionText_2
                                    action:(void (^)(NSInteger index))block;

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                         actionText_1:(NSString *)actionText_1
                         actionText_2:(NSString *)actionText_2
                               action:(void (^)(NSInteger index))block;

@end

NS_ASSUME_NONNULL_END
