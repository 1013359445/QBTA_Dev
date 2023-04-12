//
//  TADataCenter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TADataCenter.h"

@interface TADataCenter ()


@end

@implementation TADataCenter
shareInstance_implementation(TADataCenter);

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.microphoneUserList = [[NSMutableArray alloc] init];
        self.chatMessages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addChatMessage:(NSString *)msg
{
    [self.chatMessages addObject:msg];
}

- (void)setMembersList:(NSArray *)membersList
{
    _membersList = membersList;
    for (TAMemberModel *model in membersList) {
        if (model.voice == 2){
            [self.microphoneUserList addObject:model];
        }
        
        if ([model.nickname isEqualToString:self.userInfo.nickname]){
            if ([model.roleName isEqualToString:@"主持人"]){
                self.userInfo.admin = YES;
            }else{
                self.userInfo.admin = NO;
            }
        }
    }
}
@end
