//
//  WTImageUtil.h
//  AppPublic
//
//  Created by jienliang on 2018/4/23.
//  Copyright © 2018年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 图片工具
 */
@interface WTImageUtil : NSObject

//生成纯色UIImage
+ (UIImage *)imageWithColor:(UIColor *)color;
//给图片加圆角
+ (UIImage *)roundedCornerImage:(UIImage*) rawImage cornerRadius:(CGFloat)cornerRadius;

/**
 内存处理，循环压缩处理，图片处理过程中内存不会爆增
 @param image 原始图片
 @param fImageKBytes 限制最终的文件大小
 @param completeBlock 处理之后的数据返回，data类型
 */
+ (void)compressedImageFiles:(UIImage *)image imageKB:(CGFloat)fImageKBytes completeBlock:(void(^)(NSData *imageData))completeBlock;


/**
 图片压缩（针对内存爆表出现的压缩失真分层问题的使用工具）
 @param orignalImage 原始图片
 @param fImageKBytes 最终限制
 @param completeBlock 处理之后的数据返回，data类型
 */
+ (void)resetSizeOfImage:(UIImage *)orignalImage imageKB:(CGFloat)fImageKBytes completeBlock:(void(^)(NSData *imageData))completeBlock;
@end
