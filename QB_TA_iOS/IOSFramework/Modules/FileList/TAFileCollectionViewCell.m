//
//  TAFileCollectionViewCell.m
//  IOSFramework
//
//  Created by 白伟 on 2023/3/30.
//

#import "TAFileCollectionViewCell.h"
#import "TAMacroDefinition.h"//宏定义
#import "Masonry.h"//布局
#import "TACommonColor.h"
#import "UIImageView+WebCache.h"
#import "TAFileManager.h"
#import "TADownloadProgressView.h"

@interface TAFileCollectionViewCell()
@property (nonatomic, retain)UIImageView    *imageView;
@property (nonatomic, retain)UILabel        *fileNameLabel;
@property (nonatomic, retain)UIButton       *donwloadBtn;
//@property (nonatomic, retain)UIButton       *shareScreenBtn;
@property (nonatomic, retain)TADownloadProgressView *progressView;

@end

@implementation TAFileCollectionViewCell

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
    
//    [self.imageView addSubview:self.shareScreenBtn];
//    [self.shareScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//    }];
    
    [self addSubview:self.fileNameLabel];
    [self.fileNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kRelative(30));
        make.right.mas_equalTo(kRelative(-70));
    }];
    
    [self addSubview:self.donwloadBtn];
    [self.donwloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kRelative(30));
    }];
}

- (void)setData:(NSDictionary *)data
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];

    [_imageView sd_setImageWithURL:nil placeholderImage:kBundleImage(@"placeholder", @"Commom")];
    
    NSString *fName = [data objectForKey:@"fileName"];
    self.fileNameLabel.text = fName;
    
    NSNumber *progress = [data objectForKey:@"progress"];
    NSNumber *size =  [data objectForKey:@"size"];

    if ([[TAFileManager shareInstance].downloadingFileList indexOfObject:data] >= 0)
    {
        self.donwloadBtn.hidden = YES;
        self.progressView.hidden = NO;
        
        [self.progressView setProgress:progress size:size];
    }else{
        self.donwloadBtn.hidden = NO;
        self.progressView.hidden = YES;

        if (progress < size){
            self.donwloadBtn.enabled = YES;
        }else{
            self.donwloadBtn.enabled = NO;
        }
    }
}

-(UILabel *)fileNameLabel
{
    if (!_fileNameLabel) {
        _fileNameLabel = [[UILabel alloc] init];
        _fileNameLabel.textColor = kTAColor.c_49;
        _fileNameLabel.font = [UIFont boldSystemFontOfSize:12];
        _fileNameLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _fileNameLabel;
}

-(UIButton *)donwloadBtn
{
    if (!_donwloadBtn) {
        _donwloadBtn = [[UIButton alloc] init];
        [_donwloadBtn setImage:kBundleImage(@"donwload_button_n", @"File") forState:UIControlStateNormal];
        [_donwloadBtn setImage:kBundleImage(@"donwload_button_d", @"File") forState:UIControlStateDisabled];
        [_donwloadBtn addTarget:self action:@selector(donwloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _donwloadBtn;
}

//-(UIButton *)shareScreenBtn
//{
//    if (!_shareScreenBtn) {
//        _shareScreenBtn = [[UIButton alloc] init];
//        [_shareScreenBtn setImage:kBundleImage(@"share_file_button_n", @"File") forState:UIControlStateNormal];
//        [_shareScreenBtn setImage:kBundleImage(@"share_file_button_d", @"File") forState:UIControlStateDisabled];
//        [_shareScreenBtn addTarget:self action:@selector(donwloadBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _shareScreenBtn;
//}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.layer.cornerRadius = kRelative(15);
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
@end
