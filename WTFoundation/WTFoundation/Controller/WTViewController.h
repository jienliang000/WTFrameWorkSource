//
//  WTViewController.h
//  WTBaseCore 
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTCustomNavBar.h"

@interface WTViewController : UIViewController
@property (class,nonatomic,copy) UIImage *backImg;
/**
 *    @brief    导航栏视图.
 */
@property (nonatomic, strong) WTCustomNavBar *navBar;
@end
