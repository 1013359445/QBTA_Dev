//
//  TARouter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TARouter.h"
#import "TABaseViewController.h"
#import "TABaseView.h"

#import "TALoginViewController.h"

@interface TARouter ()
@property (nonatomic, retain)NSMutableDictionary    *routerDic;
@end

@implementation TARouter

shareInstance_implementation(TARouter)

+ (void)load
{
    [TARouter saveViewIDWithClass:[TALoginViewController class]];
//    [TARouter saveViewIDWithClass:[xxxxx class]];
}

+ (void)saveViewIDWithClass:(Class)class
{
    [[TARouter shareInstance].routerDic setObject:class forKey:[class cmd]];
}

- (instancetype)init{
    if (self = [super init]) {
        _routerDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)taskToPageWithCmdModel:(TACmdModel*)cmdModel
                    controller:(UIViewController *)controller
                 responseBlock:(TaskFinishBlock)response
{
    NSString *errorStr = @"{\"error\":\"未获取到目标页面\"}";
    NSString *cmd = cmdModel.cmd;
    if (!cmd) {
        if (response) {
            response(errorStr);
        }
        return;
    }
    Class class = [self.routerDic objectForKey:cmd];
    if (!class) {
        if (response) {
            response(errorStr);
        }
        return;
    }

    TABaseViewController *vc = [[class alloc] init];
    vc.cmdModel = cmdModel;
    vc.taskFinishBlock = response;

    if (controller.navigationController) {
        [controller.navigationController pushViewController:vc animated:cmdModel.animated];
    }
    else{
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [controller presentViewController:vc animated:cmdModel.animated completion:nil];
    }
}

- (void)taskToViewWithCmdModel:(TACmdModel*)cmdModel
                      baseView:(UIView *)baseView
                 responseBlock:(TaskFinishBlock)response
{
    NSString *errorStr = @"{\"error\":\"未获取到目标视图\"}";
    NSString *cmd = cmdModel.cmd;
    if (!cmd) {
        if (response) {
            response(errorStr);
        }
        return;
    }
    Class class = [self.routerDic objectForKey:cmd];
    if (!class) {
        if (response) {
            response(errorStr);
        }
        return;
    }
    
    TABaseView *view = [[class alloc] init];
    view.cmdModel = cmdModel;
    view.taskFinishBlock = response;

    [view showView:baseView animated:cmdModel.animated];
}

@end
