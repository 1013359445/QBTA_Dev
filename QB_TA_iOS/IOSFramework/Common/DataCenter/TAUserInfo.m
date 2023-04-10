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
    
    NSString *iPhoneName = [UIDevice currentDevice].name;
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    self.nickname = [NSString stringWithFormat:@"%@%@%2.f",iPhoneName,systemVersion,batteryLevel];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phone = [defaults objectForKey:DefaultsKeyPhoneNumber];
    self.roomId = 5981024;
    self.admin = YES;
}

@end
