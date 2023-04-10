//
//  TAFileCollectionViewCell.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TAFileCollectionViewCellProtocol <NSObject>

- (void)cellDidClickDownload:(id)data;

@end

@interface TAFileCollectionViewCell : UICollectionViewCell
@property (nonatomic, retain) NSDictionary *data;

@property (nonatomic, weak)id <TAFileCollectionViewCellProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
