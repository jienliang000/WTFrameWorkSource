//
//  WTCustomNavBar.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface WTCustomBarItem : NSObject
@property (nonatomic, assign) NSInteger itemStyle;//0文字/1图片
//itemStyle为0时设置文字属性
@property (nonatomic, copy) NSString *itemTitle;//按钮文字
@property (nonatomic, copy) UIColor *itemTextColor;//按钮文字颜色
@property (nonatomic, copy) UIFont *itemTextFont;//按钮文字字体
@property (nonatomic, copy) UIColor *itemHighlightBackgroundColor;//按钮高亮颜色
//itemStyle为1时设置图片属性
@property (nonatomic, copy) UIImage *itemImage;//图片
@property (nonatomic,assign) CGSize imgSize;//图片大小
@property (nonatomic,assign) CGFloat itemWidth;//项大小
//点击事件回调
@property (copy, readwrite, nonatomic) void (^onClick)(void);

@end

//导航条
@interface WTCustomNavBar : UIView
@property (nonatomic,copy) NSString *title;//标题
@property (nonatomic,copy) UIColor *titleColor;//标题颜色
@property (nonatomic,copy) UIFont *titleFont;//标题字体
@property (nonatomic,copy) UIColor *bgColor;//背景颜色
@property (nonatomic,copy) UIColor *lineColor;//底部线条颜色

@property (nonatomic, copy) NSArray *rightItemList;
@property (nonatomic, copy) NSArray *leftItemList;
@end
