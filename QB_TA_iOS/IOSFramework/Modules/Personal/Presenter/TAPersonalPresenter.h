//
//  TAPersonalPresenter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/7.
//

#import "TABasePresenter.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAPersonalPresenter : TABasePresenter

- (void)modifyInfo:(id)param;
- (void)modifyCharacter:(id)param;
- (void)logOut;

@end

NS_ASSUME_NONNULL_END
