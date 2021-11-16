//
//  UIButton+WebImage.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *	@brief	UIButton 拓展.
 */
@interface UIButton (WTWebImage){
}
- (void)setWebBackGroundImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeImg state:(UIControlState)state;
- (void)setWebImageWithUrl:(NSString *)url placeHolder:(UIImage *)placeImg state:(UIControlState)state;
@end
