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

+ (void)showViewOnWindowWithParam:(NSString *)param
{
    [self showViewWithParam:param base:kWindow baseType:@"baseView" delegate:nil];
}
+ (void)showViewOnWindowWithParam:(NSString *)param delegate:(id<CommInterfaceDelegate>) delegate
{
    [self showViewWithParam:param base:kWindow baseType:@"baseView" delegate:delegate];
}

+ (void)showViewWithParam:(NSString *)param baseView:(UIView *)baseView delegate:(id<CommInterfaceDelegate>) delegate
{
    [self showViewWithParam:param base:baseView baseType:@"baseView" delegate:delegate];
}

+ (void)showViewWithParam:(NSString *)param controller:(UIViewController *)controller delegate:(id<CommInterfaceDelegate>) delegate
{
    [self showViewWithParam:param base:controller baseType:@"controller" delegate:delegate];
}

+ (void)showViewWithParam:(NSString *)param base:(id)base baseType:(NSString *)baseType delegate:(id<CommInterfaceDelegate>) delegate
{
    NSDictionary *dic = [param mj_JSONObject];
    if (!dic) {
        NSLog(@"error:未得到参数 param:%@",param);
        return;
    }
    
    NSMutableDictionary *parmData = [NSMutableDictionary dictionaryWithDictionary:[param mj_JSONObject]];
    if ([baseType isEqualToString:@"controller"] && !base){
        NSLog(@"error:未指定上级视图控制器 param:%@",param);
        return;
    }else if ([baseType isEqualToString:@"baseView"] && !base){
        NSLog(@"warning:未指定父视图，已替换为window param:%@",param);
        base = kWindow;
    }
    [parmData setObject:base forKey:baseType];

    //路由跳转
    [[TARouter shareInstance] taskToPageWithParm:parmData successBlock:^(id result) {
        NSLog(@"success:%@",result);
        if (delegate && [delegate respondsToSelector:@selector(iOSResult:)]) {
            [delegate performSelector:@selector(iOSResult:) withObject:result];
        }
    } failedBlock:^(id result) {
        NSLog(@"failed:%@",result);
    }];
}

//+ (void)goBack
//{
//    
//}
//
//+ (void)close
//{
//    
//}

@end
