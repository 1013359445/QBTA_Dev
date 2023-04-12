//
//  TAMemberTableViewCell.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/7.
//

#import <UIKit/UIKit.h>
#import "TAMemberModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TAMemberTableViewCellProtocol <NSObject>

- (void)cellDidClickKickOut:(TAMemberModel *)data;
- (void)cellDidClickMikeStatet:(TAMemberModel *)data;

@end


@interface TAMemberTableViewCell : UITableViewCell

@property (nonatomic, retain)TAMemberModel *data;
@property (nonatomic, weak)id  delegate;

@end

NS_ASSUME_NONNULL_END
