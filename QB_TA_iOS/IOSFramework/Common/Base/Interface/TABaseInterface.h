//
//  TABaseInterface.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import <Foundation/Foundation.h>
#import "MacroDefinition.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "TABaseDataModel.h"
#import "NSObject+MJKeyValue.h"

NS_ASSUME_NONNULL_BEGIN

#define DOMAIN_URL @"http://vmeeting-dev.newmin.cn"

typedef void (^TAFinishedBlock)(TABaseDataModel *dataModel, NSDictionary *response);
typedef void (^TAFailedBlock)(NSDictionary *response);

@interface TABaseInterface : NSObject <ASIHTTPRequestDelegate>
@property (nonatomic, retain)ASIFormDataRequest *   formRequest;
@property (nonatomic, copy)TAFinishedBlock          finishedBlock;
@property (nonatomic, copy)TAFailedBlock            failedBlock;

@property (nonatomic, retain)Class                  dataModelClass;

@end

NS_ASSUME_NONNULL_END
