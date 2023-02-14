//
//  NSBundle+TAImage.h
//  TAImage
//
//  Created by MJ Lee on 16/6/13.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (TAImage)
+ (UIImage *)mj_ImageWithName:(NSString *)imageName folder:(NSString *)folder;
@end

NS_ASSUME_NONNULL_END
