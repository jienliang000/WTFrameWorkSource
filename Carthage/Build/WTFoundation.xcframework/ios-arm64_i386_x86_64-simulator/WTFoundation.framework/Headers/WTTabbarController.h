//
//  WTTabbarController.h
//  WTBaseCore
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTabBarItem : NSObject
@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) UIImage *normalImage;
@property (nonatomic,copy) UIImage *selectImage;
@property (nonatomic,copy) UIColor *textNormaltColor;
@property (nonatomic,copy) UIColor *textSelectColor;
@property (nonatomic,copy) UIFont *font;

@property (nonatomic,strong) UIViewController *vc;
@end

@interface WTTabbarController : UITabBarController
@property (nonatomic,strong) UIView *tabBarView;
@property (nonatomic,strong) NSArray *itemsArray;
@property (nonatomic,assign) int currentIndex;
- (void)setTabIndex:(int)idx;
@end
