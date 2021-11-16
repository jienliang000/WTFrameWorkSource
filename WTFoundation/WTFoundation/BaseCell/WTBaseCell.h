//
//  WTBaseCell.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
#import <RETableViewManager/RETableViewItem.h>
#import <RETableViewManager/RETableViewCell.h>

@interface WTBaseItem : RETableViewItem
@property (nonatomic,copy) id info;
@property (nonatomic,copy) UIColor *bgColor;
@property (nonatomic,assign) BOOL canHighlighted;//点击是否有高亮状态

@end

@interface WTBaseCell : RETableViewCell
@property (nonatomic,readwrite,strong) WTBaseItem *item;
@end
