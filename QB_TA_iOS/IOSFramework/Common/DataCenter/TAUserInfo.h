//
//  TAUserInfo.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import <Foundation/Foundation.h>
#import "TABaseParmModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAUserInfo : TABaseParmModel

@property (nonatomic, copy)NSString *pkid;//"1611305322018619394",
@property (nonatomic, copy)NSString *phone;//"15077833133",
@property (nonatomic, copy)NSString *nickname;//"",
@property (nonatomic, copy)NSString *createTime;//"2023-01-06T18:15:00",
@property (nonatomic, copy)NSString *updateTime;//"2023-01-06T18:15:00",
@property (nonatomic, copy)NSString *openId;//"1334",
@property (nonatomic, copy)NSString *roomName;//"大厅",
@property (nonatomic, assign)BOOL    enterRoom;//false,
@property (nonatomic, assign)BOOL    sendText;//false,
@property (nonatomic, assign)BOOL    admin;//false
@property (nonatomic, assign)int     loginMode;//0,
@property (nonatomic, assign)int     roomId;//0,
@property (nonatomic, assign)int     but;//0,
@property (nonatomic, assign)int     roomNum;//1,
@property (nonatomic, assign)int     createUser;//1,
@property (nonatomic, assign)int     voiceRoomId;//1,

@end

NS_ASSUME_NONNULL_END
