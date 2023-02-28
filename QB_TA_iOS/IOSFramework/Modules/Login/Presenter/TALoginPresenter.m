//
//  TALoginPresenter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import "TALoginPresenter.h"
#import "TALoginInterface.h"
#import "TACaptchaInterface.h"

#import "TAUserInfoDataModel.h"

#import "CommInterface.h"

NSNotificationName const IOSFrameworkWaitingRoleDataNotification = @"getRoleData";

@implementation TALoginPresenter

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginWithParam:(TALoginParmModel *)param
{
    kShowHUDAndActivity;
    kWeakSelf(self);
    [[TALoginInterface shareInstance] requestWithParmModel:param dataModelClass:[TAUserInfoDataModel class] succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response, NSString *jsonStr) {
        if ([weakself.view respondsToSelector:@selector(onLoginSuccess:jsonStr:)]) {
            [weakself.view onLoginSuccess:dataModel jsonStr:jsonStr];
        }
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response, NSString *jsonStr) {
        [MBProgressHUD showTextDialog:kWindow msg:msg];
    } finishedBlock:^{
        kHiddenHUDAndAvtivity;
    }];
    
}

- (void)getVCodeWithParam:(TACaptchaParmModel *)param
{
    kShowHUDAndActivity;
    kWeakSelf(self);
    [[TACaptchaInterface shareInstance] requestWithParmModel:param dataModelClass:nil succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response, NSString *jsonStr) {
        if ([weakself.view respondsToSelector:@selector(getVCodeSuccess:)]) {
            [weakself.view getVCodeSuccess:response];
        }
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response, NSString *jsonStr) {
        [MBProgressHUD showTextDialog:kWindow msg:msg];
    } finishedBlock:^{
        kHiddenHUDAndAvtivity;
    }];
}

- (void)getRoleData
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRoleDataBack:) name:IOSFrameworkWaitingRoleDataNotification object:nil];
    //获取角色信息
    [[CommInterface shareInstance].ueDelegate sendMessagesToUE:@{@"uid":@"1234"}.mj_JSONString type:2 notification:IOSFrameworkWaitingRoleDataNotification];
    kShowHUDAndActivity;
}

- (void)getRoleDataBack:(NSNotification*)notification
{
    kHiddenHUDAndAvtivity;
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"roleData"] == nil) {
        [self toCreatRoleView];
    }else{
        [[TARouter shareInstance] close];
    }
}

- (void)toCreatRoleView
{
    TACmdModel *cmd = [TACmdModel new];
    cmd.cmd = @"creatRole";
    cmd.animated = YES;
    [[TARouter shareInstance] autoTaskWithCmdModel:cmd responseBlock:nil];
}

@end
