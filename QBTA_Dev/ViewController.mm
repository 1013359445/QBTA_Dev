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

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.alpha = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XxxxView *iOSView = [[XxxxView alloc] init];
        iOSView.frame = self.view.bounds;
        iOSView.userInteractionEnabled = YES;
        [self.view addSubview:iOSView];
        
        [CommInterface shareInstance].ueDelegate = [CommInterfaceResult shareInstance];
        [CommInterface shareInstance].iOSViewController = self;
        [CommInterface shareInstance].iOSView = iOSView;

        FIOSFrameworkModule *module = new FIOSFrameworkModule();
//        const char *cName = [@"login" cStringUsingEncoding:NSUTF8StringEncoding];
//        const char *cIdentifier = [@"loginBack" cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cName = [@"controlPanel" cStringUsingEncoding:NSUTF8StringEncoding];
        const char *cIdentifier = nil;
        
        const char *cParam = nil;
        bool animated = false;
        module->showIOSView(cName, cParam, animated , cIdentifier);
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.06 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.view.alpha = 1;
    });
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

@end
