//
//  TARoomManager.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/23.
//  分享屏幕+语音

#import <Foundation/Foundation.h>
#import "TAHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ScreenStatus) {
    ScreenStart,
    ScreenStop,
    ScreenWait,//别人在分享
};

@interface TARoomManager : NSObject
shareInstance_interface(TARoomManager);

@property (nonatomic, assign)BOOL   isProhibition;//禁言状态

// 场景
- (void)enterRoom:(UInt32)roomId;
- (void)exitRoom;
- (void)changeRomeWithRomeId:(UInt32)roomId;
@property (strong, nonatomic) NSMutableOrderedSet *userList;//房间里的成员
- (void)kickOutUser:(NSString *)userId;

// 语音
@property (nonatomic, assign) BOOL isStartLocalAudio;//自己的开麦状态
@property (strong, nonatomic) NSMutableOrderedSet *microphoneUserList;//房间里正在发言的成员
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
