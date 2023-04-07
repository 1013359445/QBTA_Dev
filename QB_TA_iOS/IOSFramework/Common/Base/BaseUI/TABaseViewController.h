//
//  TABaseViewController.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import <UIKit/UIKit.h>

#import "TAHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABaseViewController : UIViewController

@property (nonatomic, retain)TACmdModel *cmdModel;

@property (nonatomic, copy)TaskFinishBlock taskFinishBlock;

+ (TACmdModel *)cmd;

- (void)goBack;
- (void)close;
@end

NS_ASSUME_NONNULL_END
