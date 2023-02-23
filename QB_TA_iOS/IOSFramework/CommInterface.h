//
//  CommInterface.h
//  QBTAIOSFramework
//
//  Created by 白伟 on 2023/1/28.
//  Copyright © 2023 Epic Games, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 *  CommInterfaceDelegate
 */
typedef void (^ResultBlock) (NSString *param);
@protocol CommInterfaceDelegate <NSObject>

/*  iOS发送信息给UE（UE端实现）
 *  msg 发送内容
 *  type 消息类型     1发送通知 2请求数据 3页面跳转(场景转换)
 *  notification    用于找到通知/接收对象
 */
- (void)sendMessagesToUE:(NSString * _Nonnull)msg type:(int)type notification:(nullable NSNotificationName)notification;

@end


/*
 *  CommInterface
 */
@interface CommInterface : NSObject
/*  获取单例*/
+ (CommInterface *)shareInstance;

/*  ueDelegate 必须赋值才能接收到来自iOS的消息*/
@property (nonatomic, weak)id<CommInterfaceDelegate> ueDelegate;
/*  iOSViewController 默认承载iOS原生页面的视图控制器*/
@property (nonatomic, retain)UIViewController *iOSViewController;
/*  iOSView 默认承载iOS原生视图的父视图*/
@property (nonatomic, retain)UIView *iOSView;//（默认iOSView 承载，iOSView为空则承载到Window上）


/*  显示iOS视图
 *  name 视图名称
 *  animated 动画
 *  param 参数
 */
+ (void)showIOSWithName:(NSString * __nonnull)name
                  param:(NSString * __nullable)param
               animated:(BOOL)animated
           notification:(nullable NSNotificationName)notification;


/*  UE发送信息给iOS（iOS端实现）
 *  msg 发送内容
 *  type 消息类型     1发送通知 2请求数据 3页面跳转 4弹出视图
 *  notification    用于找到通知/接收对象
 */
+ (void)sendMessagesToIOS:(id __nullable)msg type:(int)type notification:(nullable NSNotificationName)notification;


@end

NS_ASSUME_NONNULL_END
