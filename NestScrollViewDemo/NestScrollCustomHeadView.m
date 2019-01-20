//
//  NestScrollCustomHeadView.m
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/18.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "NestScrollCustomHeadView.h"
@interface TabViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;
@end

@interface TabViewCell ()
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation TabViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    self.contentLabel.text = title?:@"";
}

-(void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentLabel.textColor = selected ? [UIColor redColor]:[UIColor whiteColor];
}


#pragma mark - property
- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _contentLabel.font = [UIFont systemFontOfSize:20];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
    }
    return _contentLabel;
}

@end


@interface NestScrollCustomHeadView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UICollectionView *tabView;
@end

@implementation NestScrollCustomHeadView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.headImageView];
        [self addSubview:self.tabView];
    }
    return self;
}

- (void)setTabItems:(NSArray *)tabItems {
    _tabItems = tabItems;
    [self.tabView reloadData];
}

#pragma mark - overrid
- (CGFloat)heightOfHeadView {
    return 160 + 35;
}

- (void)scrollTabToIndex:(NSInteger)index {
    [self.tabView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectTab) {
        self.selectTab(indexPath.row);
    }
}

#pragma  mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tabItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TabViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tabViewCell" forIndexPath:indexPath];
    NSString *title = self.tabItems[indexPath.row];
    cell.title = title;
    return cell;
}

#pragma mark - property
- (UIImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), 160)];
        _headImageView.image = [UIImage imageNamed:@"bk"];
        
    }
    return _headImageView;
}

- (UICollectionView *)tabView {
    if (_tabView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(70, 35);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _tabView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 160, CGRectGetWidth([UIScreen mainScreen].bounds), 35) collectionViewLayout:layout];
        _tabView.bounces = NO;
        _tabView.showsVerticalScrollIndicator = NO;
        _tabView.showsHorizontalScrollIndicator = NO;
        _tabView.backgroundColor = [UIColor lightGrayColor];
        [_tabView registerClass:[TabViewCell class] forCellWithReuseIdentifier:@"tabViewCell"];
        _tabView.delegate = self;
        _tabView.dataSource = self;
    }
    return _tabView;
}

@end
