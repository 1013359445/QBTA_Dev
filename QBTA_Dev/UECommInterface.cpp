//
//  UECommInterface.cpp
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/21.
//

#include "UECommInterface.h"

@implementation CommInterfaceResult
static CommInterfaceResult *_instanceCommInterfaceResult;
+ (CommInterfaceResult *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceCommInterfaceResult = [[self alloc] init];
    });
    return _instanceCommInterfaceResult;
}

- (void)sendMessagesToUE:(NSString * _Nonnull)msg type:(int)type notification:(nullable NSNotificationName)notification
{
    NSLog(@"msg: %@", msg);
    NSLog(@"notification: %@", notification);
    const char *cMsg = [msg cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cNotification = [notification cStringUsingEncoding:NSUTF8StringEncoding];
    
    
    //伪代码，仿照此逻辑 使用UE开发习惯修改
    if(strcmp(cNotification, "login"))
    {
        //根据返回值msg中的登录信息，连接游戏服务器获取角色信息数据
        
//        if("伪代码" == NULL)//有角色信息数据
        if("伪代码" != NULL)//无角色信息数据
        {
            //打开创建角色并监听创建返回
            FIOSFrameworkModule *module = new FIOSFrameworkModule();//可改为单例
            const char *cName = "creatRole";
            const char *cParam = NULL;
            const char *cIdentifier = "creatRole";
            bool animated = true;
            module->showIOSView(cName, cParam, animated , cIdentifier);
        }else{
            //有角色信息
            //...
            //直接进入场景
            //...
            
            //进入场景后调用静态库，显示iOS原生控制面板
            FIOSFrameworkModule *module = new FIOSFrameworkModule();//可改为单例
            const char *cName = "controlPanel";
            const char *cParam = NULL;
            const char *cIdentifier = "controlPanel";
            bool animated = false;
            module->showIOSView(cName, cParam, animated, cIdentifier);
        }
    }else if(strcmp(cNotification, "creatRole"))
    {
        //根据msg返回信息判断，
        //角色创建成功
        //...
        //进入场景
        //...
        //进入场景后调用静态库，显示iOS原生控制面板
        FIOSFrameworkModule *module = new FIOSFrameworkModule();//可改为单例
        const char *cName = "controlPanel";
        const char *cParam = NULL;
        const char *cIdentifier = "controlPanel";
        bool animated = false;
        module->showIOSView(cName, cParam, animated, cIdentifier);
    }
}
@end

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
void FIOSFrameworkModule::showIOSView(const char *name,const char *param, bool animated,const char *identifier)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *ocName = nil;
        if (name != NULL) {
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
}
