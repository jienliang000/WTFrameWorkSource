//
//  WTFormView.m
//  ChiXinTiYuProject
//
//  Created by Fuxinming on 2017/11/7.
//  Copyright © 2017年 Fuxinming. All rights reserved.
//

#import "WTFormView.h"
@interface WTFormView ()<RETableViewManagerDelegate>

@end

@implementation WTFormView
@synthesize formTable,formManager;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initTableView];
    }
    return self;
}

- (void)initTableView
{
    formTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    formTable.showsVerticalScrollIndicator = NO;
    formTable.estimatedRowHeight = 0;
    formTable.estimatedSectionHeaderHeight = 0;
    formTable.estimatedSectionFooterHeight = 0;
    formTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    formTable.backgroundColor = [UIColor clearColor];
    [self addSubview:formTable];
    if ([formTable respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
        if (@available(iOS 11.0, *)) {
            formTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
        }
    }

    formManager = [[RETableViewManager alloc] initWithTableView:formTable];
    formManager.delegate = self;
}

#pragma mark - RETableViewManagerDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 0;
}
@end
