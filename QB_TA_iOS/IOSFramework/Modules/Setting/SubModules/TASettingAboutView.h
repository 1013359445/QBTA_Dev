//
//  TASettingAboutView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//  关于我们

#import "TABaseView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TASettingAboutViewDelegate <NSObject>
- (void)settingAboutViewDidClickUserAgreement:(NSString *)scheme;
@end

@interface TASettingAboutView : TABaseView
@property (nonatomic, weak)id<TASettingAboutViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
