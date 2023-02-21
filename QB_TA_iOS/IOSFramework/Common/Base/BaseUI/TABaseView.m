//
//  TABaseView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TABaseView.h"

@implementation TABaseView

+ (CGSize)viewSize
{
    return CGSizeMake(0, 0);
}

- (void)dealloc
{
    
}

- (void)loadSubViews
{
    
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self loadSubViews];
}

@end
