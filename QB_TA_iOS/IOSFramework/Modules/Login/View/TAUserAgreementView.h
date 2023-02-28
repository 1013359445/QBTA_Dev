//
//  TAUserAgreementView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import <UIKit/UIKit.h>
#import "TABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TAUserAgreementViewDelegate <NSObject>

- (void)userAgreementViewDidClickCloseBtn;
- (void)userAgreementViewDidClickOKBtn;

@end

@interface TAUserAgreementView : TABaseView
@property (nonatomic, weak)id<TAUserAgreementViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
