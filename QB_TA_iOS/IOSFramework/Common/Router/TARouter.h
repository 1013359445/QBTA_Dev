//
//  TARouter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TAMacroDefinition.h"
#import <UIKit/UIKit.h>
#import "TACmdModel.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TaskFinishBlock) (id result);

@interface TARouter : NSObject
shareInstance_interface(TARouter)

- (void)autoTaskWithCmdModel:(TACmdModel*)cmdModel responseBlock:(nullable TaskFinishBlock)response;

- (void)close;//关闭所有iOS视图

- (UIViewController *)getCurrentVC;
@end

NS_ASSUME_NONNULL_END
