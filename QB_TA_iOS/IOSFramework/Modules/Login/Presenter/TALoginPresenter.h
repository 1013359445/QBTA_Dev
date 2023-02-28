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

@end

NS_ASSUME_NONNULL_END
