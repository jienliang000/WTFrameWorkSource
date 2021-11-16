//
//  WTUIConstant.m
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/26.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTUIConstant.h"
#import "WTUIKitDefine.h"
#import "WTUIKitUtil.h"
static float _tabBarHeight = 49;
static float _navBarTitleHeight = 44;

@implementation WTUIConstant
+ (void)setTabBarHeight:(float)tabBarHeight {
    _tabBarHeight = tabBarHeight;
}

+ (float)tabBarHeight {
    return _tabBarHeight + WT_SafeArea_Bottom;
}

+(float)statusBarHeight {
    return isIPhoneX ? 44.0f : 20.0f;
}

+ (void)setNavBarTitleHeight:(float)titleHeight {
    _navBarTitleHeight = titleHeight;
}

+ (float)navBarTitleHeight {
    return _navBarTitleHeight;
}

+(float)navBarHeight {
    return [WTUIConstant statusBarHeight] + [WTUIConstant navBarTitleHeight];
}
@end
