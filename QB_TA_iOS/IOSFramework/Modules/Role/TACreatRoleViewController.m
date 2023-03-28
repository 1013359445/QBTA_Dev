//
//  TACreatRoleViewController.m
//  IOSFramework
//
//  Created by 白伟 on 2023/2/21.
//


#import "TACreatRoleViewController.h"
#import "CommInterface.h"
#import "TAPersonalCharacterCell.h"

@interface TACreatRoleViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)UIImageView*       bgImageView;
@property (nonatomic, retain)UIImageView*       roleImageView;
@property (nonatomic, retain)UITextField*       nameTextField;

@property (nonatomic, retain)UILabel*           titleLabel;

@property (nonatomic, retain)UIButton*          confirmBtn;
@property (nonatomic, retain)UICollectionView   *collectionView;
@property (nonatomic, assign)NSInteger          selectIndex;

@end

@implementation TACreatRoleViewController

+ (NSString *)cmd{
    return @"creatRole";
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_HEIGHT * (1680.0f/750.0f));
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
    
    [self.view addSubview:self.roleImageView];
    [self.roleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bgImageView.mas_left).mas_offset(kRelative(300));
        make.bottom.mas_equalTo(kRelative(-75));
        make.width.mas_equalTo(kRelative(190));
        make.height.mas_equalTo(kRelative(600));
    }];

    [self.view addSubview:self.nameTextField];
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.roleImageView.mas_right).mas_offset(kRelative(-40));
        make.top.mas_equalTo(self.roleImageView.mas_top);
        make.width.mas_equalTo(kRelative(200));
        make.height.mas_equalTo(kRelative(70));
    }];

    [self.view addSubview:self.titleLabel];
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
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(730));
        make.right.mas_equalTo(kRelative(-80));
        make.top.mas_equalTo(kRelative(138));
        make.bottom.mas_equalTo(kRelative(-120));
    }];
}

- (void)confirmBtnClick:(UIButton *)sender
{
    if (self.nameTextField.text.length == 0) {
        [TAToast showTextDialog:self.view msg:@"请输入角色名称"];
        return;
    }
    
    NSString *sendStr = @{
                            @"roleid"   :@(self.selectIndex).stringValue,
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    NSString *imgName = [NSString stringWithFormat:@"role_%ld",selectIndex + 1];
    _roleImageView.image = kBundleImage(imgName, @"Role");
    [self.collectionView reloadData];
}

// 点击Item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}

// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAPersonalCharacterCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAPersonalCharacterCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.isSelected = (indexPath.row == _selectIndex);
    cell.image = self.data[indexPath.row];

    return cell;
}

- (NSArray *)data
{
    return @[@"role_head_1",@"role_head_2",@"role_head_3",@"role_head_4",@"role_head_5"];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        // 定义collectionView的样式
        UICollectionViewFlowLayout *myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置属性
        // 给定Item的大小（单元格）
        myFlowLayout.itemSize = CGSizeMake(kRelative(80), kRelative(80));
        // 每两个Item的最小间隙（垂直滚动）
        myFlowLayout.minimumInteritemSpacing = kRelative(50);
        // 每两个Item的最小间隙（水平滚动方向）
        myFlowLayout.minimumLineSpacing = kRelative(50);
        // 设置滚动方向(Vertical垂直方向，horizontal水平方向)
        myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置视图的内边距（逆时针顺序）
        myFlowLayout.sectionInset = UIEdgeInsetsMake(kRelative(4), kRelative(4), kRelative(4), kRelative(4));
        
        // 创建对象，并指定样式
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        // 注册cell
        [_collectionView registerClass:[TAPersonalCharacterCell class] forCellWithReuseIdentifier:@"TAPersonalCharacterCell"];
    }
    return _collectionView;
}
-(UIImageView*)bgImageView
{
    if(!_bgImageView){
        _bgImageView = [UIImageView new];
        _bgImageView.userInteractionEnabled = YES;
        _bgImageView.image = kBundleImage(@"role_bg", @"Role");
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
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

@end
