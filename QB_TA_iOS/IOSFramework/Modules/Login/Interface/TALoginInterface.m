//
//  TALoginInterface.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import "TALoginInterface.h"

@implementation TALoginInterface


shareInstance_implementation(TALoginInterface)

- (NSString *)link{
    NSString *link = @"/user/login";
    return link;
}

@end
