//
//  TABasePresenter.h
//  IOSFramework
//
//  Created by 白伟 on 2023/2/28.
//


#import <Foundation/Foundation.h>
#import "TAHeader.h"

@interface TABasePresenter<E>: NSObject{

}
//MVP中负责更新的视图
@property (nonatomic, weak)id view;


/**
 初始化函数

 @param view 要绑定的视图
 */
- (instancetype) initWithView:(id)view;

/**
 * 绑定视图
 * @param view 要绑定的视图
 */
- (void) attachView:(id)view ;

/**
 解绑视图
 */
- (void)detachView;
@end
