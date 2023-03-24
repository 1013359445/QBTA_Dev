//
//  TASharScreenManager.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/23.
//

#import "TASharScreenManager.h"

#import "GenerateTestUserSig.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"
#import "TABroadcastExtensionLauncher.h"

@interface TASharScreenManager ()<TRTCCloudDelegate>
@property (strong, nonatomic) TRTCCloud *trtcCloud;
@property (strong, nonatomic) TRTCVideoEncParam *encParams;
@end

#define APPGROUP @"group.com.gsdata.qingReplay"

@implementation TASharScreenManager
shareInstance_implementation(TASharScreenManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.screenStatus = ScreenStop;
        self.trtcCloud.delegate = self;
    }
    return self;
}


# pragma mark - 场景
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

- (void)enterRoom:(UInt32)roomId {
    NSString *userId = [TADataCenter shareInstance].userInfo.pkid;
    
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = SDKAppID;
    params.roomId = roomId;
    params.userId = userId;
    params.userSig = [GenerateTestUserSig genTestUserSig:userId];
    params.role = TRTCRoleAnchor;//主播
    self.isStartLocalAudio = NO;
    
    self.encParams.videoResolution = TRTCVideoResolution_1280_720;
    self.encParams.videoBitrate = 550;
    self.encParams.videoFps = 10;
    
    ///TRTCAppSceneVideoCall视频通话场景，支持720P、1080P高清画质，单个房间最多支持300人同时在线，最高支持50人同时发言。
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
    
    [self.trtcCloud startScreenCaptureByReplaykit:TRTCVideoStreamTypeSub encParam:self.encParams appGroup:APPGROUP];
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

# pragma mark - 语音
- (void)startLocalAudio
{
    if (self.anchorIdSet.count >= 6) {
        [TAToast showTextDialog:kWindow msg:@"请稍等~当前对话人数过多"];
        return;
    }
    // 开启麦克风采集
    [self.trtcCloud startLocalAudio:TRTCAudioQualityDefault];
    
    self.isStartLocalAudio = YES;
}

- (void)stopLocalAudio
{
    [self.trtcCloud stopLocalAudio];

    self.isStartLocalAudio = NO;
}

# pragma mark - 共享屏幕
- (void)startSharScreen
{
    [TABroadcastExtensionLauncher launch];
}

// 停止屏幕分享
- (void)stopSharScreen
{
    if (_screenStatus == ScreenStart) {
        [self.trtcCloud stopScreenCapture];
    }
}


# pragma mark - 懒加载
- (TRTCCloud *)trtcCloud {
    if (!_trtcCloud) {
        // 创建 SDK 实例（单例模式）并设置事件监听器
        _trtcCloud = [TRTCCloud sharedInstance];
    }
    return _trtcCloud;
}

- (TRTCVideoEncParam *)encParams {
    if (!_encParams) {
        _encParams = [TRTCVideoEncParam new];
    }
    return _encParams;
}

#pragma mark - TRTCCloudDelegate
- (void)onScreenCaptureStarted {
    _screenStatus = ScreenStart;
    [[NSNotificationCenter defaultCenter] postNotificationName:IOSFrameworkScreenStatusChangeNotification object:nil userInfo:nil];
}

- (void)onScreenCaptureStoped:(int)reason {
    _screenStatus = ScreenStop;
    [[NSNotificationCenter defaultCenter] postNotificationName:IOSFrameworkScreenStatusChangeNotification object:nil userInfo:nil];
}

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
