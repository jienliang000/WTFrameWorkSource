//
//  WTEmptyDataCell.h
//  BSHomeModel
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
#import <RETableViewManager/RETableViewItem.h>
#import <RETableViewManager/RETableViewCell.h>

@interface WTEmptyDataItem : RETableViewItem
@property (nonatomic,copy) NSString *emptyText;
@property (nonatomic,copy) UIImage *emptyIcon;
@end

@interface WTEmptyDataCell : RETableViewCell
@property (strong, readwrite, nonatomic) WTEmptyDataItem *item;
@end
