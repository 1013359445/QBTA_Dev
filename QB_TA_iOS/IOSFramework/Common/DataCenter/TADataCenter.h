//
//  TADataCenter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import <Foundation/Foundation.h>
#import "TAUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface TADataCenter : NSObject

@property (nonatomic, retain)TAUserInfo *userInfo;

@property (nonatomic, copy)NSString *cookie;
@property (nonatomic, copy)NSString *token;

//本地信息
@property (nonatomic, copy)NSString *autoLogon;//自动登录？
@property (nonatomic, copy)NSString *isAgreeAgreement;

@end

NS_ASSUME_NONNULL_END
