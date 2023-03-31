//
//  TADownloadProgressView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/31.
//

#import "TABaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TADownloadProgressView : TABaseView
- (void)setProgress:(NSNumber *)progress size:(NSNumber *)size;
@end

NS_ASSUME_NONNULL_END
