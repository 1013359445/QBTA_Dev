//
//  TABroadcastExtensionLauncher.h
//  TRTC-API-Example-OC
//
//  Created by bluedang on 2021/4/15.
//  Copyright © 2021 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TABroadcastExtensionLauncher : NSObject

+ (instancetype) sharedInstance;
+ (void) launch;

@end

NS_ASSUME_NONNULL_END
