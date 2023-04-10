//
//  TARoomManager.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/23.
//

#import "TARoomManager.h"

#import "GenerateTestUserSig.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"
#import "TABroadcastExtensionLauncher.h"

@interface TARoomManager ()<TRTCCloudDelegate, TRTCVideoRenderDelegate>
@property (strong, nonatomic) TRTCCloud *trtcCloud;
@property (strong, nonatomic) TRTCVideoEncParam *encParams;
@property (weak, nonatomic) UIView *remoteView;
//分享屏幕用户的id
@property (copy, nonatomic) NSString *remoteUserId;
@property (assign, nonatomic) int roomId;
@property (nonatomic, assign) BOOL isFirstStartLocalAudio;
@property (nonatomic, assign) BOOL isShareScreenHorizontal;

@end

#define APPGROUP @"group.com.gsdata.qingReplay"

@implementation TARoomManager
shareInstance_implementation(TARoomManager);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.trtcCloud.delegate = self;
        self.isShareScreenHorizontal = YES;
    }
    return self;
}

# pragma mark - 房间-场景
- (void)dealloc
{
    [self exitRoom];
}

- (void)changeRomeWithRomeId:(UInt32)roomId
{
    [self exitRoom];
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself enterRoom:roomId];
    });
}

- (void)exitRoom
{
    [self.trtcCloud muteLocalAudio:YES];//暂停本地音频采集
    [self.trtcCloud stopLocalAudio];
    [self stopShareScreen];
    
    [self.trtcCloud exitRoom];
    [self.microphoneUserList removeAllObjects];
    [self.userList removeAllObjects];
    
    
    self.shareScreenStatus = ScreenStop;
    [self setValue:@(NO) forKey:@"isStartLocalAudio"];
}

- (void)enterRoom:(UInt32)roomId {
    kShowHUDAndActivity;
    self.isFirstStartLocalAudio = YES;
    self.shareScreenStatus = ScreenStop;
    [self setValue:@(NO) forKey:@"isStartLocalAudio"];

    self.roomId = roomId;
    NSString *userId = [TADataCenter shareInstance].userInfo.nickname;
    
    TRTCParams *params = [[TRTCParams alloc] init];
    params.sdkAppId = SDKAppID;
    params.roomId = roomId;
    params.userId = userId;
    params.userSig = [GenerateTestUserSig genTestUserSig:userId];
    self.encParams.videoResolution = TRTCVideoResolution_1280_720;
    self.encParams.videoBitrate = 550;
    self.encParams.videoFps = 10;
    //等待分享屏幕
    [self.trtcCloud startScreenCaptureByReplaykit:TRTCVideoStreamTypeSub encParam:self.encParams appGroup:APPGROUP];
    
    ///TRTCAppSceneVideoCall视频通话场景，支持720P、1080P高清画质，单个房间最多支持300人同时在线，最高支持50人同时发言。
    [self.trtcCloud enterRoom:params appScene:TRTCAppSceneVideoCall];
}

- (NSMutableOrderedSet *)microphoneUserList {
    if (!_microphoneUserList) {
        _microphoneUserList = [[NSMutableOrderedSet alloc] initWithCapacity:6];//6人以上同时说话过于混乱
    }
    return _microphoneUserList;
}
- (NSMutableOrderedSet *)userList {
    if (!_userList) {
        _userList = [[NSMutableOrderedSet alloc] initWithCapacity:299];
        NSArray *names =  @[@"杜子藤",@"沈京兵",@"杜琦燕",@"焦厚根",@"史珍香",@"胡丽晶",@"梅良鑫",@"尤勇驰"];
        NSString *userId = [TADataCenter shareInstance].userInfo.nickname;
        [_userList addObject:userId];
        [_userList addObjectsFromArray:names];
    }
    return _userList;
}

- (void)kickOutUser:(NSString *)userId
{
    [[self mutableArrayValueForKey:@"userList"] removeObject:userId];
    [[self mutableArrayValueForKey:@"microphoneUserList"] removeObject:userId];
}

