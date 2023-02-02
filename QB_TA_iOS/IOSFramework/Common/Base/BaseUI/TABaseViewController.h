//
//  TABaseViewController.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import <UIKit/UIKit.h>

#import "JKUIKit.h"
#import "Masonry.h"
#import "MacroDefinition.h"
#import "TARouter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABaseViewController : UIViewController

@property (nonatomic, retain)NSDictionary *params;

@property (nonatomic, copy)TaskFinishBlock taskFinishBlock;

+ (NSString *)cmd;

@end

NS_ASSUME_NONNULL_END
