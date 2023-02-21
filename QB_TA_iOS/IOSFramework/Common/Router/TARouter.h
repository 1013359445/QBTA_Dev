//
//  TARouter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TAHeader.h"
#import "TAMacroDefinition.h"//宏定义

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^TaskFinishBlock) (id result);

@interface TARouter : NSObject
shareInstance_interface(TARouter)

- (void)taskToPageWithParm:(NSDictionary*)parm
              successBlock:(TaskFinishBlock)successed
               failedBlock:(TaskFinishBlock)failed;

- (void)taskToPageWithParm:(NSDictionary*)parm
              successBlock:(TaskFinishBlock)successed
               failedBlock:(TaskFinishBlock)failed
             responseBlock:(TaskFinishBlock)response;

//- (void)goBack;
//
//- (void)close;
@end

NS_ASSUME_NONNULL_END
