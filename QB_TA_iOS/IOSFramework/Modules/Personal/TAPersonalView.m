//
//  TAPersonalView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAPersonalView.h"
#import "TAPersonalInfoView.h"
#import "TAPersonalCharacterView.h"

@interface TAPersonalView ()
@property (nonatomic, retain)UIImageView             *imageView;
@property (nonatomic, retain)TAPersonalInfoView      *personalInfoView;
@property (nonatomic, retain)TAPersonalCharacterView *personalCharacterView;

@end

@implementation TAPersonalView

+ (NSString *)cmd{
    return @"personal";
}

- (void)loadSubViews
{
    [self showEffectView:YES];

//    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
}


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        [self hideViewAnimated:YES];
        return nil;
    }else if(hitView == self.effectView){
        [self hideViewAnimated:YES];
        return nil;
    }
    return hitView;
}


-(UIImageView             *)imageView
{
    if (!_imageView){
        _imageView = [UIImageView new];
    }
    return _imageView;
}

-(TAPersonalInfoView      *)personalInfoView
{
    if (!_personalInfoView){
        _personalInfoView = [TAPersonalInfoView new];
    }
    return _personalInfoView;
}

-(TAPersonalCharacterView *)personalCharacterView
{
    if (!_personalCharacterView){
        _personalCharacterView = [TAPersonalCharacterView new];
    }
    return _personalCharacterView;
}
@end
