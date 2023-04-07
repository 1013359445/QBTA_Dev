//
//  TAFileManager.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/30.
//

#import "TAFileManager.h"

@interface TAFileManager ()
@property (nonatomic, assign)BOOL isDownloading;
@end

@implementation TAFileManager
shareInstance_implementation(TAFileManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.downloadingFileList = [[NSMutableArray alloc] init];
        self.isDownloading = NO;
        [self fileList];
    }
    return self;
}

- (NSMutableArray *)fileList
{
    if (!_fileList){
        _fileList = [NSMutableArray array];
        for (int i = 0; i < 11; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"fileId":@(i+100),@"fileName":[NSString stringWithFormat:@"文件%d",i+1],@"progress":@(i*10),@"size":@(100),@"downloading":@(0)}];
            [_fileList addObject:dic];
        }
    }
    return _fileList;
}

- (void)downloadWithFileId:(int)fileId
{
    for (NSMutableDictionary *dic in self.fileList) {
        NSInteger index = [self.fileList indexOfObject:dic];
        NSNumber *m_id = [dic objectForKey:@"fileId"];
        if (m_id.intValue == fileId){
            if ([self.downloadingFileList indexOfObject:dic] != NSNotFound) {
                return;
            }
            NSNumber *progress = [dic objectForKey:@"progress"];
            NSNumber *size =  [dic objectForKey:@"size"];
            if (progress.intValue < size.intValue){
                [dic setObject:@(1) forKey:@"downloading"];
                [self.fileList replaceObjectAtIndex:index withObject:dic];
                break;
            }
        }
    }
    
    
    if (self.isDownloading == NO){
        [self download];
    }
}

- (void)download{
    self.isDownloading = YES;
    
    for (NSMutableDictionary *dic in self.fileList) {
        if ([[dic objectForKey:@"downloading"] intValue] == 1)
        {
            if ([self.downloadingFileList indexOfObject:dic] == NSNotFound) {
                [self.downloadingFileList addObject:dic];
            }
        }
    }
    
    NSMutableDictionary *dic = self.downloadingFileList[0];
    NSNumber *progress = [dic objectForKey:@"progress"];
    progress = @(progress.intValue + 10);
    [dic setObject:progress forKey:@"progress"];
    [self.downloadingFileList replaceObjectAtIndex:0 withObject:dic];
    NSNumber *size =  [dic objectForKey:@"size"];
    if (progress.intValue >= size.intValue){

        NSInteger findex = [self.fileList indexOfObject:dic];
        [dic setObject:@(0) forKey:@"downloading"];
        [self.fileList replaceObjectAtIndex:findex withObject:dic];
        [self.downloadingFileList removeObject:dic];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:TAFileManagerDownloadingNotification object:nil userInfo:nil];

    if (self.downloadingFileList.count){
        kWeakSelf(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself download];
        });
    }else{
        self.isDownloading = NO;
    }
}

@end
