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

+ (TACmdModel *)cmd{return nil;}

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
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:self.cmdModel.animated];
    }else{
        self.cmdModel.animated = NO;
        
        NSMutableArray *vcArray = [NSMutableArray array];
        UIViewController *controller = self;
        int inDo = YES;
        do {
            if (controller.presentingViewController) {
                [vcArray addObject:controller];
                controller = controller.presentingViewController;
            }else{
                inDo = NO;
            }
        } while (inDo);
        
        inDo = YES;
        controller = self;
        do {
            if (controller.presentedViewController) {
                [vcArray insertObject:controller atIndex:0];
                controller = controller.presentedViewController;
            }else{
                inDo = NO;
            }
        } while (inDo);

        for (TABaseViewController *vc in vcArray) {
            if ([vc isKindOfClass:[TABaseViewController class]]) {
                [vc goBack];

            }
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
