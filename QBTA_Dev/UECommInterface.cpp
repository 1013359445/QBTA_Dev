//
//  UECommInterface.cpp
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/21.
//

#include "UECommInterface.h"

//#import "ViewController.h"

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
    NSLog(@"result: %@", msg);
    const char *cString = [msg cStringUsingEncoding:NSUTF8StringEncoding];
    
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

void FIOSFrameworkModule::showPageWithIOSController(const char *name,const char *param, bool animated,const char *identifier)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *ocName = @"";
        if (name != NULL) {
            ocName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        }
        NSString *ocParam = @"";
        if (param != NULL) {
            ocParam = [NSString stringWithCString:param encoding:NSUTF8StringEncoding];
        }
        NSString *ocIdentifier = @"";
        if (identifier != NULL) {
            ocIdentifier = [NSString stringWithCString:identifier encoding:NSUTF8StringEncoding];
        }
        [CommInterface showIOSPageName:ocName param:ocParam animated:animated notification:ocIdentifier];
    });
}


void FIOSFrameworkModule::showViewWithIOSView(const char *name,const char *param, bool animated,const char *identifier)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *ocName = @"";
        if (name != NULL) {
            ocName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        }
        NSString *ocParam = @"";
        if (param != NULL) {
            ocParam = [NSString stringWithCString:param encoding:NSUTF8StringEncoding];
        }
        NSString *ocIdentifier = @"";
        if (identifier != NULL) {
            ocIdentifier = [NSString stringWithCString:identifier encoding:NSUTF8StringEncoding];
        }
        [CommInterface showIOSViewName:ocName param:ocParam animated:animated notification:ocIdentifier];
    });
}
