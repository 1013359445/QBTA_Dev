//
//  UECommInterface.hpp
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/21.
//

#import <Foundation/Foundation.h>

#import <IOSFramework/IOSFramework.h>
//用于处理 sdk 返回的回调
@interface CommInterfaceResult : NSObject <CommInterfaceDelegate>
+ (CommInterfaceResult *)shareInstance;
@end


class FIOSFrameworkModule
{
public:

    ///----。。。。 显示iOS原生界面
    void showViewWithIOSView(const char *name,const char *param, bool animated,const char *identifier);
    void showPageWithIOSController(const char *name,const char *param, bool animated,const char *identifier);
private:
    void showIOS(const char *name,const char *param, bool animated,const char *identifier, bool page);
};
