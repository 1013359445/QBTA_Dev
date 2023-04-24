//
//  TASocketManager.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/11.
//

#import "TASocketManager.h"
#import "NSObject+MJKeyValue.h"
#import "TAToast.h"
#import "TAAlert.h"
#import "TARoomManager.h"
#import "TAMemberModel.h"
#import "TAChatDataModel.h"
#import "VPSocketLogger.h"

@implementation TAClientRoomDataParmModel
- (void)assignDefaultValue
{
    self.range = @"room";
    self.roomNum = [TADataCenter shareInstance].userInfo.roomNum;
}
@end

@implementation TAClientChatMessageParmModel
@end

@implementation TAClientMembersVocieParmModel
- (void)assignDefaultValue
{
    [super assignDefaultValue];
}
@end
@implementation TAClientMembersKickParmModel
- (void)assignDefaultValue
{
    [super assignDefaultValue];
}

@end
@implementation TAClientMembersParmModel
- (void)assignDefaultValue
{
    self.type = @"members";
}
@end

@interface TASocketManager ()
@property (nonatomic, assign)int connectTimes;//连接次数

@end
@implementation TASocketManager
shareInstance_implementation(TASocketManager);

- (void)socketConnect {
    if (self.socket){
        [self.socket disconnect];
        [self.socket removeAllHandlers];
        self.socket = nil;
    }
    self.connectTimes = 1;

    NSString *url = @"http://39.100.153.162:10246";
    TAUserInfo *userInfo = [TADataCenter shareInstance].userInfo;
    NSDictionary *connectParams = @{@"uid":@(userInfo.pkid).stringValue,
                                    @"room_num":@(userInfo.roomNum).stringValue,
                                    @"phone":userInfo.phone,
                                    @"nick_name":userInfo.nickname};
    
    VPSocketIOClient *socket = [[VPSocketIOClient alloc] init:[NSURL URLWithString:url]
                                                   withConfig:@{
                                                                @"connectParams":connectParams,
                                                                @"logger":[VPSocketLogger new]
                                                                }];
    [socket connect];
    self.socket = socket;
    
    kWeakSelf(self);
    //-----------------------------------监听--------------------------------
    //监听-服务器连接事件
    [socket on:kSocketEventConnect callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        weakself.connectTimes = 1;
        //取消之前的定时发送
        [NSObject cancelPreviousPerformRequestsWithTarget:weakself];
        //开始新的发送心跳-自动定时重复
        [weakself performSelector:@selector(HeartbeatSendServer) withObject:nil afterDelay:18];
        
        [weakself performSelector:@selector(firstLoadDataOnContented) withObject:nil afterDelay:1.0];
    }];
    [socket on:kSocketEventError callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        //取消之前的定时发送
        [NSObject cancelPreviousPerformRequestsWithTarget:weakself];
        //开始新的发送心跳-自动定时重复
        [weakself performSelector:@selector(reconnect) withObject:nil afterDelay:5 * weakself.connectTimes];
    }];
    [socket on:kSocketEventStatusChange callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        if (weakself.socket.status == VPSocketIOClientStatusDisconnected || [TADataCenter shareInstance].userInfo != nil){
            //取消之前的定时发送
            [NSObject cancelPreviousPerformRequestsWithTarget:weakself];
            //开始新的发送心跳-自动定时重复
            [weakself performSelector:@selector(reconnect) withObject:nil afterDelay:5 * weakself.connectTimes];
        }
    }];
    
