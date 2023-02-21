//
//  TACmdModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TACmdModel : NSObject

@property (nonatomic, copy)NSString *cmd;
@property (nonatomic, strong)NSDictionary *param;
@property (nonatomic, assign)BOOL animated;

@end

NS_ASSUME_NONNULL_END
