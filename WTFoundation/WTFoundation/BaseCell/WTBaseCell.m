//
//  WTBaseCell.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
#import "WTBaseCell.h"
@import RETableViewManager;

#define WTColorCell(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation WTBaseItem
- (id)init{
     if (self = [super init]) {
          self.cellHeight = 48;
          self.bgColor = [UIColor whiteColor];
          self.canHighlighted = YES;
     }
     return self;
}
@end

@interface WTBaseCell()
{
}
@end

@implementation WTBaseCell

- (void)cellDidLoad
{
    [super cellDidLoad];
}

- (void)cellWillAppear {
     [super cellWillAppear];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (self.item.canHighlighted) {
        if (highlighted) {
            self.backgroundColor = WTColorCell(0xcccccc);
        } else {
            self.backgroundColor = self.item.bgColor;
        }
    }
}

@end
