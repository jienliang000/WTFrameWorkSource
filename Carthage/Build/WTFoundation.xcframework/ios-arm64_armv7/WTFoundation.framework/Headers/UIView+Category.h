//
//  UIView+Category.h
//  AppLibs
//
//  Created by 杜恺 on 2018/5/23.
//  Copyright © 2018年 jack Kong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Category)
/**
 *    @brief    frame.origin.x简写.
 */
@property (nonatomic) CGFloat left;

/**
 *    @brief    frame.origin.y简写.
 */
@property (nonatomic) CGFloat top;

/**
 *    @brief    frame.origin.x + frame.size.width简写.
 *  赋值后, frame.origin.x = right - frame.size.width.
 */
@property (nonatomic) CGFloat right;

/**
 *    @brief    frame.origin.y + frame.size.height简写.
 赋值后, frame.origin.y = bottom - frame.size.height.
 */
@property (nonatomic) CGFloat bottom;

/**
 *    @brief    frame.size.width简写.
 *  赋值后, frame.size.width = width.
 */
@property (nonatomic) CGFloat width;

/**
 *    @brief    frame.size.height简写.
 *  赋值后, frame.size.height = height.
 */
@property (nonatomic) CGFloat height;

/**
 *    @brief    center.x简写.
 *  赋值后,center.x = centerX.
 */
@property (nonatomic) CGFloat centerX;

/**
 *    @brief    center.y简写.
 *  赋值后, center.y = centerY.
 */
@property (nonatomic) CGFloat centerY;

/**
 *    @brief  frame.origin简写.
 *  赋值后, frame.origin = origin.
 */
@property (nonatomic) CGPoint origin;

/**
 *    @brief    frame.size简写.
 *  赋值后, frame.size = size.
 */
@property (nonatomic) CGSize size;

/**
 *    @brief    屏幕上的x坐标.
 */
@property (nonatomic, readonly) CGFloat screenX;

/**
 *    @brief    屏幕上的y坐标.
 */
@property (nonatomic, readonly) CGFloat screenY;

/**
 *    @brief    移除实例View所有子视图.
 */
- (void)removeAllSubviews;
/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;

@end
