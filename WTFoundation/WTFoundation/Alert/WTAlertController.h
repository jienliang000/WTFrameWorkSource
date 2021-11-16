//
//  WTAlertController.h
//  ZXUIKit
//
//  Created by jienliang on 2019/9/2.
//  Copyright © 2019 jienliang. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WTAlertActionStyle) {
    WTAlertActionStyleHighlighted = 0, // 智学主色调
    WTAlertActionStyleNormal, // 黑色
    WTAlertActionStyleCancel
};

typedef NS_ENUM(NSInteger, WTAlertControllerStyle) {
    WTAlertControllerStyleActionSheet = 0,
    WTAlertControllerStyleAlert
};

@interface WTAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(WTAlertActionStyle)style handler:(void (^ __nullable)(WTAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) WTAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end

@interface WTAlertController : UIViewController

+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(WTAlertControllerStyle)preferredStyle;
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title attributedMessage:(nullable NSAttributedString *)attributedMessage preferredStyle:(WTAlertControllerStyle)preferredStyle;

- (void)addAction:(WTAlertAction *)action;
@property (nonatomic, readonly) NSArray<WTAlertAction *> *actions;
@property (nonatomic, nullable) WTAlertAction *preferredAction;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) UIView *contentView;

/// message内容文字对齐方式，默认NSTextAlignmentCenter
@property (nonatomic) NSTextAlignment messageAlignment;
/// 通过attributedString指定message，message和messageAlignment不再生效
@property (nullable, nonatomic, copy) NSAttributedString *attributedMessage;
/// 是否允许自动旋转，默认为NO
@property (nonatomic, getter=isAutorotateEnabled) BOOL autorotateEnabled;

@property (nonatomic, readonly) WTAlertControllerStyle preferredStyle;

@end

NS_ASSUME_NONNULL_END
