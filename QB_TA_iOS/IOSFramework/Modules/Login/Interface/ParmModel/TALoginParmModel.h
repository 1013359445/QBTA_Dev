//
//  TALoginParmModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TALoginParmModel : NSObject

@property (nonatomic, copy)NSString*    phone;

@property (nonatomic, copy)NSString*    password;//密码登录
@property (nonatomic, copy)NSString*    type;//发送验证码
@property (nonatomic, copy)NSString*    captcha;//验证码登录

@end

NS_ASSUME_NONNULL_END
