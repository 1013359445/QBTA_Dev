//
//  NSBundle+MJImage.h
//  MJImage
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (MJImage)
+ (instancetype)mj_refreshBundle;
+ (UIImage *)mj_ImageWithName:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
