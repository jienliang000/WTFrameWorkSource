//
//  UIImageView+WTWebImage.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *	@brief	UIImageView 拓展.
 */
@interface UIImageView (WTWebImage)

- (void)setImageWithURLString:(NSString *)url;

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder;

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image, NSError *error, NSURL *imageURL))completedBlock;

///淡入式图片加载
- (void)setImageFadeLoadWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder;
@end
