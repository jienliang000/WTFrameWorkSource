//
//  WTFailedView.m
//
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//


#import "WTFailedView.h"
#import <Masonry/Masonry.h>
#import "WTUIKitDefine.h"
@import ReactiveObjC;
static UIImage *_failedImg = nil;

@interface WTFailedView()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIImageView *gifView;
@property (strong, nonatomic) UILabel * stateLabel;
@property (strong, nonatomic) UIButton *retryBtn;
@end

@implementation WTFailedView
+ (void)setFailedImg:(UIImage *)img {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _failedImg = [img copy];
    });
}

+ (UIImage *)failedImg {
    return _failedImg;
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
    _gifView.image = WTFailedView.failedImg;
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
    _stateLabel.text = @"加载失败，请点击重试";
    [self.contentView addSubview:_stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.equalTo(self.gifView.mas_bottom).offset(5);
        make.height.equalTo(@15);
    }];
    
    _retryBtn = [[UIButton alloc] init];
    [_retryBtn addTarget:self action:@selector(retryBtnPress) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_retryBtn];
    [_retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.top.equalTo(self.gifView);
        make.bottom.equalTo(self.stateLabel.mas_bottom);
    }];
}

- (void)setRetryBlcok:(retryBlock)retryBlcok{
    myRetryBlock = retryBlcok;
}

- (void)retryBtnPress {
    if (myRetryBlock) {
        myRetryBlock();
    }
}

+ (WTFailedView *)showFailedView:(UIView *)superView top:(CGFloat)top retryBlock:(void(^)(void))retryBlock {
    [WTFailedView hideFailedView:superView];
    WTFailedView * loadView = [[WTFailedView alloc]init];
    loadView.tag = 189091;
    loadView.retryBlcok = retryBlock;
    [superView addSubview:loadView];
    [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.mas_equalTo(top);
        make.bottom.equalTo(superView.mas_bottom);
    }];
    return loadView;
}

+ (void)hideFailedView:(UIView *)superView {
    for (UIView *subView in superView.subviews) {
        if (subView.tag==189091) {
            [subView removeFromSuperview];
        }
    }
}
@end
