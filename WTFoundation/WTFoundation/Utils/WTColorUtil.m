//
//  WTColorUtil.m
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/27.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTColorUtil.h"
@implementation WTColorUtil
+ (UIImage *)createImageWithSize:(CGSize)imageSize gradientColors:(NSArray *)colors percentage:(NSArray *)percents gradientType:(WTGradientType)gradientType {
    NSAssert(percents.count <= 5, @"输入颜色数量过多，如果需求数量过大，请修改locations[]数组的个数");
    
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    CGFloat locations[5];
    for (int i = 0; i < percents.count; i++) {
        locations[i] = [percents[i] floatValue];
    }
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, locations);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case WTGradientFromTopToBottom:
            start = CGPointMake(imageSize.width/2, 0.0);
            end = CGPointMake(imageSize.width/2, imageSize.height);
            break;
        case WTGradientFromLeftToRight:
            start = CGPointMake(0.0, imageSize.height/2);
            end = CGPointMake(imageSize.width, imageSize.height/2);
            break;
        case WTGradientFromLeftTopToRightBottom:
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(imageSize.width, imageSize.height);
            break;
        case WTGradientFromLeftBottomToRightTop:
            start = CGPointMake(0.0, imageSize.height);
            end = CGPointMake(imageSize.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
+ (UIColor *)randomColor {
    
    CGFloat red = (arc4random() % 255) / (CGFloat) 255;
    CGFloat green = (arc4random() % 255) / (CGFloat) 255;
    CGFloat blue = (arc4random() % 255) / (CGFloat) 255;
    UIColor *generatedColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
    
    return generatedColor;
}
+ (UIColor *) hex2UIColor:(NSString *)hexColor alpha:(CGFloat)alpha {
    if (![hexColor hasPrefix:@"#"] || (hexColor.length != 7)) {
        return nil;
    }
    
    // Remove @"#"
    NSString *cString = [hexColor substringFromIndex:1];
    NSRange rangeRed = {0,2};
    NSRange rangeGreen = {2,2};
    NSRange rangeBlue = {4,2};
    
    NSString *red = [cString substringWithRange:rangeRed];
    NSString *green = [cString substringWithRange:rangeGreen];
    NSString *blue = [cString substringWithRange:rangeBlue];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:red] scanHexInt:&r];
    [[NSScanner scannerWithString:green] scanHexInt:&g];
    [[NSScanner scannerWithString:blue] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/ 255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
}
@end
