//
//  TASegmentedControl.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASegmentedControl.h"
#import "TAMacroDefinition.h"//宏定义
#import "Masonry.h"//布局

@implementation TASegmentedControl

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super initWithItems:items];
    if (self) {
        self.frame = CGRectMake(0, 0, kRelative(100), kRelative(80));
    }
    return self;
}

@end
