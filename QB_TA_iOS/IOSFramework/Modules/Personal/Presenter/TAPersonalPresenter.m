//
//  TAPersonalPresenter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/7.
//

#import "TAPersonalPresenter.h"
#import "TARouter.h"

@implementation TAPersonalPresenter

- (void)modifyInfo:(id)param
{
    
}

- (void)modifyCharacter:(id)param
{
    
}

- (void)logOut
{
    //。。。删除用户数据、通知UE登出
    [[TARouter shareInstance] close];
    
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = @"login";
    cmd.animated = NO;
    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:nil];
}

@end
