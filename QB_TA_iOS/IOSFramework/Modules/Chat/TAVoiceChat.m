//
//  TAVoiceChat.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/17.
//

#import "TAVoiceChat.h"
#import "TAToast.h"
#import "GenerateTestUserSig.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"
#import "TADataCenter.h"

@interface TAVoiceChat () <TRTCCloudDelegate>
@property (strong, nonatomic) TRTCCloud *trtcCloud;
@end

@implementation TAVoiceChat
shareInstance_implementation(TAVoiceChat)

- (void)dealloc
{
    [self exitRoom];
}

- (void)changeRomeWithRomeId:(UInt32)roomId
{
    [self exitRoom];
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself enterRoom:roomId];
    });
}

- (void)exitRoom
{
    [self.trtcCloud stopLocalAudio];
    [self.trtcCloud exitRoom];
    [self.anchorIdSet removeAllObjects];
    [self.userList removeAllObjects];
    self.isStartLocalAudio = NO;
    [TRTCCloud destroySharedIntance];
}

- (NSMutableOrderedSet *)anchorIdSet {
    if (!_anchorIdSet) {
        _anchorIdSet = [[NSMutableOrderedSet alloc] initWithCapacity:6];
    }
    return _anchorIdSet;
}
- (NSMutableOrderedSet *)userList {
    if (!_userList) {
        _userList = [[NSMutableOrderedSet alloc] initWithCapacity:50];
    }
    return _userList;
}

- (TRTCCloud *)trtcCloud {
    if (!_trtcCloud) {
        // 创建 SDK 实例（单例模式）并设置事件监听器
        _trtcCloud = [TRTCCloud sharedInstance];
    }
    return _trtcCloud;
}

- (void)enterRoom:(UInt32)roomId {
    NSString *userId = [TADataCenter shareInstance].userInfo.pkid;
    
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = SDKAppID;
    params.roomId = roomId;
    params.userId = userId;
    params.userSig = [GenerateTestUserSig genTestUserSig:userId];
    params.role = TRTCRoleAnchor;//所有成员都是主播
    self.trtcCloud.delegate = self;
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneVoiceChatRoom];
    self.isStartLocalAudio = NO;
}

- (void)startLocalAudio
{
    if (self.anchorIdSet.count >= 6) {
        [TAToast showTextDialog:kWindow msg:@"请稍等~当前对话人数过多"];
        return;
    }
    // 开启麦克风采集，并设置当前场景为：语音模式（高噪声抑制能力、强弱网络抗性）
    [self.trtcCloud startLocalAudio:TRTCAudioQualityDefault];//TRTCAudioQualitySpeech、TRTCAudioQualityDefault
    
    self.isStartLocalAudio = YES;
}

- (void)stopLocalAudio
{
    [self.trtcCloud stopLocalAudio];

    self.isStartLocalAudio = NO;
}

#pragma mark - TRTCCloudDelegate

// 如果切换角色失败，onSwitchRole 回调的错误码便不是 0
// If switching operation failed, the error code of the 'onSwitchRole' is not zero
- (void)onSwitchRole:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg {
    if (errCode != 0) {
        NSLog(@"Switching operation failed... ");
    }
}

// 监听 SDK 的 onEnterRoom 事件并获知是否成功进入房间
// Listen to the onEnterRoom event of the SDK and learn whether the room is successfully entered
- (void)onEnterRoom:(NSInteger)result {
    if (result > 0) {
        [TAToast showTextDialog:kWindow msg:@"Enter room succeed!"];
    } else {
        [TAToast showTextDialog:kWindow msg:@"Enter room failed!"];
    }
}

// 感知远端用户音频状态的变化，并更新开启了麦克风的用户列表(mMicrophoneUserList)
- (void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available{
    NSInteger index = [self.anchorIdSet indexOfObject:userId];
    if (available) {
        if (index != NSNotFound) { return; }
        [self.anchorIdSet addObject:userId];
    } else {
        if (index) {
            [self.anchorIdSet removeObject:userId];
        }
    }
}

// 感知远端用户进入房间的通知，并更新远端用户列表(mUserList)
- (void)onRemoteUserEnterRoom:(NSString *)userId{
    NSInteger index = [self.anchorIdSet indexOfObject:userId];
    if (index != NSNotFound) { return; }
    [self.userList addObject:userId];
}

// 感知远端用户离开房间的通知，并更新远端用户列表(mUserList)
- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason{
    NSInteger index = [self.anchorIdSet indexOfObject:userId];
    if (index != NSNotFound) { return; }
    [self.userList removeObject:userId];
}

@end
