//
//  TACaptchaParmModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/14.
//

#import "TABaseParmModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TACaptchaParmModel : TABaseParmModel
@property (nonatomic, copy)NSString*    phone;
@property (nonatomic, copy)NSString*    type;//短信模式；0:注册；1:修改密码；2:登录
@end

NS_ASSUME_NONNULL_END
