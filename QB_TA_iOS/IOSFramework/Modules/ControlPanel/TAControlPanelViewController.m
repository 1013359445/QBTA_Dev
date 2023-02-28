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

//实时获取角色位置、调整麦克风开关、显示隐藏坐下、小地图位置更新（小地图谁做更方便？）


@end
