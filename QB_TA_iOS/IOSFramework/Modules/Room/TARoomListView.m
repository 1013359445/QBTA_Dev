//
//  TARoomListView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/27.
//

#import "TARoomListView.h"
#import "TARoomManager.h"
#import "TARoomCollectionViewCell.h"

@interface TARoomListView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)UIImageView *bgView;
@property (nonatomic, retain)UIButton   *closeBtn;
@property (nonatomic, retain)UICollectionView *collectionView;

@property (nonatomic, retain)UIButton   *enterBtn;
@property (nonatomic, retain)UIButton   *typeBtn;
@property (nonatomic, retain)UIView     *typeView;
@property (nonatomic, assign)int        type;

@end

@implementation TARoomListView

+ (NSString *)cmd{
    return @"mapList";
}

+ (CGSize)viewSize
{
//    return CGSizeMake(kRelative(1100), kRelative(570));
    return CGSizeMake(kRelative(1256), kRelative(600));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = 0;
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
    
    [self.bgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(100));
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [self addSubview:self.enterBtn];
    [self.enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-88));
        make.width.mas_equalTo(kRelative(178));
        make.height.mas_equalTo(kRelative(54));
    }];
    
    [self addSubview:self.typeBtn];
    [self.typeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_enterBtn.mas_centerY);
        make.left.mas_equalTo(kRelative(30));
        make.width.mas_equalTo(kRelative(244));
    }];
    
    [self addSubview:self.typeView];
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kRelative(26));
        make.top.mas_equalTo(kRelative(90));
        make.width.mas_equalTo(kRelative(232));
        make.height.mas_equalTo(kRelative(192));
    }];
}

-(void)typeBtnClick:(UIButton *)sender
{
    self.typeView.hidden = sender.selected;
    sender.selected = !sender.isSelected;
}

-(void)filterBtnClick:(UIButton *)sender
{
    self.typeView.hidden = YES;
    self.typeBtn.selected = NO;

    self.type = (int)sender.tag;
    [self.collectionView reloadData];
}

-(void)enterBtnClick
{
    //快速加入活动房间
    //提示”退出当前场景并加入其他活动场景？“
    NSArray *allData = [self dataWithType:0];
    NSInteger randomIndex = random() % allData.count;
    NSDictionary *randomItem = allData[randomIndex];
    int roomId = [[randomItem objectForKey:@"roomId"] intValue];
    if ([TADataCenter shareInstance].userInfo.roomId == roomId){
        if (allData.count > 1){
            [self enterBtnClick];
        }
        return;
    }
    [self enterRomeWithRomeId:roomId];
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

-(void)enterRomeWithRomeId:(int)roomId
{
    [TADataCenter shareInstance].userInfo.roomId = roomId;
    [[TARoomManager shareInstance] changeRomeWithRomeId:roomId];
    
    [self.collectionView reloadData];
    
    kWeakSelf(self);
    kShowHUDAndActivity;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself hideViewAnimated:YES];
        kHiddenHUDAndAvtivity;
    });
}


// 点击Item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.data[indexPath.row];
    NSNumber *roomId = [data objectForKey:@"roomId"];
    [self enterRomeWithRomeId:roomId.intValue];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}
// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TARoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TARoomCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.data = self.data[indexPath.row];
    return cell;
}

- (NSArray *)data//假数据
{
    return [self dataWithType:self.type];
}

- (NSArray *)dataWithType:(int)type
{
    NSArray *data_1 = @[@{@"roomId":@(100001),@"roomName":@"房间101"},
                        @{@"roomId":@(100002),@"roomName":@"房间102"},
                        @{@"roomId":@(100003),@"roomName":@"房间103"},
                        @{@"roomId":@(100004),@"roomName":@"房间104"},
                        @{@"roomId":@(100005),@"roomName":@"房间105"},
                        @{@"roomId":@(100006),@"roomName":@"房间106"},
                        @{@"roomId":@(100007),@"roomName":@"房间107"},
                        @{@"roomId":@(100008),@"roomName":@"房间108"},
                        @{@"roomId":@(100009),@"roomName":@"房间109"},
                        @{@"roomId":@(100010),@"roomName":@"房间1010"}];

    NSArray *data_2 = @[@{@"roomId":@(200001),@"roomName":@"房间201"},
                        @{@"roomId":@(200002),@"roomName":@"房间202"},
                        @{@"roomId":@(200003),@"roomName":@"房间203"},
                        @{@"roomId":@(200004),@"roomName":@"房间204"},
                        @{@"roomId":@(200005),@"roomName":@"房间205"},
                        @{@"roomId":@(200006),@"roomName":@"房间206"}];
    
    NSArray *data_3 = @[@{@"roomId":@(300001),@"roomName":@"房间301"},
                        @{@"roomId":@(300002),@"roomName":@"房间302"}];

    NSMutableArray *all = [NSMutableArray arrayWithArray:data_1];
    [all addObjectsFromArray:data_2];
    [all addObjectsFromArray:data_3];

    NSArray *dataArray;
    switch (type) {
        case 1:
            {
                dataArray = data_1;
            }
            break;
        case 2:
            {
                dataArray = data_2;
            }
            break;
        case 3:
            {
                dataArray = data_3;
            }
            break;
        default:
            dataArray = all;
            break;
    }
    return dataArray;
}