# pragma mark - 语音
- (void)startLocalAudio
{
    if (self.microphoneUserList.count >= 6) {
        [TAToast showTextDialog:kWindow msg:@"请稍等~当前对话人数过多"];
        return;
    }
    if (self.isFirstStartLocalAudio) {
        // 开启麦克风采集
        [self.trtcCloud startLocalAudio:TRTCAudioQualityDefault];
        self.isFirstStartLocalAudio = NO;
    }
    [self.trtcCloud muteLocalAudio:NO];//开始本地音频采集
    
    NSString *userId = [TADataCenter shareInstance].userInfo.nickname;
    NSInteger index = [self.microphoneUserList indexOfObject:userId];
    if (index != NSNotFound) { return; }
    [[self mutableArrayValueForKey:@"microphoneUserList"] addObject:userId];

    [self setValue:@(YES) forKey:@"isStartLocalAudio"];
}

- (void)stopLocalAudio
{
    [self.trtcCloud muteLocalAudio:YES];//暂停本地音频采集
    
    NSString *userId = [TADataCenter shareInstance].userInfo.nickname;
    NSInteger index = [self.microphoneUserList indexOfObject:userId];
    if (index == NSNotFound) { return; }
    [[self mutableArrayValueForKey:@"microphoneUserList"] removeObject:userId];
    
    [self setValue:@(NO) forKey:@"isStartLocalAudio"];
}

# pragma mark - 共享屏幕
// 开始屏幕分享
- (void)startShareScreen
{
    if (_shareScreenStatus == ScreenStop) {
        if (self.isFirstStartLocalAudio) {
            // 开启并暂停麦克风采集
            [self.trtcCloud startLocalAudio:TRTCAudioQualityDefault];
            [self.trtcCloud muteLocalAudio:YES];
            self.isFirstStartLocalAudio = NO;
        }
        [self.trtcCloud startScreenCaptureByReplaykit:TRTCVideoStreamTypeSub encParam:self.encParams appGroup:APPGROUP];
        [TABroadcastExtensionLauncher launch];
    }
}

// 停止屏幕分享
- (void)stopShareScreen
{
    if (_shareScreenStatus == ScreenStart) {
        [self.trtcCloud stopScreenCapture];
    }
}

// 大屏观看
- (void)seeUserVideoWithRemoteView:(UIView *)remoteView
{
    self.remoteView = remoteView;
    if (_shareScreenStatus == ScreenWait && self.remoteUserId != nil) {
        [self onUserSubStreamAvailable:self.remoteUserId available:YES];
    }
}

# pragma mark - getter
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
#pragma mark - setter
- (void)setIsProhibition:(BOOL)isProhibition
{
    if (_isProhibition == isProhibition){
        return;
    }
    _isProhibition = isProhibition;
    //通知服务端禁言状态
    [self setValue:@(isProhibition) forKey:@"isProhibition"];
}

//自动旋转屏幕
- (void)setIsShareScreenHorizontal:(BOOL)isShareScreenHorizontal
{
    _isShareScreenHorizontal = isShareScreenHorizontal;
    if (isShareScreenHorizontal)
    {
        self.remoteView.transform = CGAffineTransformMakeRotation(0);
    }else{
        if (self.remoteView){
            if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight) {
                self.remoteView.transform = CGAffineTransformMakeRotation(M_PI_2);
            }else if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) {
                self.remoteView.transform = CGAffineTransformMakeRotation(-M_PI_2);
            }
        }
    }
}

- (void)setShareScreenStatus:(ScreenStatus)shareScreenStatus
{
    if (_shareScreenStatus == shareScreenStatus){
        return;
    }
    _shareScreenStatus = shareScreenStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:IOSFrameworkShareScreenStatusChangeNotification object:nil userInfo:nil];
}

