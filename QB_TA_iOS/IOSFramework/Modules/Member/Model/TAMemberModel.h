//
//  TAMemberModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/11.
//

#import "TABaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAMemberModel : TABaseDataModel

@property (nonatomic, assign)NSInteger pkid;//唯⼀标识
@property (nonatomic, copy)NSString *nickname;//昵称
@property (nonatomic, copy)NSString *phone;//⼿机号
@property (nonatomic, copy)NSString *roleName;//⻆⾊名称【主持⼈、成员】
@property (nonatomic, copy)NSString *entryTime;//声⾳状态【0：（全体禁⾔）主持⼈禁⻨、1：（解除禁⾔）禁⻨、2：开⻨】
@property (nonatomic, assign)int kick;//是否可以踢⼈【0：不可以踢（主持⼈）、1：可以踢（成员）】
@property (nonatomic, assign)int voice;//登录时间

@property (nonatomic, copy)NSString *headUrl;//头像

@end

NS_ASSUME_NONNULL_END
