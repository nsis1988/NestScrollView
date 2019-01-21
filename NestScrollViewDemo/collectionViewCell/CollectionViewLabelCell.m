//
//  CollectionViewLabelCell.m
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/21.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "CollectionViewLabelCell.h"

@interface CollectionViewLabelCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CollectionViewLabelCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


#pragma mark - property
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.textColor = [UIColor darkGrayColor];
    }
    return _titleLabel;
}
@end
