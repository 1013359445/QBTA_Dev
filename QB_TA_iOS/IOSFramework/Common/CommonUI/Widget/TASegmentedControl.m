//
//  TASegmentedControl.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import "TASegmentedControl.h"
#import "TAMacroDefinition.h"//宏定义
#import "Masonry.h"//布局
#import "TACommonColor.h"

@interface TASegmentedControl ()
@property (nonatomic, retain)UILabel *titleLabel;
@end

@implementation TASegmentedControl

- (instancetype)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title items:@[@"OFF",@"ON"]];
}

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items
{
    self = [super init];
    if (self) {
        self.clipsToBounds = NO;

        self.titleLabel = [UILabel new];
        _titleLabel.text = title;
        _titleLabel.textColor = kTAColor.c_49;
        _titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kRelative(6));
            make.height.mas_equalTo(kRelative(30));
            make.bottom.mas_equalTo(self.mas_top).mas_offset(kRelative(-5));
        }];
        
        self.segmented = [[UISegmentedControl alloc] initWithItems:items];
        [self addSubview:_segmented];
        [_segmented mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        if (@available(iOS 13.0, *)) {
            [_segmented setSelectedSegmentTintColor:kTAColor.c_49];
        } else {
            [_segmented setTintColor:kTAColor.c_49];
        }
                
        NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:kTAColor.c_9C,NSForegroundColorAttributeName,nil];
        [_segmented setTitleTextAttributes:dics forState:UIControlStateNormal];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
       [_segmented setTitleTextAttributes:dic forState:UIControlStateSelected];
    }
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    _segmented.tag = tag;
}
@end
