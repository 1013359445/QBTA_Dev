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

NSNotificationName const DefaultsKeyAgreement = @"DefaultsKeyAgreement";
NSNotificationName const DefaultsKeyPhoneNumber = @"DefaultsKeyPhoneNumber";
NSNotificationName const DefaultsKeyPassword = @"DefaultsKeyPassword";
NSNotificationName const DefaultsKeyLoginMode = @"DefaultsKeyLoginMode";

@interface TALoginPresenter ()

@end
@implementation TALoginPresenter

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginWithParam:(TALoginParmModel *)param
{
    kShowHUDAndActivity;
    kWeakSelf(self);
    [[TALoginInterface shareInstance] requestWithParmModel:param dataModelClass:[TAUserInfoDataModel class] succeededBlock:^(TABaseDataModel * _Nonnull dataModel, NSDictionary * _Nonnull response, NSString *jsonStr) {
        
        [self setDefaultPhoneNumber:param.phone];
        if (param.loginMode.integerValue == 0) {
            [self setDefaultPassword:param.password];
        }else{
            [self setDefaultPassword:nil];
        }
        [self setDefaultLoginMode:param.loginMode];

        if ([weakself.view respondsToSelector:@selector(onLoginSuccess:jsonStr:)]) {
            [weakself.view onLoginSuccess:dataModel jsonStr:jsonStr];
        }
    } failedBlock:^(NSString * _Nonnull msg, NSDictionary * _Nonnull response, NSString *jsonStr) {
        [TAToast showTextDialog:kWindow msg:msg];
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
        [TAToast showTextDialog:kWindow msg:msg];
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

- (NSString *)getDefaultAgreement
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DefaultsKeyAgreement];
}

- (NSString *)getDefaultPhoneNumber
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DefaultsKeyPhoneNumber];
}

- (NSString *)getDefaultPassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DefaultsKeyPassword];
}

- (NSString *)getDefaultLoginMode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:DefaultsKeyLoginMode];
}

- (void)setDefaultAgreement:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:DefaultsKeyAgreement];
}

- (void)setDefaultPhoneNumber:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:DefaultsKeyPhoneNumber];
}

- (void)setDefaultPassword:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:DefaultsKeyPassword];
}

- (void)setDefaultLoginMode:(NSString *)value
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:DefaultsKeyLoginMode];
}


@end
