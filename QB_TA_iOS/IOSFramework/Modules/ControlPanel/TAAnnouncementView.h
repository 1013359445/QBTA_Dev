//
//  TAAnnouncementView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//  公告

#import <UIKit/UIKit.h>
#import "TABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAAnnouncementView : TABaseView
shareInstance_interface(TAAnnouncementView);

- (void)addContent:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
