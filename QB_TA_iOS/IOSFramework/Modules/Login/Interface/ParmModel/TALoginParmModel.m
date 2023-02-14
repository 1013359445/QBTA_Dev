//
//  TALoginParmModel.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import "TALoginParmModel.h"

@implementation TALoginParmModel

- (void)assignDefaultValue
{
    [super assignDefaultValue];
    
    self.version = @"2.0.0.1.121801";
    self.versionType = @"beta";
    self.lang = @"zh_CN";
}

@end
