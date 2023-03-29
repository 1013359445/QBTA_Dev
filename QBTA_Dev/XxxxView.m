//
//  XxxxView.m
//  QBTA_Dev
//
//  Created by 白伟 on 2023/3/10.
//

#import "XxxxView.h"

@implementation XxxxView
//事件向下传递
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
