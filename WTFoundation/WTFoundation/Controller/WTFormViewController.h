//
//  WTFormViewController.h
//  WTUIKit
//
//  Created by admin on 2020/10/26.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTViewController.h"
@class RETableViewManager;
@interface WTFormViewController : WTViewController
@property (nonatomic,strong) RETableViewManager *formManager;
@property (nonatomic, strong) UITableView *formTable;

//分页
@property (nonatomic,strong) NSMutableArray *listArray;
- (void)addHeader;
//添加下拉刷新
- (void)endRefreshHeader;
- (void)endRefreshFooter;

- (int)getPageIndex;
- (void)getDataList;
- (void)getListData:(NSString *)path params:(NSDictionary *)param listDataKey:(NSString *)listDataKey completion:(void (^)(id, NSError *))completion;
@end
