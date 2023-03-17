//
//  NSString+Size.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Size)

/**
 * 计算单行文本的高度
 */
-(CGFloat)heightWithLabelFont:(UIFont *)font;
/**
 * 计算多行文本的高度
 */
-(CGFloat)heightWithLabelFont:(UIFont *)font withLabelWidth:(CGFloat)width;
@end
