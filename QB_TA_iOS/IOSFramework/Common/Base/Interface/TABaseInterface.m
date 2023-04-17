//
//  TABaseInterface.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import "TABaseInterface.h"

@interface TABaseInterface ()
@end

@implementation TABaseInterface

- (void)dealloc {
}

- (NSString *)domain {
    return DOMAIN_URL;
}

- (NSString *)link{
    return nil;
}

- (NSString *)urlStr {
    NSString * urlStr = [NSString stringWithFormat:@"http://%@",[[self domain] stringByAppendingPathComponent:[self link]]];
    return urlStr;
}

-(void)requestWithParmModel:(TABaseParmModel*)parmModel
             dataModelClass:(nullable Class)dataModelClass
             succeededBlock:(nullable TASucceededBlock)succeededBlock
                failedBlock:(nullable TAFailedBlock) failedBlock
              finishedBlock:(nullable TAFinishedBlock)finishedBlock
{
    self.succeededBlock = succeededBlock;
    self.finishedBlock = finishedBlock;
    self.failedBlock = failedBlock;
    self.dataModelClass = dataModelClass;
        
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:nil];
    request.requestMethod = self.requestMethod;
    
    NSString *urlStr = [self urlStr];
    NSDictionary *pramDic = [parmModel mj_keyValues];
    //添加参数
    if ([self.requestMethod isEqualToString:@"POST"]) {
        for (NSString *key in [pramDic allKeys]) {
            NSString *value = [pramDic objectForKey:key];
            if (value) {
                [request addPostValue:value forKey:key];
            }
        }
    }else if ([self.requestMethod isEqualToString:@"GET"]) {
        NSArray * keys = [pramDic allKeys];
        //拼接参数
        for (int j = 0; j < keys.count; j ++) {
            NSString *key = keys[j];
            NSString *string;
            if (j == 0) {//加？
                string = [NSString stringWithFormat:@"?%@=%@", key, pramDic[key]];
            }else {      //加&
                string = [NSString stringWithFormat:@"&%@=%@", key, pramDic[key]];
            }
            [urlStr stringByAppendingString:string];
        }
        // 对除了这些特殊字符(!$&'()*+-./:;=?@_~%#[])以外的所有字符进行编码
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet   characterSetWithCharactersInString:@"!$&'()*+-./:;=?@_~%#[]"]];
        // 只编码 中文 字符(对所有字符都不进行编码，除了中文)
        //[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@""] invertedSet]];

    }
    [request setURL:[NSURL URLWithString:urlStr]];
    request.delegate = self;
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setResponseEncoding:NSUTF8StringEncoding];
    [request startAsynchronous];
}

- (NSString *)requestMethod
{
    return @"POST";
}


-(void)requestStarted:(ASIHTTPRequest *)request
{
    //请求開始的时候调用
}

-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary *response = [request.responseString mj_JSONObject];
    if (response) {
        int code = [[response objectForKey:@"code"] intValue];
        if (code == 200) {
            TABaseDataModel *dataModel = nil;
            id data = [response objectForKey:@"data"];
            if (data && self.dataModelClass) {
                dataModel = [self.dataModelClass mj_objectWithKeyValues:data];
            }
            //请求成功
            if (self.succeededBlock) {
                self.succeededBlock(dataModel, response, request.responseString);
            }
            [self finished:request];
            return;
        }
    }
    
    //请求失败
    NSString *msg = [response objectForKey:@"msg"];
    if (self.failedBlock) {
        self.failedBlock(msg, response, request.responseString);
    }
    [self finished:request];
}

-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSDictionary *response = [request.responseString mj_JSONObject];
    //请求失败
    NSString *msg = [response objectForKey:@"msg"];
    if (self.failedBlock) {
        self.failedBlock(msg, response, request.responseString);
    }
    [self finished:request];
}

- (void)finished:(ASIHTTPRequest *)request
{
    [request clearDelegatesAndCancel];
    if (self.finishedBlock) {
        self.finishedBlock();
    }
}
@end
