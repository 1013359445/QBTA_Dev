//
//  TACreatRoleViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/21.
//


#import "TACreatRoleViewController.h"
#import "CommInterface.h"

NSNotificationName const IOSFrameworkCreatRoleRoleNotification = @"creatRoleData";

@interface TACreatRoleViewController () <UITextFieldDelegate>
@property (nonatomic, retain)UIImageView*       bgImageView;
@property (nonatomic, retain)UIImageView*       roleImageView;
@property (nonatomic, retain)UITextField*       nameTextField;

@property (nonatomic, retain)UILabel*           titleLabel;
@property (nonatomic, retain)UIView*            headSelectShadowView;

@property (nonatomic, retain)UIButton*          confirmBtn;
@property (nonatomic, retain)NSMutableArray*    headBtnArray;

@property (nonatomic, assign)int selectHeadIndex;

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
    [self.view addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.bgImageView addSubview:self.roleImageView];
    [self.roleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView.mas_left).mas_offset(kRelative(300));
        make.bottom.mas_equalTo(kRelative(-75));
        make.width.mas_equalTo(kRelative(190));
        make.height.mas_equalTo(kRelative(600));
    }];

    [self.bgImageView addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roleImageView.mas_right).mas_offset(kRelative(-40));
        make.top.mas_equalTo(self.roleImageView.mas_top);
        make.width.mas_equalTo(kRelative(200));
        make.height.mas_equalTo(kRelative(70));
    }];

    [self.bgImageView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(60));
        make.left.mas_equalTo(kRelative(730));
        make.width.mas_equalTo(kRelative(200));
        make.height.mas_equalTo(kRelative(70));
    }];
    
    [self.view addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(470));
        make.height.mas_equalTo(kRelative(104));
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(-300));
    }];
    
    [self.bgImageView addSubview:self.headSelectShadowView];

    self.headBtnArray = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 5; i++) {
        UIButton *roleHead = [[UIButton alloc] init];
        roleHead.tag = 9000+i;
        NSString *imageName = [NSString stringWithFormat:@"role_head_%d",i];
        [roleHead setImage:kBundleImage(imageName, @"Role") forState:UIControlStateNormal];
        [roleHead addTarget:self action:@selector(roleHeadClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgImageView addSubview:roleHead];

        [roleHead mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(138));
            make.width.height.mas_equalTo(kRelative(96));
            make.left.mas_equalTo(kRelative(730)+kRelative(156)*(i-1));
        }];
        
        [self.headBtnArray addObject:roleHead];
    }
    

    self.selectHeadIndex = 1;
    [self.headSelectShadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(138));
        make.width.height.mas_equalTo(kRelative(96));
        make.left.mas_equalTo(kRelative(730));
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)confirmBtnClick:(UIButton *)sender
{
    if (self.nameTextField.text.length == 0) {
        [TAToast showTextDialog:self.view msg:@"请输入角色名称"];
        return;
    }
    
    NSString *sendStr = @{
                            @"roleid"   :@(self.selectHeadIndex).stringValue,
                            @"name"     :self.nameTextField.text
                        }.mj_JSONString;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatRoleDataBack:) name:IOSFrameworkCreatRoleRoleNotification object:nil];
    //请求创建角色
    [[CommInterface shareInstance].ueDelegate sendMessagesToUE:sendStr type:2 notification:IOSFrameworkCreatRoleRoleNotification];
    kShowHUDAndActivity;
    
    [self.view endEditing:YES];
}

- (void)creatRoleDataBack:(NSNotification*)notification
{
    kHiddenHUDAndAvtivity;
    NSDictionary *userInfo = notification.userInfo;
    if ([userInfo objectForKey:@"roleData"]) {
        [[TARouter shareInstance] close];
    }else{
        [TAToast showTextDialog:kWindow msg:@"创建角色失败"];
    }
}

- (void)roleHeadClick:(UIButton *)sender
{
    [self.view endEditing:YES];

    self.selectHeadIndex = (int)sender.tag-9000;

    [self.headSelectShadowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(730)+kRelative(156)*(self.selectHeadIndex-1));
    }];

    NSString *imageName = [NSString stringWithFormat:@"role_%d",self.selectHeadIndex];
    _roleImageView.image = kBundleImage(imageName, @"Role");
}

-(UIImageView*)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = kBundleImage(@"role_bg", @"Role");
    }
    return _bgImageView;
}

-(UIImageView*)roleImageView
{
    if(!_roleImageView){
        _roleImageView = [UIImageView new];
        _roleImageView.image = kBundleImage(@"role_1", @"Role");
        [_roleImageView setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _roleImageView;
}

-(UITextField*   )nameTextField
{
    if(!_nameTextField){
        _nameTextField = [UITextField new];
        _nameTextField.delegate = self;
        _nameTextField.placeholder = @"请输入ta的名字";
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.textAlignment = NSTextAlignmentCenter;
        _nameTextField.font = [UIFont systemFontOfSize:11];
        _nameTextField.textColor = kTAColor.c_49;
        _nameTextField.frame = CGRectMake(0, 0, kRelative(200), kRelative(70));
        _nameTextField.backgroundColor = [UIColor whiteColor];

        //设置部分圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_nameTextField.bounds
                                                       byRoundingCorners:(UIRectCornerTopLeft |
                                                                          UIRectCornerTopRight |
                                                                          UIRectCornerBottomRight)
                                                             cornerRadii:CGSizeMake(kRelative(35),kRelative(35))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _nameTextField.bounds;
        maskLayer.path = maskPath.CGPath;
        _nameTextField.layer.mask = maskLayer;
    }
    return _nameTextField;
}

-(UIButton*   )confirmBtn
{
    if(!_confirmBtn){
        _confirmBtn = [UIButton new];
        [_confirmBtn setImage:kBundleImage(@"role_confirm_btn", @"Role") forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kTAColor.c_49;
        _titleLabel.text = @"选择形象";
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
    }
    return _titleLabel;
}

-(UIView *)headSelectShadowView{
    if (!_headSelectShadowView) {
        _headSelectShadowView = [[UIView alloc] init];
        UIImageView *shadowImage = [[UIImageView alloc] initWithImage:kBundleImage(@"role_head_s", @"Role")];
        [_headSelectShadowView addSubview:shadowImage];
        [shadowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.centerX.mas_equalTo(0);
            make.height.width.mas_equalTo(kRelative(118));
        }];
        
        UIView *border = [[UIView alloc] init];
        border.backgroundColor = [UIColor clearColor];
        border.layer.borderWidth = kRelative(2);
        border.layer.borderColor = kTAColor.c_49.CGColor;
        border.layer.cornerRadius = kRelative(50);
        [_headSelectShadowView addSubview:border];
        [border mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(-2));
            make.centerX.mas_equalTo(0);
            make.width.height.mas_equalTo(kRelative(100));
        }];
    }
    return _headSelectShadowView;
}
@end
