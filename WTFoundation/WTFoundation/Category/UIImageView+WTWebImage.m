//
//  UIImageView+WTWebImage.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import "UIImageView+WTWebImage.h"
@import SDWebImage;
@import ReactiveObjC;

static NSURL *wt_URLFromString(NSString *urlString) {
    NSString *encoded = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return encoded ? [NSURL URLWithString:encoded] : nil;
}

@implementation UIImageView (WTWebImage)
- (void)setImageWithURLString:(NSString *)url {
    [self sd_setImageWithURL:wt_URLFromString(url)];
}

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder {
    [self sd_setImageWithURL:wt_URLFromString(url) placeholderImage:placeholder];
}

//淡入式图片加载
- (void)setImageFadeLoadWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder {
    @weakify(self);
    [self.layer removeAllAnimations];
    [self sd_setImageWithURL:wt_URLFromString(url) placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        @strongify(self);
        self.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }];
}

- (void)setImageWithURLString:(NSString *)url placeholderImage:(UIImage *)placeholder completed:(void(^)(UIImage *image, NSError *error, NSURL *imageURL))completedBlock {
    [self sd_setImageWithURL:wt_URLFromString(url) placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, imageURL);
        }
    }];
}

@end

