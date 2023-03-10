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

//  ASIHTTPRequest 参考代码
//
//+ (ASIHTTPRequest *)GET_Path:(NSString *)path completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    request.requestMethod = @"GET";
//
//    [request setCompletionBlock:^{
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
//        completeBlock(jsonData,request.responseString);
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient GET: %@",[request url]);
//
//    return request;
//}
//
//+ (ASIHTTPRequest *)GET_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
//{
//    NSMutableString *paramsString = [NSMutableString stringWithCapacity:1];
//    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [paramsString appendFormat:@"%@=%@",key,obj];
//        [paramsString appendString:@"&"];
//    }];
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",kAPI_BASE_URL,path,paramsString];
//    urlStr = [urlStr substringToIndex:urlStr.length-1];
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//
//    NSURL *url = [NSURL URLWithString:urlStr];
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    request.requestMethod = @"GET";
//
//    [request setCompletionBlock:^{
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
//        completeBlock(jsonData,request.responseString);
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient GET: %@",[request url]);
//
//    return request;
//}
//
//
//+ (ASIHTTPRequest *)POST_Path:(NSString *)path params:(NSDictionary *)paramsDic completed:(KKCompletedBlock )completeBlock failed:(KKFailedBlock )failed
//{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kAPI_BASE_URL,path];
//    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *url = [NSURL URLWithString:urlStr];
//    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    request.requestMethod = @"POST";
//
//    [paramsDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [request setPostValue:obj forKey:key];
//    }];
//
//    [request setCompletionBlock:^{
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
//        completeBlock(jsonData,request.responseString);
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient POST: %@ %@",[request url],paramsDic);
//
//    return request;
//}
//
//
//+ (ASIHTTPRequest *)DownFile_Path:(NSString *)path writeTo:(NSString *)destination fileName:(NSString *)name setProgress:(KKProgressBlock)progressBlock completed:(ASIBasicBlock)completedBlock failed:(KKFailedBlock )failed
//{
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
//    NSString *filePath = nil;
//    if ([destination hasSuffix:@"/"]) {
//        filePath = [NSString stringWithFormat:@"%@%@",destination,name];
//    }
//    else
//    {
//        filePath = [NSString stringWithFormat:@"%@/%@",destination,name];
//    }
//    [request setDownloadDestinationPath:filePath];
//
//    __block float downProgress = 0;
//    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
//        downProgress += (float)size/total;
//        progressBlock(downProgress);
//    }];
//
//    [request setCompletionBlock:^{
//        downProgress = 0;
//        completedBlock();
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient 下载文件：%@ ",path);
//    kNSLog(@"ASIClient 保存路径：%@",filePath);
//
//    return request;
//}
//
//
//+ (ASIHTTPRequest *)UploadFile_Path:(NSString *)path file:(NSString *)filePath forKey:(NSString *)fileKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed
//{
//
//    NSURL *url = [NSURL URLWithString:path];
//    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setFile:filePath forKey:fileKey];
//    if (params.count > 0) {
//        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [request setPostValue:obj forKey:key];
//        }];
//    }
//
//    __block float upProgress = 0;
//    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
//        upProgress += (float)size/total;
//        progressBlock(upProgress);
//    }];
//
//    [request setCompletionBlock:^{
//        upProgress=0;
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
//        completedBlock(jsonData,[request responseString]);
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient 文件上传：%@ file=%@ key=%@",path,filePath,fileKey);
//    kNSLog(@"ASIClient 文件上传参数：%@",params);
//
//    return request;
//}
//
//
//+ (ASIHTTPRequest *)UploadData_Path:(NSString *)path fileData:(NSData *)fData forKey:(NSString *)dataKey params:(NSDictionary *)params SetProgress:(KKProgressBlock )progressBlock completed:(KKCompletedBlock )completedBlock failed:(KKFailedBlock )failed
//{
//    NSURL *url = [NSURL URLWithString:path];
//    __weak ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    [request setData:fData forKey:dataKey];
//    if (params.count > 0) {
//        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            [request setPostValue:obj forKey:key];
//        }];
//    }
//
//    __block float upProgress = 0;
//    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
//        upProgress += (float)size/total;
//        progressBlock(upProgress);
//    }];
//
//    [request setCompletionBlock:^{
//        upProgress=0;
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:&errorForJSON];
//        completedBlock(jsonData,[request responseString]);
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient 文件上传：%@ size=%.2f MB  key=%@",path,fData.length/1024.0/1024.0,dataKey);
//    kNSLog(@"ASIClient 文件上传参数：%@",params);
//
//    return request;
//}
//
//
//+ (ASIHTTPRequest *)ResumeDown_Path:(NSString *)path writeTo:(NSString *)destinationPath tempPath:(NSString *)tempPath fileName:(NSString *)name setProgress:(KKProgressBlock )progressBlock completed:(ASIBasicBlock )completedBlock failed:(KKFailedBlock )failed
//{
//    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:path]];
//    NSString *filePath = nil;
//    if ([destinationPath hasSuffix:@"/"]) {
//        filePath = [NSString stringWithFormat:@"%@%@",destinationPath,name];
//    }
//    else
//    {
//        filePath = [NSString stringWithFormat:@"%@/%@",destinationPath,name];
//    }
//
//    [request setDownloadDestinationPath:filePath];
//
//    NSString *tempForDownPath = nil;
//    if ([tempPath hasSuffix:@"/"]) {
//        tempForDownPath = [NSString stringWithFormat:@"%@%@.download",tempPath,name];
//    }
//    else
//    {
//        tempForDownPath = [NSString stringWithFormat:@"%@/%@.download",tempPath,name];
//    }
//
//    [request setTemporaryFileDownloadPath:tempForDownPath];
//    [request setAllowResumeForFileDownloads:YES];
//
//    __block float downProgress = 0;
//    downProgress = [[NSUserDefaults standardUserDefaults] floatForKey:@"ASIClient_ResumeDOWN_PROGRESS"];
//    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
//        downProgress += (float)size/total;
//        if (downProgress >1.0) {
//            downProgress=1.0;
//        }
//        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"ASIClient_ResumeDOWN_PROGRESS"];
//        progressBlock(downProgress);
//    }];
//
//    [request setCompletionBlock:^{
//        downProgress = 0;
//        [[NSUserDefaults standardUserDefaults] setFloat:downProgress forKey:@"ASIClient_ResumeDOWN_PROGRESS"];
//        completedBlock();
//        if ([[NSFileManager defaultManager] fileExistsAtPath:tempForDownPath]) {
//            //NSError *errorForDelete = [NSError errorWithDomain:@"删除临时文件发生错误！" code:2015 userInfo:@{@"删除临时文件发生错误": @"中文",@"delete the temp fife error":@"English"}];
//            //[[NSFileManager defaultManager] removeItemAtPath:tempForDownPath error:&errorForDelete];
//            kNSLog(@"l  %d> %s",__LINE__,__func__);
//        }
//    }];
//
//    [request setFailedBlock:^{
//        failed([request error]);
//    }];
//
//    [request startAsynchronous];
//
//    kNSLog(@"ASIClient 下载文件：%@ ",path);
//    kNSLog(@"ASIClient 保存路径：%@",filePath);
//    if (downProgress >0 && downProgress) {
//        if (downProgress >=1.0) downProgress = 0.9999;
//        kNSLog(@"ASIClient 上次下载已完成：%.2f/100",downProgress*100);
//    }
//    return request;
//}
@end
