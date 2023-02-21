//
//  TAUserInfoDataModel.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import <Foundation/Foundation.h>
#import "TABaseDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TAUserInfoDataModel : TABaseDataModel
@property (nonatomic, copy)NSString *passwordTab;

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

@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *socketIOClient;
@property (nonatomic, copy)NSString *userType;
@property (nonatomic, copy)NSString *roleName;
@property (nonatomic, copy)NSString *figure;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *enable;
@property (nonatomic, copy)NSString *cuber;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *treasure;
@property (nonatomic, copy)NSString *duration;
@property (nonatomic, copy)NSString *login_time;
@property (nonatomic, copy)NSString *version;
@property (nonatomic, copy)NSString *versionType;
@property (nonatomic, copy)NSString *versionInfo;
@property (nonatomic, copy)NSString *announce;
@property (nonatomic, copy)NSString *announceInfo;
@property (nonatomic, copy)NSString *orgId;
@property (nonatomic, copy)NSString *avatarNum;
@property (nonatomic, copy)NSString *queryParam;
@property (nonatomic, copy)NSString *captcha;
@property (nonatomic, copy)NSString *authBuffer;
@property (nonatomic, copy)NSString *updateUser;
@property (nonatomic, copy)NSString *password;

@end

NS_ASSUME_NONNULL_END
