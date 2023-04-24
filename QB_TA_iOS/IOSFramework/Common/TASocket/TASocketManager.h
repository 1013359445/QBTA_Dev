//
//  TASocketManager.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/11.
//

#import <Foundation/Foundation.h>
#import "TADataCenter.h"
#import "TABaseParmModel.h"
#import "VPSocketIOClient.h"

NS_ASSUME_NONNULL_BEGIN

//请求参数
@interface TAClientRoomDataParmModel : TABaseParmModel
@property (nonatomic, copy)NSString *range;//请求范围【room：房间】
@property (nonatomic, assign)int roomNum;//房间编号
@end

//发送消息
@interface TAClientChatMessageParmModel : TAClientRoomDataParmModel
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *phone;
@end

@interface TAClientMembersVocieParmModel : TAClientRoomDataParmModel
@property (nonatomic, assign)int voice;//语⾔标示【0：主持⼈禁⻨、1：禁⻨、2：开⻨】
@property (nonatomic, copy)NSString *phone;//被禁⾔⼈⼿机号
@end

@interface TAClientMembersKickParmModel : TAClientRoomDataParmModel
@property (nonatomic, assign)int kick;//踢⼈标识【0：不可以移除（主持⼈）、1：可以移除（成员）】
@property (nonatomic, copy)NSString *phone;//被禁⾔⼈⼿机号
@end

@interface TAClientMembersParmModel : TABaseParmModel
@property (nonatomic, copy)NSString *type;
@property (nonatomic, retain)TAClientRoomDataParmModel *data;
@end


@interface TASocketManager : NSObject
shareInstance_interface(TASocketManager)
@property (nonatomic, retain, nullable)VPSocketIOClient *socket;

- (void)socketConnect;

//获取成员列表
- (void)SendClientMemberList;
//全体禁⻨\解除禁⻨\禁⻨某⼈\解禁某⼈\申请解禁\同意解禁\否定解禁\⾃⼰禁麦\⾃⼰开⻨
- (void)SendClientMembersVoice:(TAClientMembersVocieParmModel *)data;
//踢出某人
- (void)SendClientMembersKick:(TAClientMembersKickParmModel *)data;

//获取历史消息
- (void)GetHistoricalMessages;
//发送消息
- (void)SendClientChatEvent:(NSString *)content;
- (void)SendClientChatEvent:(nullable NSString *)content phone:(nullable NSString *)phone;

@end

NS_ASSUME_NONNULL_END