- (void)setIsStartLocalAudio:(BOOL)isStartLocalAudio
{
    if (_isStartLocalAudio == isStartLocalAudio)
    {
        return;
    }
    _isStartLocalAudio = isStartLocalAudio;
    [[NSNotificationCenter defaultCenter] postNotificationName:IOSFrameworkLocalAudioStatusChangeNotification object:nil userInfo:nil];
}

#pragma mark - TRTCCloudDelegate
//开始分享自己的屏幕
- (void)onScreenCaptureStarted {
    self.shareScreenStatus = ScreenStart;
    [self.trtcCloud setLocalVideoRenderDelegate:self
                                    pixelFormat:TRTCVideoPixelFormat_NV12
                                     bufferType:TRTCVideoBufferType_PixelBuffer];
}
//结束分享自己的屏幕
- (void)onScreenCaptureStoped:(int)reason {
    self.shareScreenStatus = ScreenStop;
}

//有其他人开始或结束分享屏幕
- (void)onUserVideoAvailable:(NSString *)userId available:(BOOL)available {
    [self onUserSubStreamAvailable:userId available:available];
}

- (void)onUserSubStreamAvailable:(NSString *)userId available:(BOOL)available {
    if (available) {
        [self.trtcCloud setRemoteVideoRenderDelegate:userId delegate:self
                                         pixelFormat:TRTCVideoPixelFormat_NV12
                                          bufferType:TRTCVideoBufferType_PixelBuffer];

        self.remoteUserId = userId;
        self.shareScreenStatus = ScreenWait;
        if (self.remoteView) {
            self.remoteView.hidden = NO;
//            // 将 denny 的主路画面切换到一个悬浮的小窗口中（假如该迷你小窗口为 miniFloatingView）
//            [self.trtcCloud updateRemoteView:miniFloatingView streamType:TRTCVideoStreamTypeBig forUser:@"denny"];
            [self.trtcCloud startRemoteView:userId streamType:TRTCVideoStreamTypeSub view:self.remoteView];
            // 将远端用户 的主路画面设置为填充模式
            TRTCRenderParams *param = [[TRTCRenderParams alloc] init];
            param.fillMode = TRTCVideoFillMode_Fit;//TRTCVideoFillMode_Fit;
            [self.trtcCloud setRemoteRenderParams:userId streamType:TRTCVideoStreamTypeSub params:param];
        }
    } else {
        self.remoteUserId = nil;
        self.shareScreenStatus = ScreenStop;
        if (self.remoteView) {
            self.remoteView.hidden = YES;
        }
    }
}

// 监听 SDK 的 onEnterRoom 事件并获知是否成功进入房间
// Listen to the onEnterRoom event of the SDK and learn whether the room is successfully entered
- (void)onEnterRoom:(NSInteger)result {
    if (result > 0) {
        [TAToast showTextDialog:kWindow msg:[NSString stringWithFormat:@"成功加入房间:%d",self.roomId]];
        NSString *userId = [TADataCenter shareInstance].userInfo.nickname;
        [self.trtcCloud setRemoteVideoRenderDelegate:userId delegate:self pixelFormat:TRTCVideoPixelFormat_NV12 bufferType:TRTCVideoBufferType_PixelBuffer];

    } else {
        [TAToast showTextDialog:kWindow msg:[NSString stringWithFormat:@"%d 进房失败!",self.roomId]];
    }
    kHiddenHUDAndAvtivity;
}

// 感知远端用户音频状态的变化，并更新开启了麦克风的用户列表
- (void)onUserAudioAvailable:(NSString *)userId available:(BOOL)available{
    NSInteger index = [self.microphoneUserList indexOfObject:userId];
    if (available) {
        if (index != NSNotFound) { return; }
        [[self mutableArrayValueForKey:@"microphoneUserList"] addObject:userId];
    } else {
        if (index == NSNotFound) { return; }
        [[self mutableArrayValueForKey:@"microphoneUserList"] removeObject:userId];
    }
}

