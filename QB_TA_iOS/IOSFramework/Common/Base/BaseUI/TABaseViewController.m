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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册Device Orientation通知
//    self.canRotate = YES;
//    //self.isLandscape = YES;
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

//- (void)deviceOrientationDidChange
//{
//    if (_canRotate) {
//        if([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){//} && !_isLandscape) {
////            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
////            [self orientationChange:NO];
////            //注意： UIDeviceOrientationLandscapeLeft 与 UIInterfaceOrientationLandscapeRight
////        } else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft &&_isLandscape) {
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
//            [self orientationChange:YES];
//        }
//    }
//}
//
//- (void)orientationChange:(BOOL)landscapeRight
//{
//    _canRotate = NO;
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height;
//    if (landscapeRight) {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
//            self.view.bounds = CGRectMake(0, 0, height, width);
//        }];
//    } else {
//        [UIView animateWithDuration:0.2f animations:^{
//            self.view.transform = CGAffineTransformMakeRotation(0);
//            self.view.bounds = CGRectMake(0, 0, width, height);
//        }];
//    }
//}

- (void)goBack
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
