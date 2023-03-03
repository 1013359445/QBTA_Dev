//
//  TAControlPanelView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//

#import "TAControlPanelView.h"
#import "TATopMenuView.h"
#import "TARightMenuView.h"

@interface TAControlPanelView ()
@property (nonatomic, retain)UIImageView        *headImageView;

@property (nonatomic, retain)TATopMenuView      *topMenuView;
@property (nonatomic, retain)TARightMenuView    *rightMenuView;

@end

@implementation TAControlPanelView
+ (NSString *)cmd{
    return @"controlPanel";
}

- (void)loadSubViews
{
    self.userInteractionEnabled = NO;
    [self addSubview:self.headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(kRelative(80));
        make.top.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-60));
    }];
    
    [self addSubview:self.topMenuView];
    [_topMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([TATopMenuView viewSize]);
        make.centerY.mas_equalTo(_headImageView.mas_centerY);
        make.right.mas_equalTo(_headImageView.mas_left).mas_offset(kRelative(-30));
    }];

    [self addSubview:self.rightMenuView];
    [_rightMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([TARightMenuView viewSize]);
        make.centerX.mas_equalTo(_headImageView.mas_centerX);
        make.top.mas_equalTo(_headImageView.mas_bottom).mas_offset(kRelative(30));
    }];

}
#pragma mark - action
- (void)headClick
{
    
}


#pragma mark - lazy load
-(TATopMenuView *)topMenuView{
    if (!_topMenuView){
        _topMenuView = [TATopMenuView new];
    }
    return _topMenuView;
}

-(TARightMenuView *)rightMenuView{
    if (!_rightMenuView){
        _rightMenuView = [TARightMenuView new];
    }
    return _rightMenuView;
}

-(UIImageView        *)headImageView
{
    if (!_headImageView){
        _headImageView = [UIImageView new];
        _headImageView.backgroundColor = [UIColor grayColor];
        _headImageView.layer.cornerRadius = kRelative(40);
        _headImageView.layer.masksToBounds = YES;
        
        UIButton *btn = [UIButton new];
        [_headImageView addSubview:btn];
        [btn addTarget:self action:@selector(headClick) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _headImageView;
}
@end
