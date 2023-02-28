//
//  TALoginViewProtocol.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import <Foundation/Foundation.h>

@protocol TALoginViewProtocol <NSObject>

- (void)onLoginSuccess:(id)data jsonStr:(NSString *)jsonStr;

- (void)getVCodeSuccess:(id)data;

@end
