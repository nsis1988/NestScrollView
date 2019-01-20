//
//  NestScrollViewHeadView.m
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "NestScrollViewHeadView.h"

@interface NestScrollViewHeadView ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *verticalPanGesture;
@property (nonatomic, assign) CGPoint currentPointForPan;
@end

@implementation NestScrollViewHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _verticalPanGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(onPanGesture:)];
        [self addGestureRecognizer:_verticalPanGesture];
    }
    return self;
}

- (void)dealloc {
    _verticalPanGesture.delegate = nil;
    _verticalPanGesture = nil;
}

#pragma mark - public 需要子类重写的方法
- (void)scrollTabToIndex:(NSInteger)index {
    
}

- (CGFloat)heightOfHeadView {
    return 0.f;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint velocityPoint = [panGesture velocityInView:self.superview];
        if (fabs(velocityPoint.y) > fabs(velocityPoint.x)){
            return YES;
        }
    }
    return NO;
}

- (void)onPanGesture:(UIPanGestureRecognizer *)gesture {
    CGPoint locationPoint = [gesture locationInView:self.superview];
    CGPoint velocityPoint = [gesture velocityInView:self.superview];
    if (!CGPointEqualToPoint(self.currentPointForPan, CGPointZero)&& (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled)) {
        CGFloat offsetY = locationPoint.y - self.currentPointForPan.y;
        if (self.dragDelegate && [self.dragDelegate conformsToProtocol:@protocol(NestScrollViewHeadViewDragDelegate)] && [self.dragDelegate respondsToSelector:@selector(nestScrollViewHeadViewDidEndDragingWithOffset:)]) {
            [self.dragDelegate nestScrollViewHeadViewDidEndDragingWithOffset:CGPointMake(0, offsetY)];
        }
    }
    if (fabs(velocityPoint.y) > fabs(velocityPoint.x)) {
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:
            {
                self.currentPointForPan = locationPoint;
            }
                break;
                case UIGestureRecognizerStateChanged:
            {
                CGFloat offsetY = locationPoint.y - self.currentPointForPan.y;
                if (self.dragDelegate && [self.dragDelegate conformsToProtocol:@protocol(NestScrollViewHeadViewDragDelegate)] && [self.dragDelegate respondsToSelector:@selector(nestScrollViewHeadViewDidDragingWithOffset:)]) {
                    [self.dragDelegate nestScrollViewHeadViewDidDragingWithOffset:CGPointMake(0, offsetY)];
                }
                
                self.currentPointForPan = locationPoint;
            }
                
            default:
                break;
        }
    }
}

@end
