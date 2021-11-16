//
//  WTEmptyCell.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
#import "WTEmptyCell.h"
@import RETableViewManager;

@implementation WTEmptyItem
+ (id)initWithHeight:(float)height {
     WTEmptyItem *it = [[WTEmptyItem alloc] init];
     it.cellHeight = height;
     it.bgColor = [UIColor clearColor];
     return it;
}

+ (id)initWithHeight:(float)height bgColor:(UIColor *)bColor {
    WTEmptyItem *it = [[WTEmptyItem alloc] init];
    it.cellHeight = height;
    it.bgColor = bColor;
    return it;
}

- (id)init{
    if (self = [super init]) {
        self.cellHeight = 10;
        self.bgColor = [UIColor clearColor];
    }
    return self;
}

@end

@interface WTEmptyCell()
{
}
@end

@implementation WTEmptyCell

- (void)cellDidLoad
{
    [super cellDidLoad];
}

- (void)cellWillAppear
{
    [super cellWillAppear];
    self.backgroundColor = self.item.bgColor;
    self.contentView.backgroundColor = self.item.bgColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated{}
@end
