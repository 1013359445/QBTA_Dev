//
//  ViewController.m
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/1.
//

#import "ViewController.h"
#import <IOSFramework/IOSFramework.h>

@interface ViewController () <CommInterfaceDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    ///....。。。。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *param = @"{\"page\":\"login\",\"parms\":{},\"animated\":0}";
        [CommInterface showViewWithParam:param controller:self delegate:self];
    });
}

- (IBAction)toLogin:(id)sender {
    NSString *param = @"{\"page\":\"login\",\"parms\":{},\"animated\":0}";
    [CommInterface showViewWithParam:param controller:self delegate:self];
}

///....。。。。
- (void)iOSResult:(nonnull NSString *)result {
    
}


@end
