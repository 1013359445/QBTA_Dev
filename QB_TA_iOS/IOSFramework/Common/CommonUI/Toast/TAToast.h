//
//  TAToast.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/3.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TAToast : NSObject

+ (void)showTextDialog:(UIView *)view msg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
