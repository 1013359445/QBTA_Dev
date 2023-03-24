//
//  TAUserInfo.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TAUserInfo.h"
#import "IOSFramework.h"

@implementation TAUserInfo

- (void)assignDefaultValue
{
    [super assignDefaultValue];
    
    self.nickname = @"张三";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phone = [defaults objectForKey:DefaultsKeyPhoneNumber];
    self.pkid = self.phone ?: @(random() % 999 + 10000).stringValue;
}

@end
