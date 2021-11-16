//
//  WTFailedView.h
//
//
//  Created by Charles on 15/12/18.
//  Copyright © 2015年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^retryBlock)(void);

@interface WTFailedView : UIView
{
    retryBlock myRetryBlock;
}
@property (class,nonatomic,copy) UIImage *failedImg;//加载失败图片
@property (assign,nonatomic) retryBlock retryBlcok;

- (void)setRetryBlcok:(retryBlock)retryBlcok;
+ (WTFailedView *)showFailedView:(UIView *)superView top:(CGFloat)top retryBlock:(void(^)(void))retryBlock;

+ (void)hideFailedView:(UIView *)superView;
@end
