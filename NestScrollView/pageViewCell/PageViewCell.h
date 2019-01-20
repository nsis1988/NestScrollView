//
//  PageViewCell.h
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PageViewCell;
@protocol PageViewCellDelegate <NSObject>
@required
- (CGSize)pageViewCell:(PageViewCell *)pageViewCell sizeForItemAtIndex:(NSInteger)index;
- (void)pageViewCellDidScrollWithOffset:(CGPoint)offset;
@optional
- (CGFloat)minimumLineSpacingForPageViewCell:(PageViewCell *)pageViewCell;
- (CGFloat)minimumInteritemSpacingForPageViewCell:(PageViewCell *)pageViewCell;
- (void)pageViewCell:(PageViewCell *)pageViewCell didSelectItemAtIndex:(NSInteger )index;
@end
@protocol PageViewCellDataSource <NSObject>
@required
- (NSInteger)numberOfCellsInPageViewCell:(PageViewCell *)pageViewCell;

/**
 返回当前pageCell需要注册的cell类型

 @param pageViewCell 当前的pageCell
 @return key是ReuseIdentifier，value是cell的类名
 */
- (NSDictionary<NSString*,NSString*>*)cellMapInPageViewCell:(PageViewCell *)pageViewCell;
- (UICollectionViewCell *)pageViewCell:(PageViewCell *)pageViewCell cellForIndex:(NSUInteger)index;
@end


@interface PageViewCell : UICollectionViewCell
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak)  id<PageViewCellDelegate> delegate;
@property (nonatomic, weak) id <PageViewCellDataSource> dataSource;
@property (nonatomic, assign) CGFloat sectionHeadHeight;
@property (nonatomic, assign) NSInteger pageIndex;

- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
