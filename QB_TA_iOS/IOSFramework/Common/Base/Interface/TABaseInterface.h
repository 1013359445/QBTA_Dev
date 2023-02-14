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
#import "TABaseParmModel.h"

NS_ASSUME_NONNULL_BEGIN

//默认域名
#define DOMAIN_URL @"vmeeting-dev.newmin.cn"

typedef void (^TASucceededBlock)(TABaseDataModel *dataModel, NSDictionary *response);
typedef void (^TAFailedBlock)(NSString *msg, NSDictionary *response);
typedef void (^TAFinishedBlock)(void);

@interface TABaseInterface : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, retain)ASIFormDataRequest *   formRequest;
@property (nonatomic, retain)ASIHTTPRequest *       httpRequest;

@property (nonatomic, copy)TAFinishedBlock          finishedBlock;
@property (nonatomic, copy)TAFailedBlock            failedBlock;
@property (nonatomic, copy)TASucceededBlock         succeededBlock;

@property (nonatomic, retain)Class                  dataModelClass;

-(void)requestWithParmModel:(TABaseParmModel*)parmModel
dataModelClass:(Class)dataModelClass
succeededBlock:(TASucceededBlock)succeededBlock
failedBlock:(TAFailedBlock) failedBlock
finishedBlock:(TAFinishedBlock)finishedBlock;

- (NSString *)link;//子类必须实现 link

- (NSString *)requestMethod;//子类实现请求方式，默认POST

- (NSString *)domain;//自定义域名

@end

NS_ASSUME_NONNULL_END
