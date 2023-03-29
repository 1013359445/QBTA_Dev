//
//  NSBundle+TAImage.m
//

#import "NSBundle+TAImage.h"


@implementation NSBundle (TAImage)

+ (UIImage *)ta_ImageWithName:(NSString *)imageName folder:(NSString *)folder
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TABundle" ofType:@"bundle"];
    if (!bundlePath) {
        bundlePath = [[NSBundle mainBundle] pathForResource:@"TABundle" ofType:@"bundle"];
        //bundlePath = [[NSBundle mainBundle] pathForResource:@"IOSFramework.framework/TABundle" ofType:@"bundle"];
    }

    NSString *imagePath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/Images.xcassets/%@/%@.imageset/%@@%dx.png",folder,imageName,imageName,(int)[UIScreen mainScreen].scale]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

+ (NSData *)ta_fileWithBundle:(NSString *)fileName
{
    if (!fileName) fileName = @"";

    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"TABundle" ofType:@"bundle"];
    if (!bundlePath) {
        bundlePath = [[NSBundle mainBundle] pathForResource:@"TABundle" ofType:@"bundle"];
    }
    NSString *filePath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",fileName]];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    return fileData;
}

@end
