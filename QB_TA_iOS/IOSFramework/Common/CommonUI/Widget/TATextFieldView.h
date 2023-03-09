//
//  TATextFieldView.h
//  IOSFramework
//
//  Created by 白伟 on 2023/3/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TATextFieldView : UIView
@property (nonatomic, retain)UITextField    *textField;
@property (nonatomic, copy)NSString         *text;

- (instancetype)initWithDelegate:(id)delegate title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
