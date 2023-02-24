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

@interface TARouter ()
@property (nonatomic, retain)NSMutableDictionary    *routerDic;
@end

@implementation TARouter

shareInstance_implementation(TARouter)

+ (void)load
{
    [TARouter saveViewIDWithClass:[TALoginViewController class]];
    [TARouter saveViewIDWithClass:[TACreatRoleViewController class]];
    
    //新增页面在此处添加代码
    //[TARouter saveViewIDWithClass:[xxxxx class]];
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
        view.cmdModel = cmdModel;
        view.taskFinishBlock = response;
        
        UIView *superView = [CommInterface shareInstance].iOSView ?: kWindow;
        [view showView:superView animated:cmdModel.animated];
    }else if ([class isSubclassOfClass:[TABaseViewController class]]) {
        TABaseViewController *vc = [[class alloc] init];
        vc.cmdModel = cmdModel;
        vc.taskFinishBlock = response;

        UIViewController *controller = [CommInterface shareInstance].iOSViewController;
        if (!controller) {
            if (response) {
                NSString *errorStr = @"{\"error\":\"未配置iOSViewController\"}";
                response(errorStr);
            }
            return;
        }
        if (controller.navigationController) {
            [controller.navigationController pushViewController:vc animated:cmdModel.animated];
        }else{
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [controller presentViewController:vc animated:cmdModel.animated completion:nil];
        }
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


@end
