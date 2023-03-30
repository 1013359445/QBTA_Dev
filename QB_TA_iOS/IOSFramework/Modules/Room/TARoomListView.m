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
    return CGSizeMake(kRelative(1256), kRelative(600));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = 1;
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
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

// 点击Item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.data[indexPath.row];
    NSNumber *roomId = [data objectForKey:@"roomId"];
    [TADataCenter shareInstance].userInfo.roomId = roomId.intValue;
    [[TARoomManager shareInstance] changeRomeWithRomeId:roomId.intValue];
    
    [self.collectionView reloadData];
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

- (NSArray *)data
{
    NSArray *dataArray = @[@{@"roomId":@(300001),@"roomName":@"房间301"},
                           @{@"roomId":@(300002),@"roomName":@"房间302"}];

    switch (self.type) {
        case 1:
            {
                dataArray = @[@{@"roomId":@(100001),@"roomName":@"房间101"},
                              @{@"roomId":@(100002),@"roomName":@"房间102"},
                              @{@"roomId":@(100003),@"roomName":@"房间103"},
                              @{@"roomId":@(100004),@"roomName":@"房间104"},
                              @{@"roomId":@(100005),@"roomName":@"房间105"},
                              @{@"roomId":@(100006),@"roomName":@"房间106"},
                              @{@"roomId":@(100007),@"roomName":@"房间107"},
                              @{@"roomId":@(100008),@"roomName":@"房间108"},
                              @{@"roomId":@(100009),@"roomName":@"房间109"},
                              @{@"roomId":@(100010),@"roomName":@"房间1010"}
                ];
            }
            break;
        case 2:
            {
                dataArray = @[@{@"roomId":@(200001),@"roomName":@"房间201"},
                              @{@"roomId":@(200002),@"roomName":@"房间202"},
                              @{@"roomId":@(200003),@"roomName":@"房间203"},
                              @{@"roomId":@(200004),@"roomName":@"房间204"},
                              @{@"roomId":@(200005),@"roomName":@"房间205"},
                              @{@"roomId":@(200006),@"roomName":@"房间206"}
                     ];
            }
            break;
        default:
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

@end
