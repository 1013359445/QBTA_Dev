//
//  TAAlertViewController.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import <UIKit/UIKit.h>
 
NS_ASSUME_NONNULL_BEGIN
 
@interface TAAlertViewController : UIViewController
 
@property (nonatomic,copy) NSString *viewTitle;
@property (nonatomic,copy) NSString *viewContent;
 
@property (nonatomic,copy) NSString *leftTitle;
@property (nonatomic,copy) NSString *rightTitle;

//点击空白区域是否消失，默认false
@property (nonatomic,assign) BOOL goneTouch;
 
//标题自定义
- (void)configTitleView:(void(^)(UIView *titleView))titleViewConfigBlock;
 
//显示内容自定义
- (void)configContentView:(void(^)(UIView *contentView))contentViewConfigBlock;
 
//Button自定义
- (void)configButtonView:(void(^)(UIView *buttonView))buttonViewConfigBlock;
 
//retrun bool，true自动隐藏  否则不隐藏
- (void)alertActionBlock:(BOOL (^)(NSInteger index))actionBlock;
 
 
//显示
- (void)showInViewController:(UIViewController *)pcontroller;
 
//消失
- (void)dismiss;
@end
 
NS_ASSUME_NONNULL_END

