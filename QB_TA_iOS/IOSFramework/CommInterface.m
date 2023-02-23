//
//  CommInterface.m
//  QBTAIOSFramework
//
//  Created by 白伟 on 2023/1/28.
//  Copyright © 2023 Epic Games, Inc. All rights reserved.
//

#import "CommInterface.h"
#import "TAHeader.h"

@implementation CommInterface

static CommInterface *_instanceCommInterface;
+ (CommInterface *)shareInstance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceCommInterface = [[self alloc] init];
    });
    return _instanceCommInterface;
}

+ (void)showIOSWithName:(NSString * __nonnull)name
                  param:(NSString * __nullable)param
               animated:(BOOL)animated
           notification:(nullable NSNotificationName)notification
{
    if (!name || !name.length) {
        return;
    }
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = name;
    cmd.param = [param mj_JSONObject];
    cmd.animated = animated;
    id<CommInterfaceDelegate> delegate = [self shareInstance].ueDelegate;

    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:^(id  _Nonnull result) {
        if (delegate && [delegate respondsToSelector:@selector(sendMessagesToUE:type:notification:)]) {
            [delegate sendMessagesToUE:result type:1 notification:notification];
        }
    }];
}
     
/*  UE发送信息给iOS（iOS端实现）
 *  msg 发送内容
 *  type 消息类型   1发送通知 2请求数据 3页面跳转 4弹出视图
 *  notification 用于找到通知对象
 */
+ (void)sendMessagesToIOS:(id __nullable)msg type:(int)type notification:(nullable NSNotificationName)notification
{
    
}

@end
