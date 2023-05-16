//
//  TADataCenter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import <Foundation/Foundation.h>
#import "TAMacroDefinition.h"
#import "TAUserInfo.h"
#import "TAMemberModel.h"
#import "TAChatDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TADataCenter : NSObject
shareInstance_interface(TADataCenter)

@property (nonatomic, nullable, retain)NSMutableArray* microphoneUserList;//正在使用麦克风的成员
@property (nonatomic, nullable, retain)NSMutableArray* chatMessages;//消息记录
@property (nonatomic, nullable, retain)TAChatDataModel* clientMessageEvent;//通知
@property (nonatomic, nullable, retain)NSArray*     membersList;//房间的成员

@property (nonatomic, assign)BOOL                   isProhibition;//禁言状态、管理员不受限制
@property (nonatomic, nullable, retain)TAUserInfo*  userInfo;
@property (nonatomic, nullable, copy)NSString*      cookie;
@property (nonatomic, nullable, copy)NSString*      token;

@property (nonatomic, assign)BOOL                   isChatViewVisible;

@end

NS_ASSUME_NONNULL_END
