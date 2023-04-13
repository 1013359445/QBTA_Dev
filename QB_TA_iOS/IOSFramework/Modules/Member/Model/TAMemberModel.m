//
//  TAMemberModel.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/11.
//

#import "TAMemberModel.h"

@implementation TAMemberModel
- (BOOL)isAdmin
{
    return [_roleName isEqualToString:@"主持人"];
}
@end
