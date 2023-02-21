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
