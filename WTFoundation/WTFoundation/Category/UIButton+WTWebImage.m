//
//  UIButton+WebImage.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import "UIButton+WTWebImage.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/SDWebImage.h>
static NSURL *wt_URLFromString(NSString *urlString) {
    NSString *encoded = [urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    return encoded ? [NSURL URLWithString:encoded] : nil;
}

@implementation UIButton (WTWebImage)
- (void)setWebBackGroundImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeImg state:(UIControlState)state {
    [self sd_setBackgroundImageWithURL:wt_URLFromString(url) forState:state placeholderImage:placeImg];
}

- (void)setWebImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeImg state:(UIControlState)state {
    [self sd_setImageWithURL:wt_URLFromString(url) forState:state placeholderImage:placeImg];
}
@end

