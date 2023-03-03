//
//  TARightMenuView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/27.
//

#import "TARightMenuView.h"

@interface TARightMenuView ()

@end

@implementation TARightMenuView


+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(60), kRelative(600));
}

- (void)loadSubViews
{
    self.backgroundColor = [UIColor colorWithRed:220 green:30 blue:30 alpha:0.2];
}
#pragma mark - lazy load
//-(UIImageView*)frameImageView{
//    if (!_frameImageView){
//        _frameImageView = [UIImageView new];
//        [_frameImageView setImage:kBundleImage(@"frame_white_80", @"Commom")];
//        [_frameImageView setUserInteractionEnabled:YES];
//    }
//    return _frameImageView;
//}

@end
