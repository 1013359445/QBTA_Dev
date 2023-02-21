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


typedef void (^ResultBlock) (NSString *param);

@protocol CommInterfaceDelegate <NSObject>

- (void)iOSResult:(id)result;

@end

@interface CommInterface : NSObject

/*
 *  pageName 页面名称
 *  animated 动画
 *  param 参数
 *  controller 承载页面的controller
 *  delegate 接收回调
 */
+ (void)showPageName:(NSString * _Nonnull )pageName
          controller:(UIViewController * _Nonnull)controller
               param:(NSString * __nullable)param
            animated:(BOOL)animated
            delegate:(id<CommInterfaceDelegate>) delegate;
/*
 *  viewName 视图名称
 *  animated 动画
 *  param 参数
 *  baseView 承载视图的父视图
 *  delegate 接收回调
 */
+ (void)showViewName:(NSString * __nonnull)viewName
            baseView:(UIView * __nullable)baseView
               param:(NSString * __nullable)param
            animated:(BOOL)animated
            delegate:(id<CommInterfaceDelegate>) delegate;

+ (void)showViewName:(NSString * __nonnull)viewName
            baseView:(UIView * __nullable)baseView
               param:(NSString * __nullable)param
            animated:(BOOL)animated
            delegate:(id<CommInterfaceDelegate>) delegate;

@end

NS_ASSUME_NONNULL_END
