//
//  TAMemberView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//

#import "TAMemberView.h"
#import "TAAlertViewController.h"

@implementation TAMemberView


+ (NSString *)cmd{
    return @"member";
}

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1256), kRelative(600));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;
    }
    return self;
}

- (void)loadSubViews
{
//    UIAlertViewController *controller = [[UIAlertViewController alloc] init];
//    [controller setTitle:@"温馨提示"];
//    [controller setViewContent:@"alert的提示内容区域"];
//    [controller alertActionBlock:^BOOL(NSInteger index) {
//        return YES;
//    }];
//    [controller showInViewController:self];


}
@end
