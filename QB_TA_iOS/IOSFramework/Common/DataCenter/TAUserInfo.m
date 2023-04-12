//
//  TAUserInfo.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TAUserInfo.h"
#import "IOSFramework.h"

@implementation TAUserInfo

- (NSString *)nickname{
    if (!_nickname || _nickname.length == 0)
    {
        NSString *iPhoneName = [UIDevice currentDevice].name;
        NSString *systemVersion = [UIDevice currentDevice].systemVersion;
        CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
        _nickname = [NSString stringWithFormat:@"%@%@%2.f",iPhoneName,systemVersion,batteryLevel];
    }
    return _nickname;
}

@end
