//
//  TACreatRoleViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/21.
//


#import "TACreatRoleViewController.h"

@interface TACreatRoleViewController ()
@property (nonatomic, retain)UIImageView*       bgImageView;
@property (nonatomic, retain)UIImageView*       roleImageView;

@property (nonatomic, retain)UIButton*          roleHead_1;
@property (nonatomic, retain)UIButton*          roleHead_2;
@property (nonatomic, retain)UIButton*          roleHead_3;
@property (nonatomic, retain)UIButton*          roleHead_4;
@property (nonatomic, retain)UIButton*          roleHead_5;

@property (nonatomic, retain)UIButton*          confirmBtn;
@property (nonatomic, retain)UIButton*          backBtn;

@end

@implementation TACreatRoleViewController

+ (NSString *)cmd{
    return @"creatRole";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)layoutViews
{

}


-(UIImageView*)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [UIImageView new];
    }
    return _bgImageView;
}

-(UIImageView*)roleImageView
{
    if(!_roleImageView){
        _roleImageView = [UIImageView new];
    }
    return _roleImageView;
}

-(UIButton*   )roleHead_1
{
    if(!_roleHead_1){
        _roleHead_1 = [UIButton new];
    }
    return _roleHead_1;
}

-(UIButton*   )roleHead_2
{
    if(!_roleHead_2){
        _roleHead_2 = [UIButton new];
    }
    return _roleHead_2;
}

-(UIButton*   )roleHead_3
{
    if(!_roleHead_3){
        _roleHead_3 = [UIButton new];
    }
    return _roleHead_3;
}

-(UIButton*   )roleHead_4
{
    if(!_roleHead_4){
        _roleHead_4 = [UIButton new];
    }
    return _roleHead_4;
}

-(UIButton*   )roleHead_5
{
    if(!_roleHead_5){
        _roleHead_5 = [UIButton new];
    }
    return _roleHead_5;
}

-(UIButton*   )confirmBtn
{
    if(!_confirmBtn){
        _confirmBtn = [UIButton new];
    }
    return _confirmBtn;
}




@end
