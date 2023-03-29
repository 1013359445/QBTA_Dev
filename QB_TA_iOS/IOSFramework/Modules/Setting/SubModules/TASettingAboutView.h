//
//  TASettingAboutView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//  关于我们

#import "TABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TASettingAboutView : TABaseView

@property (nonatomic, copy)NSString *title;
@property (nonatomic, retain)UITextView *textView;

@end

NS_ASSUME_NONNULL_END
