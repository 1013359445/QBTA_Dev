//
//  TAControlPanelView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import "TAControlPanelView.h"

@implementation TAControlPanelView
+ (NSString *)cmd{
    return @"controlPanel";
}

- (void)loadSubViews
{
    self.userInteractionEnabled = NO;
    [self setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.5]];
}

@end
