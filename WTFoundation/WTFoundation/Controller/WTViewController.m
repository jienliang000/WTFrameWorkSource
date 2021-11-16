//
//  WTViewController.h
//  WTBaseCore
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//

#import "WTViewController.h"
#import "WTUIKitDefine.h"
#import "WTUIConstant.h"
@import ReactiveObjC;
@import Masonry;
static UIImage *_backImg = nil;
@interface WTViewController ()

@end

@implementation WTViewController
@synthesize navBar;
+ (void)setBackImg:(UIImage *)img {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _backImg = [img copy];
    });
}

+ (UIImage *)backImg {
    return _backImg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = WT_Color_BackGround;
     if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]){
          self.automaticallyAdjustsScrollViewInsets = NO;
     }
    @weakify(self)
    //创建导航栏
    navBar = [[WTCustomNavBar alloc] init];
    navBar.lineColor = WT_Color_Line;
    [self.view addSubview:navBar];    
    [navBar mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(WT_NavigationBar_Height);
        make.width.equalTo(self.view);
    }];

    if (self.navigationController.viewControllers.count>1) {
        //返回按钮
        WTCustomBarItem *item = [[WTCustomBarItem alloc] init];
        item.itemStyle = 1;
        item.imgSize = CGSizeMake(24, 24);
        item.itemImage = WTViewController.backImg;
        item.onClick = ^(void) {
            @strongify(self)
            [self backBtnPress];
        };
        navBar.leftItemList = [NSArray arrayWithObject:item];
        [navBar setNeedsLayout];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)backBtnPress {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"%@销毁了",[self class]);
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
