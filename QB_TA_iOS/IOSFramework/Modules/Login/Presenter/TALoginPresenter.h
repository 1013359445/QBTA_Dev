//
//  TALoginPresenter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import "TABasePresenter.h"
#import "TALoginParmModel.h"
#import "TACaptchaParmModel.h"
#import "TALoginViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TALoginPresenter : TABasePresenter <id<TALoginViewProtocol>>

- (void)loginWithParam:(TALoginParmModel *)param;

- (void)getVCodeWithParam:(TACaptchaParmModel *)param;

- (void)getRoleData;


- (NSString *)getDefaultAgreement;
- (NSString *)getDefaultPhoneNumber;
- (NSString *)getDefaultPassword;
- (NSString *)getDefaultLoginMode;
- (void)setDefaultAgreement:(nullable NSString *)value;
- (void)setDefaultPhoneNumber:(nullable NSString *)value;
- (void)setDefaultPassword:(nullable NSString *)value;
- (void)setDefaultLoginMode:(nullable NSString *)value;

@end

NS_ASSUME_NONNULL_END
