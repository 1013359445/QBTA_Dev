//
//  TAAlertViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/6.
//
#define deviceHeight [UIScreen mainScreen].bounds.size.height
 
#define deviceWidth [UIScreen mainScreen].bounds.size.width
 
#import "TAAlertViewController.h"
#import "TAMacroDefinition.h"
#import "TACommonColor.h"
#import "UIButton+JKBlock.h"

typedef void (^titleViewConfigBlock)(UIView *aview);
 
typedef BOOL (^actionIndexBlock)(NSInteger index);
 
@interface TAAlertViewController ()
{
    UIView *alertView;
}
 
@property (nonatomic,copy) titleViewConfigBlock titleConfigBlock;
 
@property (nonatomic,copy) titleViewConfigBlock contentConfigBlock;
 
@property (nonatomic,copy) titleViewConfigBlock buttonConfigBlock;
 
@property (nonatomic,copy) actionIndexBlock actionBlock;
@end
 
@implementation TAAlertViewController
@synthesize viewTitle,viewContent,titleConfigBlock,contentConfigBlock,actionBlock,buttonConfigBlock;
 
- (instancetype)init
{
    self = [super init];
    if (self)
    {
//        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    }
    return self;
}
 
 
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 0, deviceWidth, deviceHeight);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:frame];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    CGFloat ht = 160;
    frame = CGRectMake(52, (deviceHeight-ht)/2, self.view.frame.size.width-104, ht);
    alertView = [[UIView alloc]initWithFrame:frame];
    [alertView setBackgroundColor:[UIColor whiteColor]];
    [alertView.layer setMasksToBounds:YES];
    [alertView.layer setCornerRadius:8];
    [self.view addSubview:alertView];
    
    frame = CGRectMake(0, 14, frame.size.width, 40);
    if (self.titleConfigBlock)
    {
        UIView *tview = [[UIView alloc] initWithFrame:frame];
        [alertView addSubview:tview];
        self.titleConfigBlock(tview);
        frame = tview.frame;
#if __has_feature(objc_arc)
#else
        [tview release];
#endif
    }
    else
    {
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:viewTitle?viewTitle:@""];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont boldSystemFontOfSize:19]];
        [label setTextColor:[UIColor darkTextColor]];
        [alertView addSubview:label];
#if __has_feature(objc_arc)
#else
        [label release];
#endif
    }
    
    frame.origin.y += frame.size.height;
    frame.size.height = ht - 54 - frame.origin.y;
    if (self.contentConfigBlock)
    {
        UIView *cview = [[UIView alloc] initWithFrame:frame];
        [alertView addSubview:cview];
        self.contentConfigBlock(cview);
        frame = cview.frame;
#if __has_feature(objc_arc)
#else
        [cview release];
#endif
    }
    else
    {
        UILabel *label =[[UILabel alloc] initWithFrame:frame];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:viewContent?viewContent:@""];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:15]];
        [label setTextColor:kTAColor.c_49];
        [alertView addSubview:label];
#if __has_feature(objc_arc)
#else
        [label release];
