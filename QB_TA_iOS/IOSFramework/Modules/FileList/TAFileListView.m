//
//  TAFileListView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/27.
//

#import "TAFileListView.h"

@interface TAFileListView ()
@property (nonatomic, retain)UIImageView *bgView;
@property (nonatomic, retain)UIButton   *closeBtn;
@end

@implementation TAFileListView

+ (NSString *)cmd{
    return @"fileList";
}

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1100), kRelative(570));
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
    self.layer.cornerRadius = kRelative(35);
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;

    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
        
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(12));
        make.right.mas_equalTo(kRelative(-12));
        make.width.height.mas_equalTo(kRelative(66));
    }];
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

#pragma mark - lazy load
-(UIImageView*)bgView
{
    if(!_bgView){
        _bgView = [UIImageView new];
        _bgView.image = kBundleImage(@"frame_view_bg", @"Commom");
        [_bgView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _bgView;
}

-(UIButton       *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
