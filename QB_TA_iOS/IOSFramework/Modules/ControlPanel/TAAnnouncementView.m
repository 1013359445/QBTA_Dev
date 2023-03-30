//
//  TAAnnouncementView.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/6.
//

#import "TAAnnouncementView.h"
#import "KJMarqueeLabel.h"

@interface TAAnnouncementView ()

@property (nonatomic, retain)UIImageView *bgImageView;
@property (nonatomic, retain)NSMutableArray *contentQueue;
@property (nonatomic, assign)BOOL isInAction;

@end

@implementation TAAnnouncementView
shareInstance_implementation(TAAnnouncementView);

+ (CGSize)viewSize
{
    return CGSizeMake(kRelative(800), kRelative(80));
}

- (instancetype)init
{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.userInteractionEnabled = NO;
        [self creatSubViews];
    }
    return self;
}
- (void)creatSubViews
{
    self.contentQueue = [[NSMutableArray alloc] init];
    
    self.bgImageView = [UIImageView new];
    UIImage *handsomeImage = kBundleImage(@"frame_white_80", @"Commom");
    handsomeImage = [handsomeImage stretchableImageWithLeftCapWidth:handsomeImage.size.width / 2 topCapHeight:handsomeImage.size.width / 2];
    _bgImageView.image = handsomeImage;
    _bgImageView.alpha = 0;
    [self addSubview:_bgImageView];
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)loadSubViews
{
    if (_contentQueue.count > 0) {
        [self showText];
    }
}

- (void)addContent:(NSString *)content
{
    [_contentQueue addObject:content];
    if (self.superview == nil) {
        return;
    }
    if (_contentQueue.count > 0 && _isInAction == NO) {
        [self showText];
    }
}

- (void)showText
{
    if (_contentQueue.count == 0) {
        _isInAction = NO;
        return;
    }
    
    _isInAction = YES;
    _bgImageView.alpha = 0.8;
    NSString *text = [_contentQueue firstObject];
    
    KJMarqueeLabel *contentLabel = [[KJMarqueeLabel alloc] initWithFrame:CGRectMake(kRelative(20), kRelative(20), kRelative(760), kRelative(40))];
    contentLabel.textColor = kTAColor.c_49;
    contentLabel.font = [UIFont systemFontOfSize:10];
    contentLabel.marqueeLabelType = KJMarqueeLabelTypeLeft;
    contentLabel.secondLabelInterval = 40;
    contentLabel.stopTime = 5;
    contentLabel.text = text;
    contentLabel.speed = 0.6;
    [self addSubview:contentLabel];

    CGSize size = [contentLabel jk_suggestSizeForString:text width:9999];
    CGFloat time = 7.4;
    if (size.width > self.bounds.size.width) {
        time = size.width / self.bounds.size.width * time;
    }
    kWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [contentLabel removeFromSuperview];
        weakself.bgImageView.alpha = 0;
        [weakself.contentQueue removeObjectAtIndex:0];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time + 3) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakself showText];
    });
}

@end
