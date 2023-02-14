//
//  TABaseViewController.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import <UIKit/UIKit.h>

#import "MacroDefinition.h"//宏定义

#import "JKUIKit.h"//UI分类
#import "MJExtension.h"//NS分类

#import "Masonry.h"//布局
#import "TARouter.h"//路由
#import "MBProgressHUD+TATips.h"//弹出

NS_ASSUME_NONNULL_BEGIN

@interface TABaseViewController : UIViewController

@property (nonatomic, retain)NSDictionary *params;

@property (nonatomic, copy)TaskFinishBlock taskFinishBlock;

+ (NSString *)cmd;
- (void)goBack;
@end

NS_ASSUME_NONNULL_END
