//
//  NestScrollView.h
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NestScrollViewHeadView.h"

NS_ASSUME_NONNULL_BEGIN
@class NestScrollView;
@class PageIndexPath;

@protocol  NestScrollViewDelegate<NSObject>
@required
- (CGSize)nestScrollView:(NestScrollView *)nestScrollView sizeForItemAtPageIndexPath:(PageIndexPath *)pageIndexPath;

@optional
- (CGFloat)nestScrollView:(NestScrollView *)nestScrollView minimumLineSpacingForPage:(NSInteger)page;
- (CGFloat)nestScrollView:(NestScrollView *)nestScrollView minimumInteritemSpacingForPage:(NSInteger)page;
- (UIEdgeInsets)nestScrollView:(NestScrollView *)nestScrollView insetForPage:(NSInteger)page;
- (void)nestScrollView:(NestScrollView *)nestScrollView didSelectItemAtPageIndexPath:(PageIndexPath *)pageIndexPath;

@end
@protocol NestScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInNestScrollView:(NestScrollView *)nestScrollView;

- (NSInteger)nestScrollView:(NestScrollView *)nestScrollView numberOfItemsInPage:(NSInteger)page;
- (UICollectionViewCell *)nestScrollView:(NestScrollView *)nestScrollView collectionView:(UICollectionView*)collectionView itemForPageIndexPath:(PageIndexPath *)pageIndexPath;
- (NSDictionary<NSString*,NSString*>*)cellMapOfPageIndex:(NSInteger)pageIndex;
@end

@interface PageIndexPath : NSObject
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger row;

+ (instancetype)pageIndexPathWithRow:(NSInteger)row  page:(NSInteger)page;
@end

@interface NestScrollView : UIView
@property (nonatomic, strong) NestScrollViewHeadView *headView;

@property (nonatomic, weak) id<NestScrollViewDelegate> delegate;
@property (nonatomic, weak) id<NestScrollViewDataSource> dataSource;

- (void)scrollToPageIndex:(NSUInteger)pageIndex;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
