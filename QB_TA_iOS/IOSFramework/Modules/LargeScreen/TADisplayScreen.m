//
//  TADisplayScreen.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/17.
//

#import "TADisplayScreen.h"

@implementation TADisplayScreen
+ (CGSize)viewSize
{
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

+ (NSString *)cmd{
    return @"displayScreen";
}

@end