// 感知远端用户进入房间的通知，并更新远端用户列表
- (void)onRemoteUserEnterRoom:(NSString *)userId{
    NSInteger index = [self.userList indexOfObject:userId];
    if (index != NSNotFound) { return; }
    [[self mutableArrayValueForKey:@"userList"] addObject:userId];
}

// 感知远端用户离开房间的通知，并更新远端用户列表
- (void)onRemoteUserLeaveRoom:(NSString *)userId reason:(NSInteger)reason{
    NSInteger index = [self.userList indexOfObject:userId];
    if (index == NSNotFound) { return; }
    [[self mutableArrayValueForKey:@"userList"] removeObject:userId];
    [TAToast showTextDialog:kWindow msg:[NSString stringWithFormat:@"用户%@离开房间",userId]];
}

- (void)onExitRoom:(NSInteger)reason
{
    if (reason == 1){
        [TAToast showTextDialog:kWindow msg:@"您已被管理员踢出房间"];
    }else if (reason == 2){
        [TAToast showTextDialog:kWindow msg:@"房间已解散"];
    }
}

//用户视频大小发生改变回调
- (void)onUserVideoSizeChanged:(NSString *)userId streamType:(TRTCVideoStreamType)streamType newWidth:(int)newWidth newHeight:(int)newHeight
{
    self.isShareScreenHorizontal = (newWidth > newHeight);
}

- (void)onRenderVideoFrame:(TRTCVideoFrame *_Nonnull)frame
                    userId:(NSString *__nullable)userId
                streamType:(TRTCVideoStreamType)streamType
{
    //userId是nil时为本地画面，否则为远端画面
    CFRetain(frame.pixelBuffer);
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//        frame.pixelBuffer
//        frame.textureId
//        frame.data
//        
//        TestRenderVideoFrame *strongSelf = weakSelf;
//        UIImageView* videoView = nil;
//        if (userId) {
//            videoView = [strongSelf.userVideoViews objectForKey:userId];
//        }
//        else {
//            videoView = strongSelf.localVideoView;
//        }
//        videoView.image = [UIImage imageWithCIImage:[CIImage imageWithCVImageBuffer:frame.pixelBuffer]];
//        videoView.contentMode = UIViewContentModeScaleAspectFit;
        CFRelease(frame.pixelBuffer);
    });
}


// 如果切换角色失败，onSwitchRole 回调的错误码便不是 0
// If switching operation failed, the error code of the 'onSwitchRole' is not zero
- (void)onSwitchRole:(TXLiteAVError)errCode errMsg:(nullable NSString *)errMsg {
    if (errCode != 0) {
        NSString *msg = [self errorMsgWithErrorCode:errCode];
        if (msg && msg.length) {
            [TAToast showTextDialog:kWindow msg:msg];
        }
    }
}

