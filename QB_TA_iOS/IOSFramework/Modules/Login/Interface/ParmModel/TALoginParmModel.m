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
    
    self.clientType = @1;
    self.version = @"2.2.0";
    self.versionType = @"beta";
    self.lang = @"zh_CN";
}

@end
