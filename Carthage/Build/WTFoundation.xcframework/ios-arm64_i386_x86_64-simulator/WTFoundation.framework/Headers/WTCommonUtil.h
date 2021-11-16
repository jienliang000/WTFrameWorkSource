//
//  WTCommonUtil.h
//  AppPublic
//
//  Created by 储强盛 on 2018/4/3.
//  Copyright © 2018年 jack Kong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "WTAppDelegate.h"

/**
 工具类
 */
@interface WTCommonUtil : NSObject
/**
 *    @brief    拨打电话
 *
 *    @param     phoneNo     电话号码
 *
 *    @return
 */
+ (void)call:(NSString *)phoneNo;
/**
 *     @brief 应用程序对象
 *
 *     @return     AppDelegate.
 */
+ (WTAppDelegate *)appDelegate;
/**
 *     @brief 判断字符串是否是金额
 *
 *     @return     BOOL
 */
+ (BOOL)checkPrice:(NSString *)price;
/**
 *     @brief 获取指定范围的随机数
 *
 *     @return     int
 */
+ (int)getRandomNumber:(int)from to:(int)to;
@end
