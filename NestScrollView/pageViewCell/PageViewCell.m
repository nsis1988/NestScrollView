//
//  PageViewCell.m
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "PageViewCell.h"

#define kSectionHeadIdentifier @"sectionHeadIdentifier"
@interface PageViewCell () <UICollectionViewDelegateFlowLayout,
                                                UICollectionViewDataSource>
@property (nonatomic, strong) NSDictionary<NSString*,NSString*> *cellmap;
@end

@implementation PageViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.collectionView];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}
- (void)dealloc {
    if (_collectionView) {
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
        _collectionView = nil;
    }
}
#pragma mark - public
- (void)reloadData {
    if (_collectionView) {
        [_collectionView reloadData];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(PageViewCellDelegate)] && [self.delegate respondsToSelector:@selector(pageViewCellDidScrollWithOffset:)]) {
        [self.delegate pageViewCellDidScrollWithOffset:scrollView.contentOffset];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(PageViewCellDelegate)] && [self.delegate respondsToSelector:@selector(pageViewCell:sizeForItemAtIndex:)]) {
       return [self.delegate pageViewCell:self sizeForItemAtIndex:indexPath.row];
    }
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(PageViewCellDelegate)] && [self.delegate respondsToSelector:@selector(minimumLineSpacingForPageViewCell:)]) {
        return [self.delegate minimumLineSpacingForPageViewCell:self];
    }
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(PageViewCellDelegate)] && [self.delegate respondsToSelector:@selector(minimumInteritemSpacingForPageViewCell:)]) {
        return [self.delegate minimumInteritemSpacingForPageViewCell:self];
    }
    return 0.f;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(PageViewCellDelegate)] && [self.delegate respondsToSelector:@selector(pageViewCell:didSelectItemAtIndex:)]) {
        [self.delegate pageViewCell:self didSelectItemAtIndex:indexPath.row];
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(CGRectGetWidth(self.collectionView.bounds), self.sectionHeadHeight);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(PageViewCellDataSource)] && [self.dataSource respondsToSelector:@selector(numberOfCellsInPageViewCell:)]) {
        return [self.dataSource numberOfCellsInPageViewCell:self];
    }
    return  0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource && [self.dataSource conformsToProtocol:@protocol(PageViewCellDataSource)] && [self.dataSource respondsToSelector:@selector(pageViewCell:cellForIndex:)]) {
        return [self.dataSource pageViewCell:self cellForIndex:indexPath.row];
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeadIdentifier forIndexPath:indexPath];
    }
    return [[UICollectionReusableView alloc]init];
}


#pragma mark - property
- (void)setSectionHeadHeight:(CGFloat)sectionHeadHeight {
    _sectionHeadHeight = sectionHeadHeight;
    [self.collectionView reloadData];
}
- (void)setDataSource:(id<PageViewCellDataSource>)dataSource {
    _dataSource = dataSource;
    if (self.cellmap.count > 0) {
        [self.cellmap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.collectionView registerClass:nil forCellWithReuseIdentifier:key];
        }];
    }
    if ([dataSource respondsToSelector:@selector(cellMapInPageViewCell:)]) {
        self.cellmap = [dataSource cellMapInPageViewCell:self];
        [self.cellmap enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.collectionView registerClass:NSClassFromString(obj) forCellWithReuseIdentifier:key];
        }];
    }
    
}
- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:flowLayout];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kSectionHeadIdentifier];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
@end
