//
//  NSBundle+MJImage.m
//  MJImage
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "NSBundle+MJImage.h"
//#import "MJImageComponent.h"
//#import "MJImageConfig.h"

static NSBundle *mj_defaultI18nBundle = nil;
static NSBundle *mj_systemI18nBundle = nil;

@implementation NSBundle (MJImage)
+ (instancetype)mj_refreshBundle
{
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        NSBundle *containnerBundle = [NSBundle bundleForClass:[self class]];
        refreshBundle = [NSBundle bundleWithPath:[containnerBundle pathForResource:@"MJImage" ofType:@"bundle"]];
    }
    return refreshBundle;
}

+ (UIImage *)mj_ImageWithName:(NSString *)imageName
{
    return nil;
}

@end
