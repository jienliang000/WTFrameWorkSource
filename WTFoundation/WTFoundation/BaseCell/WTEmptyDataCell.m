//
//  WTEmptyDataCell.h
//  QLHomeModel
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
@import RETableViewManager;
#import "WTEmptyDataCell.h"
#import "WTUIKitDefine.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
@implementation WTEmptyDataItem
- (id)init{
    if (self = [super init]) {
        self.cellHeight = 10;
        self.emptyText = @"暂无数据";
        self.emptyIcon = [UIImage imageNamed:@"emptyImage"];
    }
    return self;
}

@end

@interface WTEmptyDataCell()
{
}
@property (nonatomic,strong) UIImageView *iconImg;
@property (nonatomic,strong) UILabel *emptyLabel;
@end

@implementation WTEmptyDataCell

- (void)cellDidLoad
{
    [super cellDidLoad];
    
    _iconImg = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImg];
    self.iconImg.sd_layout.centerXEqualToView(self.contentView).centerYEqualToView(self.contentView);
    
    _emptyLabel = [[UILabel alloc] init];
    _emptyLabel.font = [UIFont systemFontOfSize:13];
    _emptyLabel.textColor = WTColorHex(0x777777);
    _emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_emptyLabel];
    self.emptyLabel.sd_layout.leftEqualToView(self.contentView).rightEqualToView(self.contentView).autoHeightRatio(0).topSpaceToView(self.iconImg, 4);
}

- (void)cellWillAppear {
    [super cellWillAppear];
    self.backgroundColor = [UIColor clearColor];
    self.emptyLabel.text = self.item.emptyText;
    [self.iconImg setImage:self.item.emptyIcon];
    self.iconImg.sd_layout.widthIs(self.item.emptyIcon.size.width).heightIs(self.item.emptyIcon.size.height);
    
    float height = 120;
    float tableViewHeight = self.parentTableView.height;
    float tableViewContent = self.parentTableView.contentSize.height;
    float offsetY = tableViewHeight-tableViewContent;
    if (offsetY > 120) {
        height = offsetY;
    }
    self.item.cellHeight = height;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
@end
