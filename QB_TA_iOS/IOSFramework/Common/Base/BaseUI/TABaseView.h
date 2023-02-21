//
//  TABaseView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import "TAHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TABaseView : UIView

+ (CGSize)viewSize;

- (void)loadSubViews;

@end

NS_ASSUME_NONNULL_END
