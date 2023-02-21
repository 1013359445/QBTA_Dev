//
//  CommInterface.m
//  QBTAIOSFramework
//
//  Created by 白伟 on 2023/1/28.
//  Copyright © 2023 Epic Games, Inc. All rights reserved.
//

#import "CommInterface.h"
#import "TARouter.h"//路由
#import "MJExtension.h"//NS分类

@implementation CommInterface

+ (void)showPageName:(NSString *)pageName
          controller:(UIViewController *)controller
               param:(NSString *)param
            animated:(BOOL)animated
            delegate:(id<CommInterfaceDelegate>) delegate
{
    if (!pageName || !pageName.length) {
        return;
    }
    if (!controller) {
        return;
    }
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = pageName;
    cmd.param = [param mj_JSONObject];
    cmd.animated = animated;

    [[TARouter shareInstance] taskToPageWithCmdModel:cmd controller:controller responseBlock:^(id  _Nonnull result) {
        if (delegate && [delegate respondsToSelector:@selector(iOSResult:)]) {
            [delegate performSelector:@selector(iOSResult:) withObject:result];
        }
    }];
}

+ (void)showViewName:(NSString *)viewName
            baseView:(UIView *)baseView
               param:(NSString *)param
            animated:(BOOL)animated
            delegate:(id<CommInterfaceDelegate>) delegate
{
    if (!viewName || !viewName.length) {
        return;
    }
    if (!baseView) {
        baseView = kWindow;
    }
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = viewName;
    cmd.param = [param mj_JSONObject];
    cmd.animated = animated;

    [[TARouter shareInstance] taskToViewWithCmdModel:cmd baseView:baseView responseBlock:^(id  _Nonnull result) {
        if (delegate && [delegate respondsToSelector:@selector(iOSResult:)]) {
            [delegate performSelector:@selector(iOSResult:) withObject:result];
        }
    }];
}

@end
