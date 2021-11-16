//
//  WTUIKitUtil.m
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/25.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTUIKitUtil.h"

@implementation WTUIKitUtil
+ (BOOL)isIphoneX {
    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.f;
    }
    return isPhoneX;
}

+ (CGFloat)getUIKitScale {
    if ([UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height) {
        return [UIScreen mainScreen].bounds.size.width / 375;
    }
    return [UIScreen mainScreen].bounds.size.height / 375;
}

+ (void)showAlertWithTitle:(NSString *)titleText message:(NSString *)messageText buttonTitle:(NSString *)buttonTitle controller:(UIViewController *)controller handler:(void (^)(WTAlertAction *action))handler {
    WTAlertAction *okAction = [WTAlertAction actionWithTitle:buttonTitle style:WTAlertActionStyleHighlighted handler:handler];
    WTAlertController *alert = [WTAlertController alertControllerWithTitle:titleText message:messageText preferredStyle:WTAlertControllerStyleAlert];
    [alert addAction:okAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString *)titleText message:(NSString *)messageText leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle controller:(UIViewController *)controller leftHandler:(void (^)(WTAlertAction *action))leftHandler rightHandler:(void (^)(WTAlertAction *action))rightHandler {
    WTAlertController *alertController = [WTAlertController alertControllerWithTitle:titleText message:messageText preferredStyle:WTAlertControllerStyleAlert];
    WTAlertAction* actionDefault = [WTAlertAction actionWithTitle:rightButtonTitle style:WTAlertActionStyleHighlighted handler:rightHandler];
    [alertController addAction:actionDefault];
    
    WTAlertAction* actionCancel = [WTAlertAction actionWithTitle:leftButtonTitle style:WTAlertActionStyleNormal handler:leftHandler];
    [alertController addAction:actionCancel];
    
    [controller presentViewController:alertController animated:YES completion:nil];
}

@end
