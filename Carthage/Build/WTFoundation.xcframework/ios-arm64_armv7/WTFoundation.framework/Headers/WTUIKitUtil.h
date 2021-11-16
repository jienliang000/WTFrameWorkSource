//
//  WTUIKitUtil.h
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/25.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTAlertController.h"

@interface WTUIKitUtil : NSObject
/**
 *  是否是iPhone X
 */
+ (BOOL)isIphoneX;
+ (CGFloat)getUIKitScale;
+ (void)showAlertWithTitle:(NSString *)titleText message:(NSString *)messageText buttonTitle:(NSString *)buttonTitle controller:(UIViewController *)controller handler:(void (^)(WTAlertAction *action))handler;
+ (void)showAlertWithTitle:(NSString *)titleText message:(NSString *)messageText leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle controller:(UIViewController *)controller leftHandler:(void (^)(WTAlertAction *action))leftHandler rightHandler:(void (^)(WTAlertAction *action))rightHandler;
@end
