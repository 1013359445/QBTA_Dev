//
//  TALoginView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import <UIKit/UIKit.h>
#import "TABaseView.h"
#import "TALoginPresenter.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TALoginViewDelegate <NSObject>
- (void)loginViewDidClickUserAgreement:(NSString *)scheme;
@end

@interface TALoginView : TABaseView
@property (nonatomic, weak)id<TALoginViewDelegate> delegate;

@property (nonatomic, retain)TALoginPresenter*  presenter;


- (void)startCountdown;
- (void)agreeBtnSelected;
@end

NS_ASSUME_NONNULL_END
