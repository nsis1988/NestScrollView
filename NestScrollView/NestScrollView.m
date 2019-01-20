//
//  NestScrollView.m
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "NestScrollView.h"
#import "pageViewCell.h"

#define kPageViewCellIdentifier  @"pageViewCellIdentifier"
@implementation PageIndexPath
+ (instancetype)pageIndexPathWithRow:(NSInteger)row page:(NSInteger)page {
    PageIndexPath *pageIndexPath = [[PageIndexPath alloc]init];
    pageIndexPath.page = page;
    pageIndexPath.row = row;
    return pageIndexPath;
}
@end

@interface NestScrollView ()<UICollectionViewDelegateFlowLayout,
                                                UICollectionViewDataSource,
                                                PageViewCellDelegate,
                                                PageViewCellDataSource,
                                                NestScrollViewHeadViewDragDelegate>

@property (nonatomic, strong) UICollectionView *pageView;

@property (nonatomic, assign) BOOL isHorizontalScrolling;

@property (nonatomic, weak) PageViewCell *currentScrollingPageCell;
@end

@implementation NestScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.pageView];
    }
    return self;
}
- (void)dealloc {
    if (_pageView) {
        _pageView.delegate = nil;
        _pageView.dataSource = nil;
        _pageView = nil;
    }
}
#pragma mark - public
- (void)scrollToPageIndex:(NSUInteger)pageIndex {
    self.currentScrollingPageCell = self.pageView.visibleCells.firstObject;
    CGFloat offsetX = pageIndex * CGRectGetWidth(self.pageView.bounds);
    [self.pageView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
   
}
- (void)reloadData {
    if (_pageView) {
        [_pageView reloadData];
    }
}

#pragma mark - scrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.currentScrollingPageCell = self.pageView.visibleCells.firstObject;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isTracking) {
        self.isHorizontalScrolling = YES;
    }
    CGPoint currentOffset = self.currentScrollingPageCell.collectionView.contentOffset;
    for (PageViewCell *cell in self.pageView.visibleCells) {
        if (cell != self.currentScrollingPageCell) {
            [cell.collectionView setContentOffset:currentOffset animated:NO];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self handleDraggingEnd];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate){
        [self handleDraggingEnd];
    }
}
- (void)handleDraggingEnd {
    self.isHorizontalScrolling = NO;
    PageViewCell *currentPageViewCell = self.pageView.visibleCells.firstObject;
    if (currentPageViewCell != self.currentScrollingPageCell &&
        currentPageViewCell.collectionView.contentSize.height < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        [currentPageViewCell.collectionView setContentOffset:CGPointZero animated:NO];
    }
    NSInteger tabIndex = self.pageView.contentOffset.x / CGRectGetWidth(self.pageView.bounds);
    [self.headView scrollTabToIndex:tabIndex];
    self.currentScrollingPageCell = nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(NestScrollViewDataSource)] && [self.dataSource respondsToSelector:@selector(numberOfPagesInNestScrollView:)]) {
        return [self.dataSource numberOfPagesInNestScrollView:self];
    }
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPageViewCellIdentifier forIndexPath:indexPath];
    cell.pageIndex = indexPath.row;
    cell.sectionHeadHeight = self.headView.heightOfHeadView;
    cell.delegate = self;
    cell.dataSource = self;
    return cell;
}
#pragma mark - PageViewCellDelegate
- (CGSize)pageViewCell:(PageViewCell *)pageViewCell sizeForItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(NestScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(nestScrollView:sizeForItemAtPageIndexPath:)]) {
        PageIndexPath *pageIndexPath = [PageIndexPath pageIndexPathWithRow:index page:pageViewCell.pageIndex];
        return [self.delegate nestScrollView:self sizeForItemAtPageIndexPath:pageIndexPath];
    }
    return CGSizeZero;
}

- (void)pageViewCellDidScrollWithOffset:(CGPoint)offset {
    if (! self.isHorizontalScrolling) {
        CGRect frame = self.headView.frame;
        frame.origin.y = - offset.y;
        self.headView.frame = frame;
    }
}

- (CGFloat)minimumLineSpacingForPageViewCell:(PageViewCell *)pageViewCell {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(NestScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(nestScrollView:minimumLineSpacingForPage:)]) {
        return [self.delegate nestScrollView:self minimumLineSpacingForPage:pageViewCell.pageIndex];
    }
    return 0.f;
}

- (CGFloat)minimumInteritemSpacingForPageViewCell:(PageViewCell *)pageViewCell {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(NestScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(nestScrollView:minimumInteritemSpacingForPage:)]) {
        return [self.delegate nestScrollView:self minimumInteritemSpacingForPage:pageViewCell.pageIndex];
    }
    return 0.f;
}

