//
//  TAPersonalPresenter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/7.
//

#import "TALoginViewController.h"
#import "TAPersonalPresenter.h"
#import "TAHeader.h"

@implementation TAPersonalPresenter
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithView:(id)view {
    self = [super initWithView:view];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyRoleDataBack:) name:IOSFrameworkModifyRoleDataNotification object:nil];
    }
    return self;
}

- (void)modifyInfo:(id)param
{
    //修改角色信息
    [[CommInterface shareInstance].ueDelegate sendMessagesToUE:@{@"roleid":@"1234",@"name":@""}.mj_JSONString type:2 notification:IOSFrameworkModifyRoleDataNotification];
    kShowHUDAndActivity;
}

- (void)modifyCharacter:(id)param
{
    //修改角色信息
    [[CommInterface shareInstance].ueDelegate sendMessagesToUE:@{@"roleid":@"1234",@"name":@""}.mj_JSONString type:2 notification:IOSFrameworkModifyRoleDataNotification];
    kShowHUDAndActivity;
}

- (void)modifyRoleDataBack:(NSNotification*)notification
{
    kHiddenHUDAndAvtivity;
    NSDictionary *userInfo = notification.userInfo;
    NSString *msg = [userInfo objectForKey:@"msg"];
    if (msg != nil) {
        [TAToast showTextDialog:kWindow msg:msg];
    }
}


- (void)logOut
{
    //。。。删除用户数据、通知UE登出
    [[TARouter shareInstance] close];

    [[TARouter shareInstance] autoTaskWithCmdModel:[TALoginViewController cmd] responseBlock:nil];
}

@end
