//
//  TASocket.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/11.
//

#import "TASocket.h"
#import "NSObject+MJKeyValue.h"
#import "TAToast.h"
#import "TAAlert.h"
#import "TARoomManager.h"
#import "TAMemberModel.h"

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

@implementation TASocket
shareInstance_implementation(TASocket);

- (void)socketConnect {
    TAUserInfo *userInfo = [TADataCenter shareInstance].userInfo;
    NSString *host = [NSString stringWithFormat:
                      @"http://39.100.153.162:10246?uid=%ld&room_num=%d&phone=%@&nick_name=%@"
                      ,userInfo.pkid,userInfo.roomNum,userInfo.phone,userInfo.nickname];
    [SIOSocket socketWithHost:host  response: ^(SIOSocket *socket) {
        /** ----------------------------------------------------------------连接----------------------------------------------------------------*/
        if (!socket){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self socketConnect];
            });
            return;
        }
        self.socket = socket;
        
        /** ----------------------------------------------------------------监听----------------------------------------------------------------*/
        //监听-服务器连接事件
        [socket on: @"connect" callback: ^(SIOParameterArray *args) {
            //获取成员列表
            TAClientMembersDataParmModel *parm = [TAClientMembersDataParmModel new];
            parm.range = @"room";
            [self SendClientMembers:parm];
        }];
        //监听服务器关闭服务事件
        [socket on: @"disconnect" callback: ^(SIOParameterArray *args) {
            NSLog(@"---------disconnect");
        }];
        //监听服务器端发送消息事件
        [socket on: @"SendServer" callback: ^(SIOParameterArray *args) {
            NSLog(@"---------SendServer");
        }];
        //监听广播
        [socket on: @"Broadcast" callback: ^(SIOParameterArray *args) {
            NSLog(@"---------Broadcast");
        }];
        
        //监听-成员列表
        [socket on: @"SendClientMembersList" callback: ^(SIOParameterArray *args) {
            NSDictionary *data = [args firstObject];
            if ([data isKindOfClass: [NSDictionary class]]){
                NSString *msg = data[@"msg"];
                int code = [data[@"code"] intValue];
                switch (code) {
                    case 101:
                    case 103:
                    case 106:
                    {
                        [[TARoomManager shareInstance] stopLocalAudio];
                        [[TADataCenter shareInstance] setValue:@(YES) forKey:@"isProhibition"];
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
                        [[TARoomManager shareInstance] startLocalAudio];
                        [[TADataCenter shareInstance] setValue:@(NO) forKey:@"isProhibition"];
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
        [socket on: @"SendClientMembersVoiceApplyfor" callback: ^(SIOParameterArray *args) {
            NSDictionary *data = [args firstObject];
            if ([data isKindOfClass: [NSDictionary class]]){
                NSDictionary *dic = data[@"data"];
                NSString *userName = @"";
                NSString *userPhone = dic[@"phone"];
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
                    [[TASocket shareInstance] SendClientMembersVoice:parm];
                }];
            }
        }];
        
        //监听-被踢出了
        [socket on: @"SendClientMembersKickMsg" callback: ^(SIOParameterArray *args) {
            NSDictionary *data = [args firstObject];
            if ([data isKindOfClass: [NSDictionary class]]){
                NSString *msg = data[@"msg"];
                [TAToast showTextDialog:kWindow msg:msg];

                NSDictionary *dic = data[@"data"];
                TAUserInfo *userInfo = [TADataCenter shareInstance].userInfo;
                NSString *userPhone = dic[@"phone"];
                
                if ([userPhone isEqualToString:userInfo.phone]){
                    [[TARouter shareInstance] logOut];
                }
            }
        }];
    }];
}

/** ----------------------------------------------------------------发送----------------------------------------------------------------*/
//获取成员列表
- (void)SendClientMembers:(TAClientMembersDataParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.socket emit: @"SendClientMembers" args: @[[parm mj_JSONString]]];
}

//全体禁⻨\解除禁⻨\禁⻨某⼈\解禁某⼈\申请解禁\同意解禁\否定解禁\⾃⼰禁麦\⾃⼰开⻨
- (void)SendClientMembersVoice:(TAClientMembersVocieParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.socket emit: @"SendClientMembersVoice" args: @[[parm mj_JSONString]]];
}

//移除某⼈
- (void)SendClientMembersKick:(TAClientMembersKickParmModel *)data
{
    TAClientMembersParmModel *parm = [TAClientMembersParmModel new];
    parm.data = data;
    [self.socket emit: @"SendClientMembersKick" args: @[[parm mj_JSONString]]];
}
@end
