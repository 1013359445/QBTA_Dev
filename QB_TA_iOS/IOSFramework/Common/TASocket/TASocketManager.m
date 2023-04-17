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
#import "SIOSocket.h"

@implementation TAClientMembersDataParmModel
- (void)assignDefaultValue
{
    self.roomNum = [TADataCenter shareInstance].userInfo.roomNum;
}
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

@interface TASocketManager () <TAWebSocketDelegate>

@end
@implementation TASocketManager
shareInstance_implementation(TASocketManager);

//收到消息
- (void)TAWebSocketDidReceiveMessage:(NSString *)message
{
    if (@"用户参数正确   连接成功"){
        //获取成员列表
        TAClientMembersDataParmModel *parm = [TAClientMembersDataParmModel new];
        parm.range = @"room";
        [self SendClientMembers:parm];
    }else if (@"SendClientMembersList"){
        //监听-成员列表
        NSDictionary *data = @{};
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
    }else if (@"SendClientMembersVoiceApplyfor"){
        //监听-接收解禁申请
        NSDictionary *data = @{};
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
    }else if (@"SendClientMembersKickMsg"){
        //监听-被踢出了
        NSDictionary *data = @{};
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
    }
}

//首次连接成功，没有验证用户身份
- (void)TAWebSocketDidOpen
{
    //验证身份
    [self VerifyUserIdentity];
}

- (void)socketConnect {
    NSString *url = @"http://39.100.153.162:10246";
    self.webSocket = [[TAWebSocket alloc] initWithServerIp:url];
    _webSocket.delegate = self;
    [_webSocket connectWebSocket];
}

//验证身份
- (void)VerifyUserIdentity
{
    TAUserInfo *userInfo = [TADataCenter shareInstance].userInfo;
    NSDictionary *parmDic = @{@"data":@{@"uid":@(userInfo.pkid),
                                        @"room_num":@(userInfo.roomNum),
                                        @"phone":userInfo.phone,
                                        @"nick_name":userInfo.nickname},
                              @"type":@"room"
    };
    [self.webSocket sendMsg:[parmDic mj_JSONString]];
}

//获取成员列表
- (void)SendClientMembers:(TAClientMembersDataParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.webSocket sendMsg:[parm mj_JSONString]];
}

//全体禁⻨\解除禁⻨\禁⻨某⼈\解禁某⼈\申请解禁\同意解禁\否定解禁\⾃⼰禁麦\⾃⼰开⻨
- (void)SendClientMembersVoice:(TAClientMembersVocieParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.webSocket sendMsg:[parm mj_JSONString]];
}

//移除某⼈
- (void)SendClientMembersKick:(TAClientMembersKickParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.webSocket sendMsg:[parm mj_JSONString]];
}

@end
