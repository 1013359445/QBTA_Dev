//
//  TABaseViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/1.
//

#import "TABaseViewController.h"

@interface TABaseViewController ()
@property (nonatomic, assign)BOOL canRotate;
//@property (nonatomic, assign)BOOL isLandscape;
@end

@implementation TABaseViewController

+ (NSString *)cmd{return nil;}

- (void)goBack
{
    BOOL animated = self.cmdModel.animated;
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:animated];
    }else{
        [self dismissViewControllerAnimated:animated completion:nil];
    }
}

- (void)close
{
    BOOL animated = self.cmdModel.animated;
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:animated];
    }else{
        UIViewController *controller = self;
        int num = 0;
        int inDo = YES;
        do {
            if (controller.presentingViewController) {
                num++;
                controller = controller.presentingViewController;
            }else{
                inDo = NO;
            }
        } while (inDo);
        
        inDo = YES;
        controller = self;
        do {
            if (controller.presentedViewController) {
                num++;
                controller = controller.presentedViewController;
            }else{
                inDo = NO;
            }
        } while (inDo);

        for (int i = 0; i < num; i++) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

@end
