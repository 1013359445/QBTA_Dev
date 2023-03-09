//
//  TASettingBasicsView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASettingBasicsView.h"
#import "TATextFieldView.h"

@interface TASettingBasicsView ()

@property (nonatomic, retain)TATextFieldView    *bgImageView;
@property (nonatomic, retain)TATextFieldView    *closeBtn;

@end

@implementation TASettingBasicsView

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(816), kRelative(410));
}

- (void)loadSubViews
{
}

@end
