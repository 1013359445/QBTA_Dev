//
//  TAFileManager.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/30.
//

#import <Foundation/Foundation.h>
#import "TAMacroDefinition.h"//宏定义

NS_ASSUME_NONNULL_BEGIN
static NSNotificationName const TAFileManagerDownloadingNotification = @"TAFileManagerDownloadingNotification";

@interface TAFileManager : NSObject
shareInstance_interface(TAFileManager)

@property (nonatomic, retain)NSMutableArray *fileList;
@property (nonatomic, retain)NSMutableArray *downloadingFileList;

- (void)downloadWithFileId:(int)fileId;

@end

NS_ASSUME_NONNULL_END
