//
//  TABasePresenter.m
//  MVP
//
//  Created by baoshan on 17/2/8.
//  Copyright © 2017年 hans. All rights reserved.
//

#import "TABasePresenter.h"

@implementation TABasePresenter

/**
 初始化函数
 */
- (instancetype)initWithView:(id)view{
    self = [super init];
    if (self) {
        _view = view;
    }
    return self;
}
/**
 * 绑定视图
 * @param view 要绑定的视图
 */
- (void)attachView:(id)view {
    _view = view;
}


/**
 解绑视图
 */
- (void)detachView{
    _view = nil;
}
@end
