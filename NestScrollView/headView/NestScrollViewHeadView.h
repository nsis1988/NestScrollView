//
//  NestScrollViewHeadView.h
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol NestScrollViewHeadViewDragDelegate <NSObject>

- (void)nestScrollViewHeadViewDidDragingWithOffset:(CGPoint)offset;

- (void)nestScrollViewHeadViewDidEndDragingWithOffset:(CGPoint)offset;

@end

@interface NestScrollViewHeadView : UIView

@property (nonatomic, weak)id<NestScrollViewHeadViewDragDelegate> dragDelegate;

- (CGFloat)heightOfHeadView;

- (void)scrollTabToIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
