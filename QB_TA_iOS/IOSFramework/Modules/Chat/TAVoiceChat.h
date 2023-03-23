//
//  TAVoiceChat.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/17.
//

#import <Foundation/Foundation.h>
#import "TAMacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAVoiceChat : NSObject
shareInstance_interface(TAVoiceChat);

@property (nonatomic, assign) BOOL isStartLocalAudio;//开麦状态
@property (strong, nonatomic) NSMutableOrderedSet *anchorIdSet;//房间里正在发言的成员
@property (strong, nonatomic) NSMutableOrderedSet *userList;//房间里的成员

- (void)enterRoom:(UInt32)roomId;
- (void)exitRoom;
- (void)changeRomeWithRomeId:(UInt32)roomId;

- (void)startLocalAudio;
- (void)stopLocalAudio;

@end

NS_ASSUME_NONNULL_END
