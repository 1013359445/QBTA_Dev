//
//  TABaseView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/20.
//

#import "TABaseView.h"

@interface TABaseView()
@property (nonatomic, assign)BOOL inAnimateds;

@end

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
        [superView addSubview:self.effectView];
        self.effectView.hidden = YES;

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
    if (_inAnimateds) {
        return;
    }

    self.transform = CGAffineTransformMakeScale(0.3,0.3);
    self.alpha = 0;
    self.effectView.alpha = 0.3;

    kWeakSelf(self);
    _inAnimateds = YES;
    [UIView animateWithDuration:0.2 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //弹入弹出
                     animations:^{
        weakself.transform = CGAffineTransformMakeScale(1,1);
        weakself.alpha = 1;
        weakself.effectView.alpha = 0.9;
    } completion:^(BOOL finished) {
        if (finished)
        {
            weakself.inAnimateds = NO;
        }
    }];
}

- (void)hideViewAnimated:(BOOL)animated
{
    if (!animated) {
        [self.effectView removeFromSuperview];
        [self removeFromSuperview];
        return;
    }
    if (_inAnimateds) {
        return;
    }
    kWeakSelf(self);
    _inAnimateds = YES;
    [UIView animateWithDuration:0.2 //动画时间
                          delay:0 //开始延迟时间
                        options:UIViewAnimationOptionCurveEaseInOut //弹入弹出
                     animations:^{
        weakself.transform = CGAffineTransformMakeScale(0.1,0.1);
        weakself.alpha = 0.1;
        weakself.effectView.alpha = 0.3;
    } completion:^(BOOL finished) {
        if (finished)
        {
            weakself.inAnimateds = NO;
        }
        [weakself.effectView removeFromSuperview];
        [weakself removeFromSuperview];
    }];
}

- (UIVisualEffectView *)effectView
{
    if (!_effectView) {
        // 定义毛玻璃效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
        _effectView.frame = CGRectMake(0,0, 2000, 2000);
        _effectView.alpha = 0.9;
//        UIButton *btn = [[UIButton alloc] initWithFrame:_effectView.bounds];
//        [_effectView.contentView addSubview:btn];
//        [btn addTarget:self action:@selector(effectViewTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _effectView;
}

//- (void)effectViewTouch
//{
//    [self hideViewAnimated:YES];
//}

- (void)showEffectView:(BOOL)show
{
    self.effectView.hidden = !show;
}

@end