#pragma mark - lazy load
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        // 定义collectionView的样式
        UICollectionViewFlowLayout *myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置属性
        // 给定Item的大小（单元格）
//        myFlowLayout.itemSize = CGSizeMake(kRelative(238), kRelative(182));
        myFlowLayout.itemSize = CGSizeMake(kRelative(276), kRelative(204));
        // 每两个Item的最小间隙（垂直）
        myFlowLayout.minimumInteritemSpacing = kRelative(30);
        // 每两个Item的最小间隙（水平）
        myFlowLayout.minimumLineSpacing = kRelative(30);
        // 设置滚动方向(Vertical垂直方向，horizontal水平方向)
        myFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 设置视图的内边距（逆时针顺序）
        myFlowLayout.sectionInset = UIEdgeInsetsMake(kRelative(10), kRelative(30), kRelative(20), kRelative(30));
        
        // 创建对象，并指定样式
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        // 注册cell
        [_collectionView registerClass:[TARoomCollectionViewCell class] forCellWithReuseIdentifier:@"TARoomCollectionViewCell"];
    }
    return _collectionView;
}

- (UIImageView *)bgView
{
    if(!_bgView){
        _bgView = [UIImageView new];
        _bgView.image = kBundleImage(@"frame_view_bg", @"Commom");
        [_bgView setContentMode:UIViewContentModeScaleAspectFill];
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn setImage:kBundleImage(@"commom_close_btn", @"Commom") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UIButton   *)enterBtn
{
    if (!_enterBtn){
        _enterBtn = [UIButton new];
        _enterBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _enterBtn.layer.cornerRadius = kRelative(27);
        _enterBtn.layer.masksToBounds = YES;
        [_enterBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_enterBtn setTitle:@"快速加入活动" forState:UIControlStateNormal];
        [_enterBtn jk_setBackgroundColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_enterBtn addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _enterBtn.hidden = ([self dataWithType:0].count < 2);
    }
    return _enterBtn;
}

- (UIButton   *)typeBtn
{
    if (!_typeBtn){
        _typeBtn = [UIButton new];
        _typeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_typeBtn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_typeBtn setTitle:@"选择时空场景" forState:UIControlStateNormal];
        [_typeBtn setImage:kBundleImage(@"triangle_down", @"Commom") forState:UIControlStateNormal];
        [_typeBtn setImage:kBundleImage(@"triangle_up", @"Commom") forState:UIControlStateSelected];
        [_typeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, kRelative(206), 0, 0)];
        [_typeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, kRelative(48))];
        [_typeBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _typeBtn;
}

- (UIView     *)typeView
{
    if (!_typeView){
        _typeView = [UIView new];
        _typeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        _typeView.layer.cornerRadius = kRelative(8);
        _typeView.layer.masksToBounds = YES;
        _typeView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.2].CGColor;
        _typeView.layer.borderWidth = kRelative(1);
        _typeView.hidden = YES;
        NSArray *names = @[@"公共时空场景",@"我的时空场景",@"我的时空活动"];
        for (int i = 0; i < 3; i++) {
            UIButton *btn = [UIButton new];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            btn.tag = i+1;
            [btn setTitleColor:kTAColor.c_49 forState:UIControlStateNormal];
            [btn setTitle:names[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(filterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_typeView addSubview:btn];
            CGFloat height = kRelative(192/3);
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(height);
                make.top.mas_equalTo(i * height);
            }];
        }
    }
    return _typeView;
}


@end
