//
//  UECommInterface.hpp
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/21.
//

#import <Foundation/Foundation.h>

#import <IOSFramework/IOSFramework.h>
//用于处理 IOSFramework 发来的消息
@interface CommInterfaceResult : NSObject <CommInterfaceDelegate>
+ (CommInterfaceResult *)shareInstance;
@end


class FIOSFrameworkModule
{
public:

    /* 显示iOS视图
     *  name 视图名称
     *  animated 动画
     *  param 参数
     *  identifier    用于UE区分回调类型，不需要回调可以为空，值可自定义。
     */
    void showIOSView(const char *name,const char *param, bool animated,const char *identifier);

    /* UE主动调iOS
     *  msg 发送内容
     *  identifier    用于UE区分iOS回调类型，不需要回调可以为空，值可自定义。
     */
    void sendMessagesToIOS(const char *msg, const char *identifier);
    
    /* UE回复iOS
     *  msg 发送内容
     *  identifier    用于iOS区分UE通知类型，sendMessagesToUE:type:notification: 传过来是什么原值返回；
     */
    void callBackToIOS(const char *msg, const char *identifier);

private:
    void toIOS(const char *msg, int type, const char *identifier);
};
