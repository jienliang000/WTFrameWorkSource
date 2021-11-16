//
//  WTColorUtil.h
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/27.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WTGradientType) {
    WTGradientFromTopToBottom = 1,            //从上到下
    WTGradientFromLeftToRight,                //从做到右
    WTGradientFromLeftTopToRightBottom,       //从上到下
    WTGradientFromLeftBottomToRightTop        //从上到下
};

@interface WTColorUtil : NSObject
+ (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(WTGradientType)gradientType;
+ (UIColor *)randomColor;
+ (UIColor *) hex2UIColor:(NSString *)hexColor alpha:(CGFloat)alpha;
@end

