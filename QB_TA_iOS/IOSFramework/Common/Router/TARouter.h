//
//  TARouter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import <Foundation/Foundation.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^TaskFinishBlock) (id result);

@interface TARouter : NSObject
shareInstance_interface(TARouter)

- (void)taskToPageWithParm:(NSDictionary*)parm
successBlock:(TaskFinishBlock)successed
failedBlock:(TaskFinishBlock)failed;

@end

NS_ASSUME_NONNULL_END
