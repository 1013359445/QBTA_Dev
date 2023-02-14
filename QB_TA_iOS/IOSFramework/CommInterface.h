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

//在视图上显示
+ (void)showViewOnWindowWithParam:(NSString *)param;
+ (void)showViewOnWindowWithParam:(NSString *)param delegate:(id<CommInterfaceDelegate>) delegate;
+ (void)showViewWithParam:(NSString *)param baseView:(UIView *)baseView delegate:(id<CommInterfaceDelegate>) delegate;

//切入新页面，controller必传
+ (void)showViewWithParam:(NSString *)param controller:(UIViewController *)controller delegate:(id<CommInterfaceDelegate>) delegate;

//+ (void)goBack;
//+ (void)close;

@end

NS_ASSUME_NONNULL_END
