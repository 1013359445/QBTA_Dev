//
//  TARoomManager.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/23.
//  分享屏幕+语音

#import <Foundation/Foundation.h>
#import "TAHeader.h"
#import "TXLiteAVSDK_TRTC/TRTCCloud.h"

NS_ASSUME_NONNULL_BEGIN
static NSString * const DefaultsKeyAudioCaptureVolume = @"DefaultsKeyAudioCaptureVolume";
static NSString * const DefaultsKeyAudioPlayoutVolume = @"DefaultsKeyAudioPlayoutVolume";

typedef NS_ENUM(NSInteger, ScreenStatus) {
    ScreenStart,
    ScreenStop,
    ScreenWait,//别人在分享
};

@interface TARoomManager : NSObject
shareInstance_interface(TARoomManager);

// 场景
- (void)enterRoom:(UInt32)roomId;
- (void)exitRoom;
- (void)changeRomeWithRomeId:(UInt32)roomId;

// 语音
@property (nonatomic, assign) BOOL isStartLocalAudio;//自己的开麦状态
- (void)startLocalAudio;
- (void)stopLocalAudio;

// 分享屏幕
@property (assign, nonatomic) ScreenStatus shareScreenStatus;//分享屏幕状态、开始分享、停止分享、别人在分享
- (void)startShareScreen;
- (void)stopShareScreen;

// 大屏观看
- (void)seeUserVideoWithRemoteView:(UIView *)remoteView;

@end

NS_ASSUME_NONNULL_END
