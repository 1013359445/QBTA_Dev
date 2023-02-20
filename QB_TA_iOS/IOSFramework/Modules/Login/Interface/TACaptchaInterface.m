//
//  TACaptchaInterface.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/14.
//

#import "TACaptchaInterface.h"

@implementation TACaptchaInterface

shareInstance_implementation(TACaptchaInterface)

- (NSString *)link{
    NSString *link = @"/user/captcha";
    return link;
}
@end
