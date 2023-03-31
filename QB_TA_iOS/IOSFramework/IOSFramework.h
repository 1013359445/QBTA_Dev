//
//  IOSFramework.h
//  IOSFramework
//
//  Created by 白伟 on 2023/1/30.
//

#import <Foundation/Foundation.h>

//! Project version number for IOSFramework.
FOUNDATION_EXPORT double IOSFrameworkVersionNumber;

//! Project version string for IOSFramework.
FOUNDATION_EXPORT const unsigned char IOSFrameworkVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <IOSFramework/PublicHeader.h>
#import <IOSFramework/CommInterface.h>      //原生&UE通信接口

static NSNotificationName const IOSFrameworkWaitingRoleDataNotification = @"getRoleData";
static NSNotificationName const IOSFrameworkCreatRoleRoleNotification = @"creatRoleData";
static NSNotificationName const IOSFrameworkModifyRoleDataNotification = @"modifyRoleData";

static NSNotificationName const DefaultsKeyAgreement = @"DefaultsKeyAgreement";
static NSNotificationName const DefaultsKeyPhoneNumber = @"DefaultsKeyPhoneNumber";
static NSNotificationName const DefaultsKeyPassword = @"DefaultsKeyPassword";
static NSNotificationName const DefaultsKeyLoginMode = @"DefaultsKeyLoginMode";
static NSNotificationName const IOSFrameworkShareScreenStatusChangeNotification = @"ShareScreenStatusChange";
static NSNotificationName const IOSFrameworkLocalAudioStatusChangeNotification = @"LocalAudioStatusChange";

/*
                         iOS & UE 通信协议
 ----------------------------iOS-begin---------------------------
 # 显示iOS原生页面：
 1、 登录页面
 ---页面名称:login
 ---所需参数:无
 ---动画:无

 2、 控制面板
 ---页面名称:controlPanel
 ---所需参数:无
 ---动画:无

 
 # iOS从UE获取数据：
 1、 获取角色信息
 ---msg:{"uid":"1234"}
 ---notification:getRoleData

 2、 创建角色信息
 ---msg:{"roleid":"1、2、3、4、5","name":"张三"}
 ---notification:creatRoleData
 
 3、 更改角色信息
 ---msg:{"roleid":"1、2、3、4、5","name":"张三"}
 ---notification:modifyRoleData

 -----------------------------iOS-end---------------------------
 
 
 
 ----------------------------UE-begin---------------------------
 # 场景转换：
 1、 某场景
 ---场景名称:xxx
 ---所需参数:xxx

 
 -----------------------------UE-end----------------------------
 */
