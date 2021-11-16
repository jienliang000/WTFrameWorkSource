//
//  WTEmptyCell.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
#import <RETableViewManager/RETableViewItem.h>
#import <RETableViewManager/RETableViewCell.h>

@interface WTEmptyItem : RETableViewItem
@property (nonatomic,copy) UIColor *bgColor;
+ (id)initWithHeight:(float)height;
+ (id)initWithHeight:(float)height bgColor:(UIColor *)bColor;
@end

@interface WTEmptyCell : RETableViewCell
@property (strong, readwrite, nonatomic) WTEmptyItem *item;
@end
