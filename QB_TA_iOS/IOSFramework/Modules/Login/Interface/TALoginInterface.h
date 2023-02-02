//
//  TALoginInterface.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import <Foundation/Foundation.h>
#import "TABaseInterface.h"
#import "TABaseParmModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TALoginInterface : TABaseInterface
shareInstance_interface(TALoginInterface)

- (void)loginWithParmModel:(TABaseParmModel*)parmModel
   dataModelClass:(Class)dataModelClass
    finishedBlock:(TAFinishedBlock)finishedBlock
      failedBlock:(TAFailedBlock) failedBlock;

@end

NS_ASSUME_NONNULL_END
