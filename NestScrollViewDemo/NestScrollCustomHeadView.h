//
//  NestScrollCustomHeadView.h
//  NestScrollViewDemo
//
//  Created by SIMON on 2019/1/18.
//  Copyright © 2019 SIMON. All rights reserved.
//

#import "NestScrollViewHeadView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NestScrollCustomHeadView : NestScrollViewHeadView
@property (nonatomic, copy)void(^selectTab)(NSInteger tabIndex);
@property (nonatomic, strong) NSArray  *tabItems;
@end

NS_ASSUME_NONNULL_END
