//
//  TARoomCollectionViewCell.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/30.
//

#import "TARoomCollectionViewCell.h"
#import "TAMacroDefinition.h"//宏定义
#import "Masonry.h"//布局
#import "TACommonColor.h"
#import "UIImageView+WebCache.h"

@interface TARoomCollectionViewCell()
@property (nonatomic, retain)UIImageView    *imageView;
@property (nonatomic, retain)UILabel        *roomName;
@property (nonatomic, retain)UILabel        *member;
@property (nonatomic, retain)UILabel        *roomId;
//@property (nonatomic, retain)UIView *donwloadView;

@end

@implementation TARoomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(kRelative(-40));
    }];
    
    [self.imageView addSubview:self.roomId];
    [self.roomId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kRelative(-10));
        make.top.mas_equalTo(kRelative(10));
        make.width.mas_equalTo(kRelative(100));
        make.height.mas_equalTo(kRelative(30));
    }];
    
    [self addSubview:self.roomName];
    [self.roomName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-70));
    }];
    
    [self addSubview:self.member];
    [self.member mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kRelative(30));
    }];
}

- (void)setData:(NSDictionary *)data
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    NSNumber *rId = [data objectForKey:@"roomId"];
    if (rId.intValue == [TADataCenter shareInstance].userInfo.roomNum) {
        _imageView.layer.borderWidth = kRelative(4);
    }else{
        _imageView.layer.borderWidth = 0;
    }
    self.roomId.text = rId.stringValue;

    [_imageView sd_setImageWithURL:nil placeholderImage:kBundleImage(@"room_placeholder", @"Commom")];
    
    NSString *rName = [data objectForKey:@"roomName"];
    self.roomName.text = rName;
    
    self.member.text = @"0/20";
}

-(UILabel *)roomName
{
    if (!_roomName) {
        _roomName = [[UILabel alloc] init];
        _roomName.textColor = kTAColor.c_49;
        _roomName.font = [UIFont boldSystemFontOfSize:12];
        _roomName.textAlignment = NSTextAlignmentLeft;
    }
    return _roomName;
}

-(UILabel *)member
{
    if (!_member) {
        _member = [[UILabel alloc] init];
        _member.textColor = kTAColor.c_9C;
        _member.font = [UIFont systemFontOfSize:10];
        _member.textAlignment = NSTextAlignmentRight;
    }
    return _member;
}

-(UILabel *)roomId
{
    if (!_roomId) {
        _roomId = [[UILabel alloc] init];
        _roomId.textColor = kTAColor.c_49;
        _roomId.font = [UIFont systemFontOfSize:10];
        _roomId.textAlignment = NSTextAlignmentCenter;
        _roomId.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _roomId.layer.cornerRadius = kRelative(15);
        _roomId.layer.masksToBounds = YES;
    }
    return _roomId;
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = kRelative(15);
        _imageView.layer.masksToBounds = YES;
        _imageView.layer.borderColor = [UIColor colorWithWhite:0 alpha:0.4].CGColor;
        _imageView.layer.borderWidth = kRelative(4);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
@end
