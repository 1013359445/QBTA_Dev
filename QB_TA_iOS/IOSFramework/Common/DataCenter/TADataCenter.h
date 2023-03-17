//
//  TADataCenter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import <Foundation/Foundation.h>
#import "TAMacroDefinition.h"
#import "TAUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

static NSNotificationName ChatPeopleWhoSpeakChange = @"ChatPeopleWhoSpeakChange";

@interface TADataCenter : NSObject
shareInstance_interface(TADataCenter)

@property (nonatomic, retain)TAUserInfo *userInfo;

@property (nonatomic, copy)NSString *cookie;
@property (nonatomic, copy)NSString *token;

@property (nonatomic, retain)NSMutableArray *chatMessages;
@property (nonatomic, retain)NSMutableArray *peopleWhoSpeakArray;
- (void)addChatMessage:(NSString *)msg;
- (void)addPeopleWhoSpeak:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
