//
//  WTFormViewController.m
//  WTUIKit
//
//  Created by admin on 2020/10/26.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTFormViewController.h"
#import "WTUIKitDefine.H"
#import "WTUIConstant.h"
@import RETableViewManager;
@import MJRefresh;
@import ReactiveObjC;
@import Masonry;
@interface WTFormViewController ()<RETableViewManagerDelegate>

@end

@implementation WTFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.formTable setEditing:NO];
}

- (void)initView
{
    _formTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
     _formTable.estimatedRowHeight = 0;
     _formTable.estimatedSectionHeaderHeight = 0;
     _formTable.estimatedSectionFooterHeight = 0;
     _formTable.separatorStyle = UITableViewCellSeparatorStyleNone;
     _formTable.backgroundColor = [UIColor clearColor];
     _formTable.bounces = YES;
     _formTable.showsHorizontalScrollIndicator = NO;
     _formTable.showsVerticalScrollIndicator = NO;
     _formTable.tableFooterView = [UIView new];
    if (@available(iOS 11.0, *)) {
        _formTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
     [self.view addSubview:_formTable];
    [self.formTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(WT_NavigationBar_Height);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
     _formManager = [[RETableViewManager alloc] initWithTableView:_formTable];
     _formManager.delegate = self;
     _formManager[@"WTEmptyItem"] = @"WTEmptyCell";
}

#pragma mark - RETableViewManagerDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex {
     return 0;
}

- (void)addHeader {
    @weakify(self)
    self.formTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self.listArray removeAllObjects];
        [self getDataList];
    }];
    self.formTable.mj_header.hidden = YES;
}

- (void)addFooter {
    @weakify(self);
    self.formTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self)
        [self performSelector:@selector(getDataList) withObject:nil afterDelay:0.001];
    }];
    self.formTable.mj_footer.hidden = YES;
}

- (void)endRefreshHeader {
    [self.formTable.mj_header endRefreshing];
}

- (void)endRefreshFooter {
    [self.formTable.mj_footer endRefreshing];
}

- (void)getDataList {
    
}

- (int)getPageIndex {
    int pageIndex = (int)(self.listArray.count/10);
    if (self.listArray.count%10>0) {
        pageIndex = pageIndex + 1;
    }
    pageIndex += 1;
    return pageIndex;
}

- (void)getListData:(NSString *)path params:(NSDictionary *)param listDataKey:(NSString *)listDataKey completion:(void (^)(id, NSError *))completion {
    @weakify(self)
//    [WTNetWorkingHandler postWithPath:path params:param completion:^(id result, NSError *error) {
//        @strongify(self)
//        [WTLoadingView hideLoading:self.view];
//        [self endRefreshHeader];
//        [self endRefreshFooter];
//        if (error) {
//            self.formTable.alpha = 0;
//            //加载网络错误视图
//            if (completion) {
//                completion(result,error);
//            }
//            return;
//        }
//        self.formTable.alpha = 1.0;
//        if ([self getPageIndex]==1) {
//            [self.listArray removeAllObjects];
//        }
//        NSArray *ar = result[listDataKey];
//        if (ar && [ar isKindOfClass:[NSArray class]]) {
//            [self.listArray addObjectsFromArray:ar];
//        }
//        [self setFooterShow:result];
//        if (completion) {
//            completion(result,error);
//        }
//    }];
}

- (void)setFooterShow:(NSDictionary *)dict {
    int total = [dict[@"total"] intValue];
    if (self.listArray.count >= total) {
        self.formTable.mj_footer.hidden = YES;
    } else {
        self.formTable.mj_footer.hidden = NO;
    }
}
@end