- (void)pageViewCell:(PageViewCell *)pageViewCell didSelectItemAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(NestScrollViewDelegate)] && [self.delegate respondsToSelector:@selector(nestScrollView:didSelectItemAtPageIndexPath:)]) {
        PageIndexPath *pageIndexPath = [PageIndexPath pageIndexPathWithRow:index page:pageViewCell.pageIndex];
        [self.delegate nestScrollView:self didSelectItemAtPageIndexPath:pageIndexPath];
    }
}

#pragma mark - PageViewCellDataSource

- (NSInteger)numberOfCellsInPageViewCell:(PageViewCell *)pageViewCell {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(NestScrollViewDataSource)] && [self.dataSource respondsToSelector:@selector(nestScrollView:numberOfItemsInPage:)]) {
        return [self.dataSource nestScrollView:self numberOfItemsInPage:pageViewCell.pageIndex];
    }
    return 0;
}

- (UICollectionViewCell *)pageViewCell:(PageViewCell *)pageViewCell cellForIndex:(NSUInteger)index {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(NestScrollViewDataSource)] && [self.dataSource respondsToSelector:@selector(nestScrollView:collectionView:itemForPageIndexPath:)]) {
        PageIndexPath *pageIndexPath = [PageIndexPath pageIndexPathWithRow:index page:pageViewCell.pageIndex];
        return [self.dataSource nestScrollView:self collectionView:pageViewCell.collectionView  itemForPageIndexPath:pageIndexPath];
    }
    return nil;
}

- (NSDictionary<NSString*,NSString*>*)cellMapInPageViewCell:(PageViewCell *)pageViewCell {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(NestScrollViewDataSource)] && [self.dataSource respondsToSelector:@selector(cellMapOfPageIndex:)]) {
        return [self.dataSource cellMapOfPageIndex:pageViewCell.pageIndex];
    }
    return nil;
}

#pragma mark - NestScrollViewHeadViewDragDelegate
- (void)nestScrollViewHeadViewDidDragingWithOffset:(CGPoint)offset {
    if (offset.y > 0) {
        offset.y = offset.y / [UIScreen mainScreen].scale;
    }
    PageViewCell *cell = self.pageView.visibleCells.firstObject;
    if (cell) {
        CGPoint currentOffset = cell.collectionView.contentOffset;
        currentOffset.x += offset.x;
        currentOffset.y += (-offset.y);
        [cell.collectionView setContentOffset:currentOffset animated:NO];
    }
}

- (void)nestScrollViewHeadViewDidEndDragingWithOffset:(CGPoint)offset {
    PageViewCell *cell = self.pageView.visibleCells.firstObject;
    if (cell) {
        CGPoint currentOffset = cell.collectionView.contentOffset;
        currentOffset.x += offset.x;
        currentOffset.y += (-offset.y);
        CGFloat maxOffset = fabs(cell.collectionView.contentSize.height - CGRectGetHeight(cell.collectionView.bounds));
        if (currentOffset.y < 0 ||CGRectGetHeight(cell.collectionView.bounds) >= cell.collectionView.contentSize.height) {
            [cell.collectionView setContentOffset:CGPointZero animated:YES];
        }
        else if(ceil(currentOffset.y) <= maxOffset) {
            [cell.collectionView setContentOffset:currentOffset animated:NO];
        }
        else {
            [cell.collectionView setContentOffset:CGPointMake(0, maxOffset) animated:NO];
        }
    }
}

#pragma mark - property
- (void)setHeadView:(NestScrollViewHeadView *)headView {
    _headView = headView;
    _headView.dragDelegate = self;
    [self addSubview:_headView];
    [self.pageView reloadData];
}
- (UICollectionView *)pageView {
    if (_pageView == nil) {
        UICollectionViewFlowLayout *flowLayer = [[UICollectionViewFlowLayout alloc]init];
        flowLayer.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayer.minimumLineSpacing = 0.f;
        flowLayer.minimumInteritemSpacing = 0.f;
        _pageView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayer];
        _pageView.pagingEnabled = YES;
        _pageView.backgroundColor = [UIColor clearColor];
        _pageView.showsVerticalScrollIndicator = NO;
        _pageView.showsHorizontalScrollIndicator = NO;
        _pageView.bounces = NO;
        [_pageView registerClass:[PageViewCell class] forCellWithReuseIdentifier:kPageViewCellIdentifier];
        _pageView.delegate = self;
        _pageView.dataSource = self;
    }
    return _pageView;
}

@end
