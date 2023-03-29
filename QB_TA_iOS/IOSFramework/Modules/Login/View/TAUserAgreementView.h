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
@property (nonatomic, assign)BOOL hiddenBottom;

- (void)setTitle:(NSString *)title ContentText:(NSString *)content;
- (void)setAttributedContent:(NSAttributedString *)attributedString;
- (void)setAttributedContentWithHTML:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
