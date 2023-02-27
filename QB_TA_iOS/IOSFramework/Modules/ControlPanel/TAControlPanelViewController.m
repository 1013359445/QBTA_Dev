//
//  TAControlPanelViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TAControlPanelViewController.h"

@interface TAControlPanelViewController ()

@end

@implementation TAControlPanelViewController

+ (NSString *)cmd{
    return @"controlPane";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)layoutViews
{
}


@end
