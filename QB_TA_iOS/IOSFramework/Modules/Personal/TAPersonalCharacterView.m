//
//  TAPersonalCharacterView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAPersonalCharacterView.h"
#import "TAPersonalCharacterCell.h"

@interface TAPersonalCharacterView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain)UICollectionView   *collectionView;
@property (nonatomic, assign)NSInteger          selectIndex;
@property (nonatomic, retain)UIButton           *saveBtn;

@property (nonatomic, retain)UIButton           *femaleBtn;
@property (nonatomic, retain)UIButton           *maleBtn;

@property (nonatomic, retain)NSArray            *femaleDataArray;
@property (nonatomic, retain)NSArray            *maleDataArray;

@property (nonatomic, assign)BOOL               male;
@end

@implementation TAPersonalCharacterView

- (void)loadSubViews
{
    _selectIndex = 0;//选中id，从数据中获取
    self.male = YES;//性别，假数据，应该从数据中获取
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(kRelative(-160));
        make.top.mas_equalTo(kRelative(80));
        make.bottom.mas_equalTo(kRelative(-120));
    }];
    
    [self addSubview:self.saveBtn];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(kRelative(460));
        make.height.mas_equalTo(kRelative(97));
        make.bottom.mas_equalTo(0);
    }];
    
    [self addSubview:self.maleBtn];
    [self.maleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(120));
        make.height.mas_equalTo(kRelative(80));
        make.top.mas_equalTo(_collectionView.mas_top);
        make.right.mas_equalTo(0);
    }];
    
    [self addSubview:self.femaleBtn];
    [self.femaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kRelative(120));
        make.height.mas_equalTo(kRelative(80));
        make.top.mas_equalTo(_maleBtn.mas_bottom).mas_offset(kRelative(30));
        make.right.mas_equalTo(0);
    }];
}

-(void)saveBtnClick
{
    [self.presenter modifyCharacter:self.data[_selectIndex]];
}

-(void)femaleBtnClick
{
    if (!self.male) {
        return;
    }
    self.male = NO;
    [_maleBtn setImage:kBundleImage(@"personal_male_n", @"Personal") forState:UIControlStateNormal];
    [_femaleBtn setImage:kBundleImage(@"personal_female_s", @"Personal") forState:UIControlStateNormal];
    
    self.selectIndex = 0;
}
-(void)maleBtnClick
{
    if (self.male) {
        return;
    }
    self.male = YES;
    [_maleBtn setImage:kBundleImage(@"personal_male_s", @"Personal") forState:UIControlStateNormal];
    [_femaleBtn setImage:kBundleImage(@"personal_female_n", @"Personal") forState:UIControlStateNormal];
    
    self.selectIndex = 0;
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
    if ([self.delegate respondsToSelector:@selector(changeCharacter:)]) {
        [self.delegate performSelector:@selector(changeCharacter:) withObject:self.data[selectIndex]];
    }
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
    if (self.male) {
        return @[@"role_head_1",@"role_head_2",@"role_head_3"];
    }else{
        return @[@"role_head_4",@"role_head_5"];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        // 定义collectionView的样式
        UICollectionViewFlowLayout *myFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        // 设置属性
        // 给定Item的大小（单元格）
        myFlowLayout.itemSize = CGSizeMake(kRelative(80), kRelative(80));
        // 每两个Item的最小间隙（垂直）
        myFlowLayout.minimumInteritemSpacing = kRelative(50);
        // 每两个Item的最小间隙（水平）
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

-(UIButton       *)saveBtn
{
    if (!_saveBtn)
    {
        _saveBtn = [UIButton new];
        [_saveBtn setImage:kBundleImage(@"personal_save_btn", @"Personal") forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

-(UIButton       *)femaleBtn
{
    if (!_femaleBtn)
    {
        _femaleBtn = [UIButton new];
        [_femaleBtn setImage:kBundleImage(@"personal_female_n", @"Personal") forState:UIControlStateNormal];
        [_femaleBtn addTarget:self action:@selector(femaleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _femaleBtn;
}

-(UIButton       *)maleBtn
{
    if (!_maleBtn)
    {
        _maleBtn = [UIButton new];
        [_maleBtn setImage:kBundleImage(@"personal_male_s", @"Personal") forState:UIControlStateNormal];
        [_maleBtn addTarget:self action:@selector(maleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maleBtn;
}

@end
