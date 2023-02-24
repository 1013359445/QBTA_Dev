//
//  UECommInterface.cpp
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/21.
//

#include "UECommInterface.h"

/* UE中首次使用前配置
 #if PLATFORM_IOS
 #endif
 #include "IOSAppDelegate.h"
 dispatch_async(dispatch_get_main_queue(), ^{//UE中调用OC代码需要在主线程执行
     //首次使用前配置
     [CommInterface shareInstance].ueDelegate = [CommInterfaceResult shareInstance];
     [CommInterface shareInstance].iOSController = [IOSAppDelegate GetDelegate].IOSView;
     [CommInterface shareInstance].iOSController = [IOSAppDelegate GetDelegate].IOSController;
 });
 */

@implementation CommInterfaceResult
static CommInterfaceResult *_instanceCommInterfaceResult;
+ (CommInterfaceResult *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceCommInterfaceResult = [[self alloc] init];
    });
    return _instanceCommInterfaceResult;
}

/*  iOS发送信息给UE（UE端实现）
 *  msg 发送内容
 *  type 消息类型     1:iOS回复UE   2:iOS主动调UE
 *  notification    用于找到通知/接收对象
 */
- (void)sendMessagesToUE:(NSString * _Nonnull)msg type:(int)type notification:(nullable NSNotificationName)notification
{
    //转换方式
    const char *cMsg = [msg cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cNotification = [notification cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    if (type == 1){
        //伪代码，仿照此逻辑 使用UE开发习惯修改
        if([notification isEqualToString:@"loginBack"])
        {
            //根据返回值msg(json数据)中的登录信息，连接游戏服务器
            //...
        }
    }else if (type == 2){
        
        FIOSFrameworkModule *module = new FIOSFrameworkModule();//FIOSFrameworkModule可改为单例
        if ([notification isEqualToString:@"getRoleData"]){
            //getRoleData 为 ios请求获取角色信息数据
            
            //正在连接游戏服务器需等连接成功后发送结果
            //...
    //        if("伪代码" == NULL)//有角色信息数据
            if("伪代码" != NULL)//无角色信息数据
            {
                //发送通知
                const char *roleData = "roleData:无角色数据";//JSON数据
                module->callBackToIOS("", cNotification);

            }else{            //有角色信息
                const char *roleData = "roleData:角色数据";//JSON数据
                //发送通知
                module->callBackToIOS(roleData, cNotification);

                //...
                //直接进入场景
                //...
                
                //进入场景后调用静态库，显示iOS原生控制面板
                const char *cName = "controlPanel";
                const char *cIdentifier = "controlPanel";
                bool animated = false;
                module->showIOSView(cName, NULL, animated, cIdentifier);
            }
        }
        else if([notification isEqualToString:@"creatRoleData"])
        {
            //根据msg返回信息创角色
            //...
            //角色创建成功
            const char *roleData = "roleData:角色数据";//JSON数据
            //发送通知
            module->callBackToIOS(roleData, cNotification);

            //...
            //进入场景
            //...
            
            //进入场景后调用静态库，显示iOS原生控制面板
            const char *cName = "controlPanel";
            const char *cIdentifier = "controlPanel";
            bool animated = false;
            module->showIOSView(cName, NULL, animated, cIdentifier);
        }
    }
}
@end


/* 显示iOS视图
 *  name 视图名称
 *  animated 动画
 *  param 参数
 *  identifier    用于找到通知/接收对象。不需要回调可以为空。
 */
void FIOSFrameworkModule::showIOSView(const char *name,const char *param, bool animated,const char *identifier)
{
#if PLATFORM_IOS
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *ocName = nil;
        if (name == NULL) {
            return;
        }else {
            ocName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        }
        NSString *ocParam = nil;
        if (param != NULL) {
            ocParam = [NSString stringWithCString:param encoding:NSUTF8StringEncoding];
        }
        NSString *ocIdentifier = nil;
        if (identifier != NULL) {
            ocIdentifier = [NSString stringWithCString:identifier encoding:NSUTF8StringEncoding];
        }

        [CommInterface showIOSWithName:ocName param:ocParam animated:animated notification:ocIdentifier];
    });
#endif
}

/* UE发送信息给iOS（UE主动调iOS）
 *  msg 发送内容
 *  identifier    用于UE区分iOS回调类型，不需要回调可以为空，值可自定义。
 */
void FIOSFrameworkModule::sendMessagesToIOS(const char *msg, const char *identifier)
{
    this->toIOS(msg, 1, identifier);
}

/* UE发送信息给iOS（UE回复iOS）
 *  msg 发送内容
 *  identifier    用于iOS区分UE通知类型，sendMessagesToUE传过来是什么，原值返回；
 */
void FIOSFrameworkModule::callBackToIOS(const char *msg, const char *identifier)
{
    this->toIOS(msg, 2, identifier);
}

void FIOSFrameworkModule::toIOS(const char *msg, int type, const char *identifier)
{
#if PLATFORM_IOS
   dispatch_async(dispatch_get_main_queue(), ^{
       NSString *ocMsg = nil;
       if (msg == NULL) {
           return;
       }else{
           ocMsg = [NSString stringWithCString:msg encoding:NSUTF8StringEncoding];
       }
       NSString *ocIdentifier = nil;
       if (identifier != NULL) {
           ocIdentifier = [NSString stringWithCString:identifier encoding:NSUTF8StringEncoding];
       }
       [CommInterface sendMessagesToIOS:ocMsg type:2 notification:ocIdentifier];
   });
#endif
}
