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
@property (nonatomic, assign)BOOL showEffectView;
@property (nonatomic, copy)TaskFinishBlock taskFinishBlock;
@property (nonatomic, retain)UIVisualEffectView *effectView;
@property (nonatomic, assign)BOOL inAnimateds;

+ (TACmdModel *)cmd;

+ (CGSize)viewSize;

- (void)loadSubViews;
- (void)updateSubViews;

- (void)showView:(UIView *)superView animated:(BOOL)animated;
- (void)hideViewAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
