//
//  TAMessageNoticeView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/5/15.
//

#import "TAMessageNoticeView.h"
#import "TAChatDataModel.h"

@interface TAMessageNoticeView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain)UITableView    *msgTableView;
@property (nonatomic, retain)NSMutableArray *data;
@property (nonatomic, retain)NSMutableArray *tasks;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSLock *lock;
@end

@implementation TAMessageNoticeView

- (void)dealloc{
    [[TADataCenter shareInstance] removeObserver:self forKeyPath:@"clientMessageEvent"];
    [_timer invalidate];
    _timer = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.lock = [[NSLock alloc] init];
        self.tasks = [[NSMutableArray alloc] init];
        self.data = [[NSMutableArray alloc] init];
        self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(tasksRefresh) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer  forMode:NSRunLoopCommonModes];

        //注册监听
        [[TADataCenter shareInstance] addObserver:self forKeyPath:@"clientMessageEvent" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

//KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    [self.data addObject:[TADataCenter shareInstance].clientMessageEvent];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.msgTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    if (self.tasks.count > 0){
        NSNumber *firstNum = [self.tasks firstObject];
        if (firstNum.intValue >= 10){
            [self.tasks insertObject:@(firstNum.intValue + 1) atIndex:0];
        }else{
            [self.tasks insertObject:@(10) atIndex:0];
        }
    }else{
        [self.tasks insertObject:@(10) atIndex:0];
    }
    
    [self performSelector:@selector(pushOffIfNeed) withObject:nil afterDelay:0.05];
}

- (void)loadSubViews
{
    [self addSubview:self.msgTableView];
    [self.msgTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - 移出cell
- (void)tasksRefresh{
    [self.lock lock];
    NSNumber *pushOffNum = nil;
    NSMutableArray *newtasks = [NSMutableArray array];
    for (int i = 0;i < self.tasks.count; i++) {
        NSNumber *num = self.tasks[i];
        NSNumber *newNum = @(num.intValue - 1);
        if (num.intValue == 1){
            pushOffNum = newNum;
        }
        [newtasks addObject:newNum];
    }
    self.tasks = newtasks;

    if (pushOffNum){
        [self pushOff];
        [self.tasks removeLastObject];
    }
    [self.lock unlock];
}

- (void)pushOff{
    [self.data removeObjectAtIndex:0];
    NSArray *array = [self.msgTableView visibleCells];
    NSIndexPath *indexPath = [self.msgTableView indexPathForCell:[array lastObject]];
    [self.msgTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)pushOffIfNeed{
    [self.lock lock];
    NSArray *array = [self.msgTableView visibleCells];
    CGFloat visibleCellsHeight = 0;
    for (int i = 0; i < array.count; i++) {
        TAChatDataModel *msg = self.data[i];
        if (i < array.count){
            if (![msg.phone isEqualToString:@"11100000000"]){
                visibleCellsHeight += kRelative(70);
            }else{
                visibleCellsHeight += kRelative(35);
            }
        }else{
            break;
        }
    }
    if (visibleCellsHeight > self.msgTableView.bounds.size.height){
        [self pushOff];
        [self.tasks removeLastObject];
    }
    [self.lock unlock];
}

#pragma mark - action
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

#pragma mark - UITableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    static NSString *TAMessageNoticeCellIdIdentifier = @"TAMessageNoticeCellIdIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TAMessageNoticeCellIdIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier: TAMessageNoticeCellIdIdentifier];
        cell.contentView.transform = CGAffineTransformMakeScale (1,-1);
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kTAColor.c_F0;
        view.layer.cornerRadius = kRelative(16);
        view.layer.masksToBounds = YES;
        view.tag = 888;
        view.alpha = 0.8;

        UILabel *titleLabel = [UILabel new];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.tag = 666;
        titleLabel.layer.cornerRadius = kRelative(13);
        titleLabel.layer.masksToBounds = YES;
        titleLabel.numberOfLines = 1;
        titleLabel.textColor = kTAColor.c_49;

        [cell.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kRelative(10));
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(kRelative(-10));
        }];

        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(10));
            make.right.mas_equalTo(kRelative(-10));
            make.height.mas_equalTo(kRelative(26));
            make.center.mas_equalTo(0);
        }];
    }
    
    NSInteger index = self.data.count - 1 - indexPath.row;
    TAChatDataModel *msg = self.data[index];
    UIView *view = [cell.contentView viewWithTag:888];
    UILabel *titleLabel = [cell.contentView viewWithTag:666];
    if (![msg.phone isEqualToString:@"11100000000"]){
        titleLabel.textColor = kTAColor.c_49;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        view.hidden = NO;
    }else{
        titleLabel.textColor = kTAColor.c_32;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = kTAColor.c_9C;
        view.hidden = YES;
    }
    titleLabel.text = [NSString stringWithFormat:@"%@：%@", msg.nickname, msg.content];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = self.data.count - 1 - indexPath.row;
    TAChatDataModel *msg = self.data[index];
    if (![msg.phone isEqualToString:@"11100000000"]){
        return kRelative(70);
    }else{
        return kRelative(35);
    }
}

#pragma mark - lazy load
-(UITableView *)msgTableView
{
    if (!_msgTableView){
        _msgTableView = [UITableView new];
        _msgTableView.delegate = self;
        _msgTableView.dataSource = self;
        _msgTableView.backgroundColor = [UIColor clearColor];
        _msgTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _msgTableView.transform = CGAffineTransformMakeScale (1,-1);
        _msgTableView.clipsToBounds = NO;
        _msgTableView.userInteractionEnabled = NO;
    }
    return _msgTableView;
}

@end