- (NSString *)errorMsgWithErrorCode:(TXLiteAVError)errorCode
{
    NSString *errorMsg;
    switch (errorCode) {
            /////////////////////////////////////////////////////////////////////////////////
            //       视频相关错误码
            /////////////////////////////////////////////////////////////////////////////////
            ///打开摄像头失败，例如在 Windows 或 Mac 设备，摄像头的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
        case ERR_CAMERA_START_FAIL:// = -1301
            errorMsg = @"打开摄像头失败";
            break;
            ///摄像头设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
            case ERR_CAMERA_NOT_AUTHORIZED:// = -1314,
            errorMsg = @"摄像头设备未授权";
            break;
            ///摄像头参数设置出错（参数不支持或其它）
            case ERR_CAMERA_SET_PARAM_FAIL:// = -1315,
            errorMsg = @"摄像头参数设置出错";
            break;
            ///摄像头正在被占用中，可尝试打开其他摄像头
            case ERR_CAMERA_OCCUPY:// = -1316,
            errorMsg = @"摄像头正在被占用中";
            break;
            ///开始录屏失败，如果在移动设备出现，可能是权限被用户拒绝了，如果在 Windows 或 Mac 系统的设备出现，请检查录屏接口的参数是否符合要求
            case ERR_SCREEN_CAPTURE_START_FAIL:// = -1308,
            errorMsg = @"开始录屏失败";
            break;
            ///录屏失败，在 Android 平台，需要5.0以上的系统，在 iOS 平台，需要11.0以上的系统
            case ERR_SCREEN_CAPTURE_UNSURPORT:// = -1309,
            errorMsg = @"录屏失败，需要11.0以上的系统";
            break;
            ///录屏被系统中止
            case ERR_SCREEN_CAPTURE_STOPPED:// = -7001,
            errorMsg = @"录屏被系统中止";
            break;
            ///没有权限上行辅路
            case ERR_SCREEN_SHARE_NOT_AUTHORIZED:// = -102015,
            errorMsg = @"没有权限上行辅路";
            break;
            ///其他用户正在上行辅路
            case ERR_SCREEN_SHRAE_OCCUPIED_BY_OTHER:// = -102016,
            errorMsg = @"其他用户正在分享屏幕";
            break;
            ///视频帧编码失败，例如 iOS 设备切换到其他应用时，硬编码器可能被系统释放，再切换回来时，硬编码器重启前，可能会抛出
            case ERR_VIDEO_ENCODE_FAIL:// = -1303,
            errorMsg = @"频帧编码失败，请重试";
            break;
            ///不支持的视频分辨率
            case ERR_UNSUPPORTED_RESOLUTION:// = -1305,
            errorMsg = @"不支持的视频分辨率";
            break;
            
            /////////////////////////////////////////////////////////////////////////////////
            //       音频相关错误码
            /////////////////////////////////////////////////////////////////////////////////
            ///打开麦克风失败，例如在 Windows 或 Mac 设备，麦克风的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
            case ERR_MIC_START_FAIL:// = -1302,
            errorMsg = @"打开麦克风失败";
            break;
            ///麦克风设备未授权，通常在移动设备出现，可能是权限被用户拒绝了
            case ERR_MIC_NOT_AUTHORIZED:// = -1317,
            errorMsg = @"麦克风设备未授权";
            break;
            ///麦克风设置参数失败
            case ERR_MIC_SET_PARAM_FAIL:// = -1318,
            errorMsg = @"麦克风设置参数失败";
            break;
            ///麦克风正在被占用中，例如移动设备正在通话时，打开麦克风会失败
            case ERR_MIC_OCCUPY:// = -1319,
            errorMsg = @"麦克风正在被占用中";
            break;
            ///停止麦克风失败
            case ERR_MIC_STOP_FAIL:// = -1320,
            errorMsg = @"停止麦克风失败";
            break;
            ///打开扬声器失败，例如在 Windows 或 Mac 设备，扬声器的配置程序（驱动程序）异常，禁用后重新启用设备，或者重启机器，或者更新配置程序
            case ERR_SPEAKER_START_FAIL:// = -1321,
            errorMsg = @"打开扬声器失败";
            break;
            ///扬声器设置参数失败
            case ERR_SPEAKER_SET_PARAM_FAIL:// = -1322,
            errorMsg = @"扬声器设置参数失败";
            break;
            ///停止扬声器失败
            case ERR_SPEAKER_STOP_FAIL:// = -1323,
            errorMsg = @"停止扬声器失败";
            break;
            ///开启系统声音录制失败，例如音频驱动插件不可用
            case ERR_AUDIO_PLUGIN_START_FAIL:// = -1330,
            errorMsg = @"开启系统声音录制失败";
            break;
            ///不支持的音频采样率
            case ERR_UNSUPPORTED_SAMPLERATE:// = -1306,
            errorMsg = @"不支持的音频采样率";
            break;
        default:
            errorMsg = nil;
            break;
    }
    return errorMsg;
}
@end
