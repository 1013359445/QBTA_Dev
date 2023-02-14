//
//  NSBundle+TAImage.m
//

#import "NSBundle+TAImage.h"


@implementation NSBundle (TAImage)

+ (UIImage *)mj_ImageWithName:(NSString *)imageName folder:(NSString *)folder
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TABundle" ofType:@"bundle"];
    if (!bundlePath) {
        bundlePath = [[NSBundle mainBundle] pathForResource:@"IOSFramework.framework/TABundle" ofType:@"bundle"];
    }
    
    NSString *imagePath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Images.xcassets/%@/%@.imageset/%@@%dx.png",folder,imageName,imageName,(int)[UIScreen mainScreen].scale]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
