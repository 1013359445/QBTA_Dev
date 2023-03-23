//
//  TADataCenter.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TADataCenter.h"
#import "TAAnnouncementView.h"

@interface TADataCenter ()


@end

@implementation TADataCenter
shareInstance_implementation(TADataCenter);

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.chatMessages = [[NSMutableArray alloc] init];
        self.peopleWhoSpeakArray = [[NSMutableArray alloc] init];
        [self loadPeopleWhoSpeakData];
    }
    return self;
}

- (void)loadPeopleWhoSpeakData
{
    //假数据
    self.userInfo = [[TAUserInfo alloc] init];

    [self addPeopleWhoSpeak:@"张三"];
    [self addPeopleWhoSpeak:@"李四"];
    [self addPeopleWhoSpeak:@"王五"];
    [self addPeopleWhoSpeak:@"老六"];

    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatPeopleWhoSpeakChange object:nil userInfo:nil];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself removePeopleWhoSpeak:@"张三"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatPeopleWhoSpeakChange object:nil userInfo:nil];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself removePeopleWhoSpeak:@"李四"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatPeopleWhoSpeakChange object:nil userInfo:nil];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself removePeopleWhoSpeak:@"王五"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatPeopleWhoSpeakChange object:nil userInfo:nil];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself removePeopleWhoSpeak:@"老六"];
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatPeopleWhoSpeakChange object:nil userInfo:nil];
    });
}

- (void)addPeopleWhoSpeak:(NSString *)name
{
    [self.peopleWhoSpeakArray addObject:name];
}
- (void)removePeopleWhoSpeak:(NSString *)name
{
    NSInteger index = [self.peopleWhoSpeakArray indexOfObject:name];
    if (index >= 0 && index < self.peopleWhoSpeakArray.count) {
        [self.peopleWhoSpeakArray removeObjectAtIndex:index];
    }
}

- (void)addChatMessage:(NSString *)msg
{
    [self.chatMessages addObject:msg];
}

@end
