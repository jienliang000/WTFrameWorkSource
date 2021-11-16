//
//  ZXModalView.m
//  ZXPopPickerView
//
//  Created by Libo on 2018/9/1.
//  Copyright © 2018年 Cookie. All rights reserved.
//

#import "ZXModalView.h"

@interface ZXModalView ()
@end
@implementation ZXModalView

- (instancetype)initWithView:(UIView *)view {
    if (self = [super init]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self addSubview:self.contentView];
        
        self.contentView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, view.bounds.size.width, view.bounds.size.height);
        [self.contentView addSubview:view];
    }
    return self;
}

- (void)show {
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    self.contentView.frame = CGRectMake(0, self.frame.size.height, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [UIView animateWithDuration:0.2f animations:^{
        self.contentView.frame = CGRectMake(0, self.frame.size.height - self.contentView.frame.size.height,self.contentView.frame.size.width,self.contentView.frame.size.height);
    }];
}

- (void)hide {
    [UIView animateWithDuration:0.2f animations:^{
        self.contentView.frame = CGRectMake(0,self.frame.size.height,self.contentView.frame.size.width,self.contentView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
//        _contentView.layer.shadowOffset = CGSizeZero;
//        _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _contentView.layer.shadowRadius = 3;
//        _contentView.layer.shadowOpacity = 1;
//        _contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, -2, self.frame.size.width, 2)].CGPath;
    }
    return _contentView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
