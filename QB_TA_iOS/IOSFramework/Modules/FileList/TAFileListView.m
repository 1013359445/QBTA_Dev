//
//  TAFileListView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/27.
//

#import "TAFileListView.h"
#import "TAFileManager.h"
#import "TAFileCollectionViewCell.h"

@interface TAFileListView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain)UIImageView *bgView;
@property (nonatomic, retain)UIButton   *closeBtn;
@property (nonatomic, retain)UICollectionView *collectionView;

@property (nonatomic, retain)UIButton   *uploadFileBtn;
@property (nonatomic, retain)UILabel    *titleLabel;

@end

@implementation TAFileListView

+ (NSString *)cmd{
    return @"fileList";
}

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(1256), kRelative(600));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showEffectView = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloading) name:TAFileManagerDownloadingNotification object:nil];
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
    
    [self addSubview:self.uploadFileBtn];
    [self.uploadFileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-88));
        make.width.mas_equalTo(kRelative(120));
        make.height.mas_equalTo(kRelative(50));
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_uploadFileBtn.mas_centerY);
        make.left.mas_equalTo(kRelative(30));
    }];
}

-(void)uploadFileBtnClick
{
    
}

-(void)downloading
{
    [self.collectionView reloadData];
}

-(void)closeBtnClick
{
    [self hideViewAnimated:YES];
}

// 点击Item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *data = self.data[indexPath.row];
    NSNumber *fileId = [data objectForKey:@"fileId"];
    [[TAFileManager shareInstance] downloadWithFileId:fileId.intValue];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.data.count;
}
// 返回每一个item的cell对象
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TAFileCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TAFileCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.data = self.data[indexPath.row];
    return cell;
}

- (NSArray *)data//假数据
{
    return [TAFileManager shareInstance].fileList;
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
        [_collectionView registerClass:[TAFileCollectionViewCell class] forCellWithReuseIdentifier:@"TAFileCollectionViewCell"];
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
- (UIButton   *)uploadFileBtn
{
    if (!_uploadFileBtn){
        _uploadFileBtn = [UIButton new];
        _uploadFileBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        _uploadFileBtn.layer.cornerRadius = kRelative(25);
        _uploadFileBtn.layer.masksToBounds = YES;
        [_uploadFileBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadFileBtn setTitle:@"上传文件" forState:UIControlStateNormal];
        [_uploadFileBtn jk_setBackgroundColor:kTAColor.c_49 forState:UIControlStateNormal];
        [_uploadFileBtn addTarget:self action:@selector(uploadFileBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _uploadFileBtn;
}

- (UILabel   *)titleLabel
{
    if (!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.text = @"文件列表";
        _titleLabel.textColor = kTAColor.c_49;
    }
    return _titleLabel;
}


@end
