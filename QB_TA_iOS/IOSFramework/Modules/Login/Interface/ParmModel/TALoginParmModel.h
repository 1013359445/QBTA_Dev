//
//  TALoginParmModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import <Foundation/Foundation.h>
#import "TABaseParmModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TALoginParmModel : TABaseParmModel

@property (nonatomic, copy)NSString*    phone;

@property (nonatomic, copy)NSString*    password;//密码登录
@property (nonatomic, copy)NSString*    captcha;//验证码登录
@property (nonatomic, copy)NSString*    loginMode;//登录模式；0:密码登录；1:验证码登录；

@property (nonatomic, copy)NSString*    version;
@property (nonatomic, copy)NSString*    versionType;
@property (nonatomic, copy)NSString*    lang;
@property (nonatomic, copy)NSNumber*    clientType;

@end

NS_ASSUME_NONNULL_END