//    //监听广播
//    [socket on: @"Broadcast" callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
//    }];
    
    //监听-成员列表
    [socket on: @"SendClientMembersList" callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        NSDictionary *data = [array firstObject];;
        if ([data isKindOfClass: [NSDictionary class]]){
            NSString *msg = data[@"msg"];
            int code = [data[@"code"] intValue];
            switch (code) {
                case 101:
                case 103:
                case 106:
                {
                    [[TADataCenter shareInstance] setValue:@(YES) forKey:@"isProhibition"];
                    [[TARoomManager shareInstance] stopLocalAudio];
                }
                    break;
                case 102:
                case 107:
                {
                    [[TADataCenter shareInstance] setValue:@(NO) forKey:@"isProhibition"];
                }
                    break;
                case 105:
                {
                    [[TADataCenter shareInstance] setValue:@(NO) forKey:@"isProhibition"];
                    [[TARoomManager shareInstance] startLocalAudio];
                }
                    break;
                    
                default:
                    break;
            }
            if (code != 200){
                [TAToast showTextDialog:kWindow msg:msg];
            }
            NSArray *array = data[@"data"];
            NSMutableArray *members = [NSMutableArray array];
            for (NSDictionary *memberDic in array) {
                TAMemberModel *dataModel = [TAMemberModel mj_objectWithKeyValues:memberDic];
                [members addObject:dataModel];
            }
            [[TADataCenter shareInstance] setValue:members forKey:@"membersList"];
        }
    }];
    
    //监听-接收解禁申请
    [socket on: @"SendClientMembersVoiceApplyfor" callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        NSDictionary *data = [array firstObject];;
        if ([data isKindOfClass: [NSDictionary class]]){
            NSString *userName = @"";
            NSString *userPhone = data[@"data"];
            for (TAMemberModel *member in [TADataCenter shareInstance].membersList) {
                if ([member.phone isEqualToString:userPhone]){
                    userName = member.nickname;
                    break;
                }
            }
            
            NSString *msg = data[@"msg"];
            [TAAlert alertWithTitle:msg msg:[NSString stringWithFormat:@"%@正在%@",userName,msg] actionText_1:@"忽略" actionText_2:@"同意" action:^(NSInteger index) {
                TAClientMembersVocieParmModel *parm = [TAClientMembersVocieParmModel new];
                if (index == 1){
                    parm.voice = 2;
                }else{
                    parm.voice = 0;
                }
                parm.phone = userPhone;
                parm.range = @"user";
                [[TASocketManager shareInstance] SendClientMembersVoice:parm];
            }];
        }
    }];
    
    //监听-被踢出了
    [socket on: @"SendClientMembersKickMsg" callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        NSDictionary *data = [array firstObject];;
        if ([data isKindOfClass: [NSDictionary class]]){
            
            NSDictionary *dic = data[@"data"];
            TAUserInfo *userInfo = [TADataCenter shareInstance].userInfo;
            NSString *userPhone = dic[@"phone"];
            
            if ([userPhone isEqualToString:userInfo.phone]){
                [[TARouter shareInstance] logOut];
            }
            NSString *msg = data[@"msg"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [TAToast showTextDialog:kWindow msg:msg];
            });
        }
    }];

    //监听-消息列表
    [socket on: @"receiveClientChatEvent" callback:^(NSArray *array, VPSocketAckEmitter *emitter) {
        NSDictionary *data = [array firstObject];;
        if ([data isKindOfClass: [NSDictionary class]]){
            
            NSArray *array = data[@"data"];
            if (array){
                NSMutableArray *chatList = [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    TAChatDataModel *dataModel = [TAChatDataModel mj_objectWithKeyValues:dic];
                    [chatList addObject:dataModel];
                }
                [[TADataCenter shareInstance] setValue:chatList forKey:@"chatMessages"];
            }
        }
    }];
}

//获取成员列表
- (void)SendClientMemberList
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = [TAClientRoomDataParmModel new];
    [self.socket emit:@"SendClientMembers" items:@[[parm mj_JSONString]]];
}

//全体禁⻨\解除禁⻨\禁⻨某⼈\解禁某⼈\申请解禁\同意解禁\否定解禁\⾃⼰禁麦\⾃⼰开⻨
- (void)SendClientMembersVoice:(TAClientMembersVocieParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.socket emit:@"SendClientMembersVoice" items:@[[parm mj_JSONString]]];
}

//移除某⼈
- (void)SendClientMembersKick:(TAClientMembersKickParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.socket emit:@"SendClientMembersKick" items:@[[parm mj_JSONString]]];
}


//发送消息
- (void)GetHistoricalMessages{
    [self SendClientChatEvent:nil phone:nil];
}
- (void)SendClientChatEvent:(NSString *)content{
    [self SendClientChatEvent:content phone:nil];
}
- (void)SendClientChatEvent:(NSString *)content phone:(NSString *)phone
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.type = @"chat";
    
    TAClientChatMessageParmModel *roomData = [TAClientChatMessageParmModel new];
    roomData.range = @"room";
    roomData.roomNum = [TADataCenter shareInstance].userInfo.roomNum;
    roomData.content = content;
    roomData.phone = phone;
    parm.data = roomData;
    [self.socket emit:@"sendClientChatEvent" items:@[[parm mj_JSONString]]];
}

//心跳
- (void)HeartbeatSendServer
{
    NSDictionary *dic = @{@"type":@"Heart",@"data":@{@"range":@"my",@"ActionName":@"Heart"}};
    [self.socket emit:@"SendServer" items:@[[dic mj_JSONString]]];
    
    if (self.socket.status == VPSocketIOClientStatusConnected || self.socket.status == VPSocketIOClientStatusOpened){
        [self performSelector:@selector(HeartbeatSendServer) withObject:nil afterDelay:18];
    }
}

- (void)reconnect
{
    self.connectTimes ++;
    [self.socket reconnect];
}

- (void)setConnectTimes:(int)connectTimes
{
    _connectTimes = connectTimes;
    if (_connectTimes >= 4){
        _connectTimes = 1;
    }
}

- (void)firstLoadDataOnContented
{
    //获取消息列表
    [[TASocketManager shareInstance] GetHistoricalMessages];
    //获取成员列表
    [[TASocketManager shareInstance] SendClientMemberList];
}
@end
