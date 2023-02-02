//
//  CommInterface.m
//  QBTAIOSFramework
//
//  Created by 白伟 on 2023/1/28.
//  Copyright © 2023 Epic Games, Inc. All rights reserved.
//

#import "CommInterface.h"
#import "TARouter.h"

@implementation CommInterface

+ (void)showViewWithParam:(NSString *)param baseView:(UIView *)baseView delegate:(id<CommInterfaceDelegate>) delegate
{
    NSLog(@"param:%@",param);
    NSMutableDictionary *parmData = [self convertToDictionary:param];
    [parmData setObject:baseView forKey:@"baseView"];
    
    [[TARouter shareInstance] taskToPageWithParm:parmData successBlock:^(id result) {
        
    } failedBlock:^(id result) {
        
    }];
}

+ (void)showViewWithParam:(NSString *)param controller:(UIViewController *)controller delegate:(id<CommInterfaceDelegate>) delegate
{
    NSLog(@"param:%@",param);
    NSMutableDictionary *parmData = [self convertToDictionary:param];
    [parmData setObject:controller forKey:@"controller"];
    
    [[TARouter shareInstance] taskToPageWithParm:parmData successBlock:^(id result) {
        NSLog(@"success:%@",result);
        
        if (delegate && [delegate respondsToSelector:@selector(iOSResult:)]) {
            [delegate performSelector:@selector(iOSResult:) withObject:result];
        }

    } failedBlock:^(id result) {
        NSLog(@"failed:%@",result);
    }];
}


+ (NSMutableDictionary *)convertToDictionary:(NSString *)jsonStr
{
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
      //解析出错
    }
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    return mutableDictionary;
}

@end
