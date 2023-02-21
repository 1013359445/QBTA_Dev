//
//  ViewController.m
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/1.
//

#import "ViewController.h"

@interface ViewController () <CommInterfaceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    ///....。。。。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UECommInterface *UE = [[UECommInterface alloc] init];
        [CommInterface showPageName:@"login" controller:self param:nil animated:NO delegate:UE];
    });
}

- (IBAction)toLogin:(id)sender {
    UECommInterface *UE = [[UECommInterface alloc] init];
    [CommInterface showPageName:@"login" controller:self param:nil animated:YES delegate:UE];
}

@end


@implementation UECommInterface

///....。。。。
- (void)iOSResult:(nonnull NSString *)result {
    
}

@end

