//
//  TARouter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TAHeader.h"
#import "TAMacroDefinition.h"//宏定义
#import "TACmdModel.h"

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TaskFinishBlock) (id result);

@interface TARouter : NSObject
shareInstance_interface(TARouter)

- (void)autoTaskWithCmdModel:(TACmdModel*)cmdModel responseBlock:(nullable TaskFinishBlock)response;

- (void)close;//关闭所有iOS视图

@end

NS_ASSUME_NONNULL_END
