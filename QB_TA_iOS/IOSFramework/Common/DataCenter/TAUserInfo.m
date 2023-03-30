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
    
    NSArray *name =  @[@"杜子藤",@"沈京兵",@"庞光大",@"杜琦燕",@"焦厚根",@"曾桃燕",@"史珍香",@"胡丽晶",@"熊初墨",@"项洁雯",@"陶仁燕",@"梅良鑫",@"尤勇驰",@"范闲",@"范建"];
    self.nickname = name[random() % 14];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phone = [defaults objectForKey:DefaultsKeyPhoneNumber];
    self.roomId = 100001;
}

@end
