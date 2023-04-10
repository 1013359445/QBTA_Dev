//
//  TAMemberTableViewCell.h
//  IOSFramework
//
//  Created by 白伟 on 2023/4/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TAMemberTableViewCellProtocol <NSObject>

- (void)cellDidClickKickOut:(id)data;

@end


@interface TAMemberTableViewCell : UITableViewCell
@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign)BOOL mikeEnable;
@property (nonatomic, weak)id  delegate;

@end

NS_ASSUME_NONNULL_END
