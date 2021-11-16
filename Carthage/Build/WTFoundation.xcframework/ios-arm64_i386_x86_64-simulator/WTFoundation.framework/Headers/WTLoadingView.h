//
//  WTLoadingView.h
//  CLMJRefresh
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLoadingView : UIView
@property (class,nonatomic,copy) NSArray *loadingImgArray;//加载动画图片集合

+ (WTLoadingView *)showLoading:(UIView *)superView top:(CGFloat)top;
+ (void)hideLoading:(UIView *)superView;
@end
