//
//  TABaseView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TABaseView.h"

@implementation TABaseView

+ (NSString *)cmd{return nil;}

+ (CGSize)viewSize
{
    return SCREEN_SIZE;
}

- (void)dealloc
{
    
}

- (void)loadSubViews
{
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    [self loadSubViews];
}


- (void)showView:(UIView *)superView animated:(BOOL)animated
{
    if (self.superview) {
        return;
    }else {
        [superView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([[self class] viewSize].width);
            make.height.mas_equalTo([[self class] viewSize].height);
            make.center.mas_offset(0);
        }];
    }
    if (!animated) {
        return;
    }
    
    self.transform = CGAffineTransformMakeScale(0.3,0.3);
    self.alpha = 0;

    [UIView animateWithDuration:0.2 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //弹入弹出
                     animations:^{
        self.transform = CGAffineTransformMakeScale(1,1);
        self.alpha = 1;
    } completion:^(BOOL finished) {
    }];
}

- (void)hideViewAnimated:(BOOL)animated
{
    if (!animated) {
        [self removeFromSuperview];
        return;
    }

    [UIView animateWithDuration:0.2 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //弹入弹出
                     animations:^{
        self.transform = CGAffineTransformMakeScale(0,0);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        // 定义毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        _effectView.frame = CGRectMake(0,0, [[self class] viewSize].width, [[self class] viewSize].height);
        _effectView.alpha = 0.8;
        [self addSubview:_effectView];
    }
    return _effectView;
}
- (void)showEffectView:(BOOL)show
{
    self.effectView.hidden = !show;
}

@end
