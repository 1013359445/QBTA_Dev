//
//  TARouter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TARouter.h"
#import "TABaseViewController.h"
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

- (void)taskToPageWithParm:(NSDictionary*)parm
             successBlock:(TaskFinishBlock)successed
              failedBlock:(TaskFinishBlock)failed
{
    UIViewController *baseVC = [parm objectForKey:@"controller"];
    UIView *baseView = [parm objectForKey:@"baseView"];
    
    NSString *errorStr = @"{\"error\":\"未获取到目标页面\"}";
    NSString *cmd = [parm objectForKey:@"page"];
    if (!cmd) {failed(errorStr);return;}
    Class class = [self.routerDic objectForKey:cmd];
    if (!class) {failed(errorStr);return;};

    if (baseView) {
        
    }else if(baseVC){
        TABaseViewController *vc = [[class alloc] init];
        if (!vc) {failed(errorStr);return;};
        
        NSDictionary *parmdic = [parm objectForKey:@"parms"];
        if (parmdic && [parmdic allKeys].count > 0) {
            vc.params = parmdic;
        }
        
        BOOL animated = [[parm objectForKey:@"animated"] boolValue];

        if (baseVC.navigationController) {
            [baseVC.navigationController pushViewController:vc animated:animated];
        }
        else{
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [baseVC presentViewController:vc animated:animated completion:nil];
        }
        vc.taskFinishBlock = successed;
    }else{
        failed(@"{\"error\":\"未获取到承载页面的父视图\"}");
    }
}

@end
