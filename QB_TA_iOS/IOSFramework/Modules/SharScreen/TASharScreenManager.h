//
//  TASharScreenManager.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/23.
//

#import <Foundation/Foundation.h>
#import "TAHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ScreenStatus) {
    ScreenStart,
    ScreenWait,
    ScreenStop,
};

@interface TASharScreenManager : NSObject
shareInstance_interface(TASharScreenManager);

// 场景
- (void)enterRoom:(UInt32)roomId;
- (void)exitRoom;
- (void)changeRomeWithRomeId:(UInt32)roomId;

// 语音
@property (nonatomic, assign) BOOL isStartLocalAudio;//开麦状态
@property (strong, nonatomic) NSMutableOrderedSet *anchorIdSet;//房间里正在发言的成员
@property (strong, nonatomic) NSMutableOrderedSet *userList;//房间里的成员
- (void)startLocalAudio;
- (void)stopLocalAudio;

// 分享屏幕
@property (assign, nonatomic) ScreenStatus screenStatus;//分享屏幕状态
- (void)startSharScreen;
- (void)stopSharScreen;

@end

NS_ASSUME_NONNULL_END
