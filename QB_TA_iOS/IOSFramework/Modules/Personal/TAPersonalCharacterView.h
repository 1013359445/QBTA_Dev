//
//  TAPersonalCharacterView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TABaseView.h"
#import "TAPersonalPresenter.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TAPersonalCharacterViewDelegate <NSObject>

- (void)changeCharacter:(id)character;

@end

@interface TAPersonalCharacterView : TABaseView

@property (nonatomic, retain)TAPersonalPresenter     *presenter;
@property (nonatomic, weak)id<TAPersonalCharacterViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