#endif
    }
    ht = frame.origin.y+frame.size.height+54;
    frame = alertView.frame;
    frame.size.height = ht;
    [alertView setFrame:frame];
    
    CGRect rect = CGRectMake(0, ht-54, alertView.frame.size.width, 0.5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [alertView addSubview:imageView];
#if __has_feature(objc_arc)
#else
    [imageView release];
#endif
    if (self.buttonConfigBlock)
    {
        CGRect fm = CGRectMake(0, ht-54, rect.size.width,54);
        UIView *bview = [[UIView alloc] initWithFrame:fm];
        [alertView addSubview:bview];
        self.buttonConfigBlock(bview);
        frame = bview.frame;
#if __has_feature(objc_arc)
#else
        [bview release];
#endif
        ht = frame.origin.y+frame.size.height;
        frame = alertView.frame;
        frame.size.height = ht;
        [alertView setFrame:frame];
    }
    else
    {
        NSString *title = self.leftTitle ?: @"取消";
        CGRect fm = CGRectMake(kRelative(30), ht-kRelative(60 + 30), rect.size.width/2 - kRelative(80),kRelative(60));
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:fm];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [button setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        button.layer.cornerRadius = kRelative(30);
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = kTAColor.c_49.CGColor;
        button.layer.masksToBounds = YES;
        button.backgroundColor = kTAColor.c_F0;
        
        [button jk_addActionHandler:^(NSInteger tag) {
            if (self.actionBlock)
            {
                if (self.actionBlock(0))
                {
                    [self dismiss];
                }
            }
        }];

        [alertView addSubview:button];
        
        title = self.rightTitle ?: @"确定";
        fm.origin.x += (fm.size.width + kRelative(20));
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:fm];
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
        [button setTitleColor:kTAColor.c_F0 forState:UIControlStateNormal];
        button.layer.cornerRadius = kRelative(30);
        button.layer.masksToBounds = YES;
        button.backgroundColor = kTAColor.c_49;

        [button jk_addActionHandler:^(NSInteger tag) {
            if (self.actionBlock)
            {
                if (self.actionBlock(1))
                {
                    [self dismiss];
                }
            }
        }];
        [alertView addSubview:button];
        
        fm.size.width = 0.5;
        fm.size.height = alertView.frame.size.height-fm.origin.y;
        imageView = [[UIImageView alloc] initWithFrame:fm];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [alertView addSubview:imageView];
    #if __has_feature(objc_arc)
    #else
        [imageView release];
    #endif
    }
}
 
 
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
//    CGRect frame = alertView.frame;
    
//    BOOL NS_IPHONE_X = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom>0;
//    frame.origin.y = deviceHeight-frame.size.height-(NS_IPHONE_X?34:0);
//    [UIView animateWithDuration:0.25 delay:0 options:0 animations:^
//    {
//        [self->alertView setFrame:frame];
//    }
//    completion:^(BOOL finished)
//    {
//
//    }];
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    [alertView.layer addAnimation:animation forKey:@"animationAlertKey"];
}
 
 
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
 
 
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
 
- (void)dealloc
{
#if __has_feature(objc_arc)
#else
    [viewTitle release];
    [viewContent release];
    [titleConfigBlock release];
    [contentConfigBlock release];
    [actionBlock release];
    [buttonConfigBlock release];
    
    [super dealloc];
#endif
}
 
 
#pragma mark - otherMethod
//标题自定义
- (void)configTitleView:(void(^)(UIView *titleView))block
{
    [self setTitleConfigBlock:block];
}
 
//显示内容自定义
- (void)configContentView:(void(^)(UIView *contentView))block
{
    [self setContentConfigBlock:block];
}
 
 
//Button自定义
- (void)configButtonView:(void(^)(UIView *buttonView))block
{
    [self setButtonConfigBlock:block];
}
 
 
- (void)alertActionBlock:(BOOL (^)(NSInteger index))block
{
    [self setActionBlock:block];
}
 
- (void)showInCurrentVC
{
    [self showInViewController:[[TARouter shareInstance] getCurrentVC]];
}

- (void)showInViewController:(UIViewController *)pcontroller
{
    UIViewController *rootController = pcontroller.tabBarController?pcontroller.tabBarController:pcontroller;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    [rootController presentViewController:self animated:YES completion:nil];
//    [rootController presentViewController:self animated:YES completion:^
//    {
////        self.view.backgroundColor = RGBA(0, 0, 0, 0.4);
//    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self->alertView.transform=CGAffineTransformMakeScale(0.0001, 0.0001);
    } completion:^(BOOL finished) {
        
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    /*CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.15;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeBackwards;
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    [alertView.layer addAnimation:animation forKey:@"animationAlertKey"];
    [self dismissViewControllerAnimated:YES completion:nil];*/
}
 
- (void)cancelAction
{
    if (self.goneTouch)
    {
//        CGRect frame = alertView.frame;
//        frame.origin.y = deviceHeight;
//        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^
//        {
//            [self->alertView setFrame:frame];
//            [self.view setBackgroundColor:RGBA(0, 0, 0, 0)];
//        }
//        completion:^(BOOL finished)
//        {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }];
        [UIView animateWithDuration:0.25 animations:^{
            self->alertView.transform=CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}
@end

