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
    }
    return self;
}

- (NSMutableArray *)fileList
{
    if (!_fileList){
        _fileList = [NSMutableArray array];
        for (int i = 0; i < 11; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"fileId":@(i),@"fileName":@"文件100",@"progress":@(i*10),@"size":@(100)}];
            [_fileList addObject:dic];
        }
    }
    return _fileList;
}

- (void)downloadWithFileId:(int)fileId
{
    for (NSMutableDictionary *dic in self.fileList) {
        NSNumber *m_id = [dic objectForKey:@"fileId"];
        if (m_id.intValue == fileId){
            if ([self.downloadingFileList indexOfObject:dic] >= 0) {
                return;
            }
            NSNumber *progress = [dic objectForKey:@"progress"];
            NSNumber *size =  [dic objectForKey:@"size"];
            if (progress < size){
                [self.downloadingFileList addObject:dic];
                if (self.isDownloading == NO){
                    [self download];
                }
            }
        }
    }
}

- (void)download{
    self.isDownloading = YES;
    
    for (NSMutableDictionary *dic in self.downloadingFileList) {
        NSNumber *progress = [dic objectForKey:@"progress"];
        progress = @(progress.intValue + 10);
        NSNumber *size =  [dic objectForKey:@"size"];
        if (progress >= size){
            [self.downloadingFileList removeObject:dic];
        }
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
