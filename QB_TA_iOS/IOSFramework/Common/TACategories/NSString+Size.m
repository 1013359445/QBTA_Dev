//
//  NSString+Size.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/16.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGFloat)heightWithLabelFont:(UIFont *)font withLabelWidth:(CGFloat)width {
    CGFloat height = 0;

    if (self.length == 0) {
        height = 0;
    } else {
        NSDictionary *attribute = @{NSFontAttributeName:font};
        CGSize rectSize = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                            options:NSStringDrawingTruncatesLastVisibleLine|
                                                    NSStringDrawingUsesLineFragmentOrigin|
                                                    NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
        height = rectSize.height;
    }
    return height;
}

- (CGFloat)heightWithLabelFont:(UIFont *)font {
    CGFloat height = 0;
    if (self.length == 0) {
        height = 0;
    }else{
        CGSize rectSize = [self sizeWithAttributes:@{NSFontAttributeName:font}];
        height = rectSize.height;
    }
    return height;
}

@end
