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
    return CGSizeMake(CGRectGetWidth(nestScrollView.bounds), 40);
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
    return @{@"default":NSStringFromClass([UICollectionViewCell class])};
}

- (UICollectionViewCell *)nestScrollView:(NestScrollView *)nestScrollView collectionView:(nonnull UICollectionView *)collectionView itemForPageIndexPath:(nonnull PageIndexPath *)pageIndexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"default" forIndexPath:[NSIndexPath indexPathForRow:pageIndexPath.row inSection:0]];
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc]init];
    }
    NSArray *items = self.datas[pageIndexPath.page];
    UILabel *label = [[UILabel alloc]initWithFrame:cell.bounds];
    label.text = items[pageIndexPath.row]?:@"空";
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:label];
    return cell;
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
            [arr2 addObject:[NSString stringWithFormat:@"第二个标签第%d个",i]];
        }
        [_datas addObjectsFromArray:@[arr1,arr2]];
    }
    return _datas;
}

@end
