//
//  WTUIConstant.h
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/26.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTUIConstant : NSObject
/// 底部tab高度
@property (class, nonatomic,assign) float tabBarHeight;
/// 状态栏高度
@property (class, nonatomic,readonly) float statusBarHeight;
//导航栏title区域高度，不包括status区域
@property (class, nonatomic,assign) float navBarTitleHeight;
//导航栏整体高度，包含status高度
@property (class, nonatomic,readonly) float navBarHeight;
@end
