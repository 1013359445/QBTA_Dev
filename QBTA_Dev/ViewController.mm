//
//  ViewController.m
//  QBTA_Dev
//
//  Created by 白伟 on 2023/2/1.
//

#import "ViewController.h"
#import "UECommInterface.h"
#import "XxxxView.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    XxxxView *iOSView = [[XxxxView alloc] init];
    iOSView.userInteractionEnabled = YES;
    [self.view addSubview:iOSView];
    iOSView.frame = self.view.bounds;
    
    [CommInterface shareInstance].ueDelegate = [CommInterfaceResult shareInstance];
    [CommInterface shareInstance].iOSViewController = self;
    [CommInterface shareInstance].iOSView = iOSView;
    
    FIOSFrameworkModule *module = new FIOSFrameworkModule();
//    const char *cName = [@"login" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cName = [@"controlPanel" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cIdentifier = nil;//[@"loginBack" cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cParam = nil;
    bool animated = false;
    module->showIOSView(cName, cParam, animated , cIdentifier);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
