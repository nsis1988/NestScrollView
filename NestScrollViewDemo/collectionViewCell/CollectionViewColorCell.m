//
//  CollectionViewColorCell.m
//  NestScrollViewDemo
//
//  Created by sunfan on 2019/1/21.
//  Copyright © 2019 Simon. All rights reserved.
//

#import "CollectionViewColorCell.h"

@interface CollectionViewColorCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation CollectionViewColorCell
- (instancetype) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        self.contentView.layer.masksToBounds = YES;
        self.contentView.layer.cornerRadius = 8;
        self.contentView.backgroundColor = [UIColor colorWithRed:(random()%255)/255.f green:(random()%255)/255.f blue:(random()%255)/255.f alpha:1];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

-(UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
