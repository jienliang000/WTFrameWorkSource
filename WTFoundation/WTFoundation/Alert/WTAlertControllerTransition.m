//
//  WTAlertControllerTransition.m
//  WTUIKit
//
//  Created by jienliang on 2019/9/9.
//  Copyright © 2019 jienlaing. All rights reserved.
//

#import "WTAlertControllerTransition.h"
#import "WTAlertController.h"

@implementation WTAlertControllerTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    __kindof UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    __kindof UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    if ([toViewController isKindOfClass:[WTAlertController class]] && toViewController.isBeingPresented) {
        WTAlertController *alertController = toViewController;
        
        UIView *containerView = transitionContext.containerView;
        [containerView addSubview:alertController.view];
        
        UIView *contentView = alertController.contentView;
        contentView.transform = CGAffineTransformIdentity;
        contentView.alpha = 0;
        [UIView animateWithDuration:duration animations:^{
            contentView.alpha = 1;
            contentView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    } else if ([fromViewController isKindOfClass:[WTAlertController class]] && fromViewController.isBeingDismissed) {
        [UIView animateWithDuration:duration animations:^{
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}

@end
