//
//  CLGifLoadView.m
//  CLMJRefresh
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//


#import "WTLoadingView.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "WTUIKitDefine.h"
@import ReactiveObjC;
static NSArray *_loadingImgArray = nil;

@interface WTLoadingView()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) UILabel * stateLabel;
@end

@implementation WTLoadingView
+ (void)setLoadingImgArray:(NSArray *)array {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loadingImgArray = [array copy];
    });
}

+ (NSArray *)loadingImgArray {
    return _loadingImgArray;
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = WT_Color_BackGround;
        [self makeView];
    }
    return self;
}

- (void)makeView {
    @weakify(self);
    _contentView = [[UIView alloc] init];
    [self addSubview:_contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];
    
    _gifView = [[UIImageView alloc] init];
    [self.contentView addSubview:_gifView];
    [self.gifView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY).offset(-20);
    }];
    
    _stateLabel = [[UILabel alloc]init];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.font = [UIFont systemFontOfSize:12.0f];
    _stateLabel.textColor = WTColorHex(0x777777);
    _stateLabel.text = @"努力加载中...";
    [self.contentView addSubview:_stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.equalTo(self.gifView.mas_bottom).offset(5);
        make.height.equalTo(@15);
    }];

    _gifView.animationImages = WTLoadingView.loadingImgArray;
    _gifView.animationRepeatCount = 0;
    _gifView.animationDuration = 1.0;
    [_gifView startAnimating];
}

+ (WTLoadingView *)showLoading:(UIView *)superView top:(CGFloat)top {
    [WTLoadingView hideLoading:superView];
    WTLoadingView * loadView = [[WTLoadingView alloc]init];
    loadView.tag = 189091;
    [superView addSubview:loadView];
    [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.mas_equalTo(top);
        make.bottom.equalTo(superView.mas_bottom);
    }];
    return loadView;
}

+ (void)hideLoading:(UIView *)superView {
    for (UIView *subView in superView.subviews) {
        if (subView.tag==189091) {
            [subView removeFromSuperview];
        }
    }
}
@end
