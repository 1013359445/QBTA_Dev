//
//  MBProgressHUD+TATips.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/13.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (TATips)
+ (void)showTextDialog:(UIView *)view msg:(NSString *)msg;
@end

NS_ASSUME_NONNULL_END
