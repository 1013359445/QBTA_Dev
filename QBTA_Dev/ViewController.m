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
    // Do any additional setup after loading the view.
    

}

- (IBAction)toLogin:(id)sender {
    NSString *param = @"{\"page\":\"login\",\"parms\":{},\"animated\":0}";
    [CommInterface showViewWithParam:param controller:self delegate:self];
}

- (void)iOSResult:(nonnull NSString *)result {
    
}


@end
