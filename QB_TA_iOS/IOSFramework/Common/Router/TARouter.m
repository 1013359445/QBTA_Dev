//
//  TARouter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TARouter.h"

#import "CommInterface.h"

#import "TABaseViewController.h"
#import "TABaseView.h"

#import "TALoginViewController.h"
#import "TACreatRoleViewController.h"
#import "TAControlPanelView.h"
#import "TAPersonalView.h"
#import "TASettingView.h"
#import "TAChatView.h"
#import "TADisplayScreen.h"
#import "TARoomListView.h"
#import "TAFileListView.h"
#import "TAMemberView.h"

@interface TARouter ()
@property (nonatomic, retain)NSMutableDictionary    *routerDic;
@property (nonatomic, retain)UIViewController       *controller;

@end

@implementation TARouter

shareInstance_implementation(TARouter)

+ (void)load
{
    [TARouter saveViewIDWithClass:[TALoginViewController class]];
    [TARouter saveViewIDWithClass:[TACreatRoleViewController class]];
    [TARouter saveViewIDWithClass:[TAControlPanelView class]];
    [TARouter saveViewIDWithClass:[TAPersonalView class]];
    [TARouter saveViewIDWithClass:[TASettingView class]];
    [TARouter saveViewIDWithClass:[TAChatView class]];
    [TARouter saveViewIDWithClass:[TADisplayScreen class]];
    [TARouter saveViewIDWithClass:[TARoomListView class]];
    [TARouter saveViewIDWithClass:[TAFileListView class]];
    [TARouter saveViewIDWithClass:[TAMemberView class]];
    
    //新增页面在此处添加代码
    //[TARouter saveViewIDWithClass:[xxxxx class]];
}

+ (void)saveViewIDWithClass:(Class)class
{
    TACmdModel *cmd = (TACmdModel *)[class cmd];
    [[TARouter shareInstance].routerDic setObject:class forKey:cmd.cmd];
}

- (instancetype)init{
    if (self = [super init]) {
        _routerDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)autoTaskWithCmdModel:(TACmdModel*)cmdModel responseBlock:(TaskFinishBlock)response
{
    Class class = [self getClass:cmdModel];
    if (!class) {
        if (response) {
            NSString *errorStr = @"{\"error\":\"未获取到目标视图\"}";
            response(errorStr);
        }
        return;
    }
    
    [self showView:class cmdModel:cmdModel responseBlock:response];
}

- (void)showView:(Class)class cmdModel:(TACmdModel*)cmdModel responseBlock:(TaskFinishBlock)response
{
    if ([class isSubclassOfClass:[TABaseView class]]) {
        TABaseView *view = [[class alloc] init];
        view.taskFinishBlock = response;
        
        UIView *superView = [CommInterface shareInstance].iOSView;
        if (!superView) {
            if (response) {
                NSString *errorStr = @"{\"error\":\"没有可加载视图，尝试给iOSView赋值\"}";
                response(errorStr);
            }
            return;
        }

        [view showView:superView animated:cmdModel.animated];
    }else if ([class isSubclassOfClass:[TABaseViewController class]]) {
        TABaseViewController *vc = [[class alloc] init];
        vc.taskFinishBlock = response;

        UIViewController *currentVC = [self getCurrentVC];
        if (!currentVC) {
            if (response) {
                NSString *errorStr = @"{\"error\":\"没有可加载视图控制器，尝试给iOSViewController赋值\"}";
                response(errorStr);
            }
            return;
        }

        if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:vc animated:cmdModel.animated];
        }else{
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:vc animated:cmdModel.animated completion:nil];
        }
        self.controller = vc;
    }
}

- (Class)getClass:(TACmdModel*)cmdModel{
    NSString *cmd = cmdModel.cmd;
    if (!cmd) {
        return nil;
    }
    Class class = [self.routerDic objectForKey:cmd];
    if (!class) {
        return nil;
    }
    return class;
}

//获取当前屏幕显示的 View Controller
- (UIViewController *)getCurrentVC
{
    if (!_controller) {
        _controller = [CommInterface shareInstance].iOSViewController;
    }
    return _controller;
}

- (void)close
{
    UIViewController *currentVC = [self getCurrentVC];
    if ([currentVC isKindOfClass:[TABaseViewController class]]) {
        [(TABaseViewController *)currentVC close];
        self.controller = nil;
    }else{
        LRLog(@"Controller未继承TABaseViewController");
    }
    
    NSArray *subViews = [[CommInterface shareInstance].iOSView subviews];
    for (UIView *v in subViews) {
        [v removeFromSuperview];
    }
}

@end
