//
//  ViewController.m
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/13.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "ViewController.h"
#import "NestScrollCustomHeadView.h"
#import "NestScrollView.h"
#import "CollectionViewLabelCell.h"
#import "CollectionViewColorCell.h"

@interface ViewController ()<NestScrollViewDelegate,NestScrollViewDataSource>
@property (nonatomic, strong) NestScrollView *contentView;
@property (nonatomic, strong) NestScrollCustomHeadView *headView;
@property (nonatomic, strong) NSMutableArray<NSArray *> *datas;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Do any additional setup after loading the view, typically from a nib.
    self.contentView.headView = self.headView;
    [self.view addSubview:self.contentView];
}

#pragma mark - NestScrollViewDelegate
- (CGSize)nestScrollView:(NestScrollView *)nestScrollView sizeForItemAtPageIndexPath:(PageIndexPath *)pageIndexPath {
    if (pageIndexPath.page == 0) {
        return CGSizeMake(CGRectGetWidth(nestScrollView.bounds) - 10, 40);
    }
    else {
        CGFloat width = (CGRectGetWidth(self.view.bounds) - 2*3)/2;
        return CGSizeMake(width, width);
    }
}

- (CGFloat)nestScrollView:(NestScrollView *)nestScrollView minimumLineSpacingForPage:(NSInteger)page {
    if (page == 1) {
        return 2.f;
    }
    return 0.f;
}
- (CGFloat)nestScrollView:(NestScrollView *)nestScrollView minimumInteritemSpacingForPage:(NSInteger)page {
    if (page == 1) {
        return 2.f;
    }
    return 0.f;
}
- (UIEdgeInsets)nestScrollView:(NestScrollView *)nestScrollView insetForPage:(NSInteger)page {
    if (page == 1) {
        return UIEdgeInsetsMake(0, 2, 0, 2);
    }
    else {
        return UIEdgeInsetsMake(0, 10, 0, 0);
    }
}

#pragma mark - NestScrollViewDataSource
- (NSInteger)numberOfPagesInNestScrollView:(NestScrollView *)nestScrollView {
    return self.datas.count;
}

- (NSInteger)nestScrollView:(NestScrollView *)nestScrollView numberOfItemsInPage:(NSInteger)page {
    NSArray *arr = self.datas[page];
    return arr.count;
}

- (NSDictionary<NSString*,NSString*>*)cellMapOfPageIndex:(NSInteger)pageIndex {
    return @{@"label":NSStringFromClass([CollectionViewLabelCell class]),
             @"color":NSStringFromClass([CollectionViewColorCell class])
             };
}

- (UICollectionViewCell *)nestScrollView:(NestScrollView *)nestScrollView collectionView:(nonnull UICollectionView *)collectionView itemForPageIndexPath:(nonnull PageIndexPath *)pageIndexPath{
    NSArray *items = self.datas[pageIndexPath.page];
    if (pageIndexPath.page == 0) {
        CollectionViewLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"label" forIndexPath:[NSIndexPath indexPathForRow:pageIndexPath.row inSection:0]];
        cell.title = items[pageIndexPath.row]?:@"";
        return cell;
    }
    else {
        CollectionViewColorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"color" forIndexPath:[NSIndexPath indexPathForRow:pageIndexPath.row inSection:0]];
        cell.title = items[pageIndexPath.row]?:@"";
        return cell;
    }
}

#pragma mark - property
- (NestScrollView *)contentView {
    if (_contentView == nil) {
        _contentView = [[NestScrollView alloc]initWithFrame:self.view.bounds];
        _contentView.delegate = self;
        _contentView.dataSource = self;
    }
    return _contentView;
}

- (NestScrollCustomHeadView *)headView {
    if (_headView == nil) {
        _headView = [[NestScrollCustomHeadView alloc]initWithFrame:CGRectZero];
        _headView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), [_headView heightOfHeadView]);
        __weak typeof(self) weakSelf = self;
        _headView.selectTab = ^(NSInteger tabIndex) {
            [weakSelf.contentView scrollToPageIndex:tabIndex];
        };
        _headView.tabItems = @[@"标签一",@"标签二"];
        [_headView scrollTabToIndex:0];
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (NSMutableArray<NSArray*>*)datas {
    if (_datas == nil) {
        _datas = [[NSMutableArray alloc]initWithCapacity:2];
        NSMutableArray *arr1= [[NSMutableArray alloc]init];
        for(int i = 0; i< 4; i++) {
            [arr1 addObject:[NSString stringWithFormat:@"第一个标签第%d个",i]];
        }
        NSMutableArray *arr2 = [[NSMutableArray alloc]init];
        for (int i = 0; i< 30; i++) {
            [arr2 addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [_datas addObjectsFromArray:@[arr1,arr2]];
    }
    return _datas;
}

@end
