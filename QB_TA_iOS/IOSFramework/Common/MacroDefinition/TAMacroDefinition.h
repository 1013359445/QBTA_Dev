//
//  TAMacroDefinition.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//


#ifndef TAMacroDefinition_h
#define TAMacroDefinition_h

#define kTAColor [TACommonColor shareInstance]

//获取图片资源
#define kBundleImage(imgName,folderName) [NSBundle mj_ImageWithName:imgName folder:folderName]

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000 // 当前Xcode支持iOS8及以上

//屏幕尺寸
#define SCREEN_WIDTH ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)

#define SCREEN_HEIGHT ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)

#define SCREEN_SIZE ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#endif

//判断是否为iPhone
#define IS_IPHONE ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"])
//判断是否为iPad
#define IS_IPAD ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])

//获取系统版本
#define IOS_SYSTEM_STRING [[UIDevice currentDevice] systemVersion]

//判断 iOS 8 或更高的系统版本
#define IOS_VERSION_8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0)? (YES):(NO))

//根据设计图2倍像素自动计算相对逻辑分辨率
#define kRelative(x) x/2.0f*(SCREEN_HEIGHT/375.0f)


#ifdef DEBUG
#define LRLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LRLog(...)
#endif

#define kStrongSelf(type)  __strong typeof(type) type = weak##type;
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;

// 设置加载
#define kNetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
// 加载
#define kShowNetworkActivityIndicator kNetworkActivityIndicatorVisible(YES)
// 收起加载
#define kHideNetworkActivityIndicator kNetworkActivityIndicatorVisible(NO)

#define kWindow [UIApplication sharedApplication].keyWindow

//#define kBackView         for (UIView *item in kWindow.subviews) { \
//if(item.tag == 10000) \
//{ \
//[item removeFromSuperview]; \
//UIView * aView = [[UIView alloc] init]; \
//aView.frame = [UIScreen mainScreen].bounds; \
//aView.tag = 10000; \
//aView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3]; \
//[kWindow addSubview:aView]; \
//} \
//}

#define kShowHUD [MBProgressHUD showHUDAddedTo:kWindow animated:YES]
#define kShowHUDAndActivity kShowHUD;kShowNetworkActivityIndicator;

//#define kRemoveBackView         for (UIView *item in kWindow.subviews) { \
//if(item.tag == 10000) \
//{ \
//[UIView animateWithDuration:0.2 animations:^{ \
//item.alpha = 0.0; \
//} completion:^(BOOL finished) { \
//[item removeFromSuperview]; \
//}]; \
//} \
//}

#define kHiddenHUD [MBProgressHUD hideHUDForView:kWindow animated:YES]
#define kHiddenHUDAndAvtivity kHiddenHUD;kHideNetworkActivityIndicator;


//GCD - 一次性执行
#define kDISPATCH_ONCE_BLOCK(onceBlock) static dispatch_once_t onceToken; dispatch_once(&onceToken, onceBlock);

//GCD - 在Main线程上运行
#define kDISPATCH_MAIN_THREAD(mainQueueBlock) dispatch_async(dispatch_get_main_queue(), mainQueueBlock);

//GCD - 开启异步线程
#define kDISPATCH_GLOBAL_QUEUE_DEFAULT(globalQueueBlock) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), globalQueueBlocl);


#define shareInstance_interface(className) \
+ (className *)shareInstance;
 
#define shareInstance_implementation(className) \
static className *_instance##className; \
+ (className *)shareInstance { \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance##className = [[self alloc] init]; \
    }); \
    return _instance##className; \
}


#endif /* TAMacroDefinition_h */
