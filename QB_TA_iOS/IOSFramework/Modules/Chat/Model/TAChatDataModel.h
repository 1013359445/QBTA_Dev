//
//  TAChatDataModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/21.
//

#import "TABaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAChatDataModel : TABaseDataModel

@property (nonatomic, copy)NSString *nickname;  //:"成员0002",
@property (nonatomic, copy)NSString *phone;     //:"13900000002",
@property (nonatomic, copy)NSString *datetime;  //:20230420130310,
@property (nonatomic, copy)NSString *content;   //:"⼤家好哇，我是⼩2，新⼈报道~ ! "

@end

NS_ASSUME_NONNULL_END
