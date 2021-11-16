//
//  WTViewController.h
//  WTBaseCore
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//

#import "WTTabbarController.h"
#import <Masonry/Masonry.h>
#import "WTUIKitDefine.h"
#import "WTUIKitUtil.h"
#import "WTUIConstant.h"
#import "UIButton+Style.h"

@interface WTTabBarItem()
@end

@implementation WTTabBarItem
- (id)init {
    self = [super init];
    if (self) {
        self.titleText = @"";
        self.normalImage = nil;
        self.selectImage = nil;
        self.textSelectColor = [UIColor blueColor];
        self.textNormaltColor = [UIColor blackColor];
        self.font = WTFontSys(13);
    }
    return self;
}
@end

@interface WTTabbarController ()
{
    UIButton *_lastButton;
}
@end

@implementation WTTabbarController
- (id)init
{
    self = [super init];
    if (self) {
        //将原来的UITabBarController中的UITabBar隐藏起来；
        [self.tabBar setHidden:YES];
        self.currentIndex = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_tabBarView==nil) {
        [self createTabBarView];
        [self setTabBarControllers];
    }
}

- (void)createTabBarView {
    _tabBarView = [[UIView alloc] init];
    _tabBarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabBarView];
    [self.tabBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.mas_equalTo(WT_TabBar_Height);
    }];
    
    UIImageView *lineImg = [[UIImageView alloc] init];
    lineImg.backgroundColor = WT_Color_Line;
    lineImg.tag = 111;
    [_tabBarView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

//创建自定义tabBar
- (void)setTabBarControllers {
    for (UIView *subV in self.tabBarView.subviews) {
        if (subV.tag!=111) {
            [subV removeFromSuperview];
        }
    }
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    NSMutableArray *btnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.itemsArray.count; i++) {
        WTTabBarItem *item = self.itemsArray[i];
        [controllers addObject:item.vc];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = 100+i;
        button.titleLabel.font = item.font;
        [button setTitle:item.titleText forState:UIControlStateNormal];
        [button setTitle:item.titleText forState:UIControlStateSelected];
        [button setTitleColor:item.textNormaltColor forState:UIControlStateNormal];
        [button setTitleColor:item.textSelectColor forState:UIControlStateSelected];
        [button setImage:item.normalImage forState:UIControlStateNormal];
        [button setImage:item.selectImage forState:UIControlStateSelected];
        [button layoutButtonWithEdgeInsetsStyle:ICButtonEdgeInsetsStyleTop imageTitleSpace:4];
        if (self.currentIndex==i) {
            button.selected = YES;
            self.selectedIndex = self.currentIndex;
            _lastButton = button;
        }
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarView addSubview:button];
        [btnArray addObject:button];
    }
    [btnArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [btnArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.height.mas_equalTo(WT_TabBar_Height-WT_SafeArea_Bottom);
    }];
    self.viewControllers = controllers;
}

//点击按钮后显示哪个控制器界面
- (void)selectedTab:(UIButton *)button {
    if (_lastButton!=nil && ![_lastButton isKindOfClass:[NSNull class]]) {
        _lastButton.selected = NO;
    }
    button.selected = YES;
    self.selectedIndex = button.tag-100;
    _lastButton = button;
}

- (void)setTabIndex:(int)idx {
    UIButton *btn = (UIButton *)[_tabBarView viewWithTag:100+idx];
    if (btn&&[btn isKindOfClass:[UIButton class]]) {
        [self selectedTab:btn];
    }
}
@end
