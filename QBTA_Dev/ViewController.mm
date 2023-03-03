//
//  ViewController.m
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/1.
//

#import "ViewController.h"
#import "UECommInterface.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [CommInterface shareInstance].ueDelegate = [CommInterfaceResult shareInstance];
    [CommInterface shareInstance].iOSViewController = self;
    [CommInterface shareInstance].iOSView = self.view;
    
    FIOSFrameworkModule *module = new FIOSFrameworkModule();
//    const char *cName = [@"login" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cName = [@"controlPanel" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cIdentifier = nil;//[@"loginBack" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cParam = nil;
    bool animated = false;
    module->showIOSView(cName, cParam, animated , cIdentifier);
}


@end
