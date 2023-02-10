//
//  TABaseInterface.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import "TABaseInterface.h"

@implementation TABaseInterface 



- (instancetype)init{
    if (self = [super init]) {
        _formRequest = [[ASIFormDataRequest alloc] initWithURL:nil];
    }
    return self;
}

- (void)dealloc
{
    [_formRequest clearDelegatesAndCancel];
}


-(void)requestStarted:(ASIHTTPRequest *)request
{
    //请求開始的时候调用
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //请求完毕的时候调用
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    //请求失败的时候调用
}

@end
