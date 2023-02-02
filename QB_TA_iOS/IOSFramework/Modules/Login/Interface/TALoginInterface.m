//
//  TALoginInterface.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/2.
//

#import "TALoginInterface.h"

@implementation TALoginInterface


shareInstance_implementation(TALoginInterface)

- (void)loginWithParmModel:(TABaseParmModel*)parmModel
   dataModelClass:(Class)dataModelClass
    finishedBlock:(TAFinishedBlock)finishedBlock
      failedBlock:(TAFailedBlock) failedBlock
{
    [self.formRequest setURL:[self url]];
    
    [self.formRequest addPostValue:@"18062702197" forKey:@"phone"];
    [self.formRequest addPostValue:@"test123456" forKey:@"password"];
    [self.formRequest addPostValue:@"2.0.0.1.121801" forKey:@"version"];
    [self.formRequest addPostValue:@"beta" forKey:@"versionType"];
    [self.formRequest addPostValue:@"zh_CN" forKey:@"lang"];

    self.formRequest.delegate = self;
    
    self.finishedBlock = finishedBlock;
    self.failedBlock = failedBlock;
    self.dataModelClass = dataModelClass;
    
    [self.formRequest startAsynchronous];
}

- (NSURL *)url{
    NSString *link = @"/user/login";
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",DOMAIN_URL,link]];
    return url;
}

- (void)get{
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    // HTTP method to use (eg: GET / POST / PUT / DELETE / HEAD etc). Defaults to GET
//    request.requestMethod = @"GET";
//    [request startAsynchronous];
//    [request setDelegate:self];//设置托付
}

-(void)requestStarted:(ASIHTTPRequest *)request
{
    //请求開始的时候调用
}
-(void)requestFinished:(ASIHTTPRequest *)request
{
    //请求完毕的时候调用
    TABaseDataModel *dataModel = [self.dataModelClass mj_objectWithKeyValues:request.responseString];

    self.finishedBlock(dataModel, [request.responseString mj_JSONObject]);
}
-(void) requestFailed:(ASIHTTPRequest *)request
{
    self.failedBlock(@{});
    //请求失败的时候调用
}

@end
