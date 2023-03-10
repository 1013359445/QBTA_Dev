//
//  TASegmentedControl.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TASegmentedControl : UIView
@property (nonatomic, retain)UISegmentedControl *segmented;
- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items;
- (instancetype)initWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
