//
//  TAWebSocket.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TAWebSocketDelegate <NSObject>
@optional
- (void)TAWebSocketDidReceiveMessage:(NSString *)message;
- (void)TAWebSocketDidOpen;
@end

@interface TAWebSocket : NSObject
@property (nonatomic,weak) id <TAWebSocketDelegate> delegate;
- (instancetype)initWithServerIp:(NSString *__nullable)serverIp;
- (void)connectWebSocket;
- (void)closeWebSocket;

- (void)sendMsg:(NSString *)msg;

@end
NS_ASSUME_NONNULL_END
