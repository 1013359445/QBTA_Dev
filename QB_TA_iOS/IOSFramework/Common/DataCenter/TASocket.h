//
//  TASocket.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/11.
//

#import <Foundation/Foundation.h>
#import "SIOSocket.h"
#import "TADataCenter.h"
#import "TABaseParmModel.h"

NS_ASSUME_NONNULL_BEGIN

//请求参数
@interface TAClientMembersDataParmModel : TABaseParmModel
@property (nonatomic, copy)NSString *range;//请求范围【room：房间】
@property (nonatomic, assign)int roomNum;//房间编号
@end

@interface TAClientMembersVocieParmModel : TAClientMembersDataParmModel
@property (nonatomic, assign)int voice;//语⾔标示【0：主持⼈禁⻨、1：禁⻨、2：开⻨】
@property (nonatomic, copy)NSString *phone;//被禁⾔⼈⼿机号
@end

@interface TAClientMembersKickParmModel : TAClientMembersDataParmModel
@property (nonatomic, assign)int kick;//踢⼈标识【0：不可以移除（主持⼈）、1：可以移除（成员）】
@property (nonatomic, copy)NSString *phone;//被禁⾔⼈⼿机号
@end

@interface TAClientMembersParmModel : TABaseParmModel
@property (nonatomic, copy)NSString *type;
@property (nonatomic, retain)TAClientMembersDataParmModel *data;
@end


@interface TASocket : NSObject
shareInstance_interface(TASocket)
@property (nonatomic, retain)SIOSocket *socket;

- (void)socketConnect;

//获取成员列表
- (void)SendClientMembers:(TAClientMembersDataParmModel *)data;
//全体禁⻨\解除禁⻨\禁⻨某⼈\解禁某⼈\申请解禁\同意解禁\否定解禁\⾃⼰禁麦\⾃⼰开⻨
- (void)SendClientMembersVoice:(TAClientMembersVocieParmModel *)data;
//踢出某人
- (void)SendClientMembersKick:(TAClientMembersKickParmModel *)data;

@end

NS_ASSUME_NONNULL_END
