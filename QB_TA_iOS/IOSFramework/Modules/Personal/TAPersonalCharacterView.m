//
//  TAPersonalCharacterView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAPersonalCharacterView.h"

@interface TAPersonalCharacterView ()
@property (nonatomic, retain)UIImageView        *headImageView;

@end

@implementation TAPersonalCharacterView

- (void)loadSubViews
{
    self.alpha = 0.2;
    self.backgroundColor = [UIColor blueColor];
}

@end
