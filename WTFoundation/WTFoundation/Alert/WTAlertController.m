//
//  WTAlertController.m
//  ZXUIKit
//
//  Created by jienliang on 2019/9/2.
//  Copyright © 2019 jienliang. All rights reserved.
//

#import "WTAlertController.h"
@import Masonry;
#import "WTAlertControllerTransition.h"
#import "WTUIKitDefine.h"
@interface WTAlertAction ()
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic) WTAlertActionStyle style;
@property (nonatomic, copy, nullable) void (^handler)(WTAlertAction *action);
@end

@implementation WTAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(WTAlertActionStyle)style handler:(void (^)(WTAlertAction *action))handler {
    WTAlertAction *action = [[WTAlertAction alloc] init];
    if (action) {
        action.title = title;
        action.style = style;
        action.handler = handler;
    }
    return action;
}

@end


@interface WTAlertController ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, copy) NSArray<WTAlertAction *> *actions;
@property (nonatomic) WTAlertControllerStyle preferredStyle;

@property (nonatomic) UIView *contentView;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITextView *messageTextView;
@property (nonatomic) NSArray<UIButton *> *actionButtons;
@end

@implementation WTAlertController

@dynamic title;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(WTAlertControllerStyle)preferredStyle {
    WTAlertController *controller = [[WTAlertController alloc] init];
    controller.title = title;
    controller.message = message;
    controller.preferredStyle = preferredStyle;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = controller;
        
    return controller;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title attributedMessage:(NSAttributedString *)attributedMessage preferredStyle:(WTAlertControllerStyle)preferredStyle {
    WTAlertController *controller = [[WTAlertController alloc] init];
    controller.title = title;
    controller.attributedMessage = attributedMessage;
    controller.preferredStyle = preferredStyle;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = controller;
    
    return controller;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[WTAlertControllerTransition alloc] init];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[WTAlertControllerTransition alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.actions = [[NSArray alloc] init];
        self.actionButtons = [[NSMutableArray alloc] init];
        self.messageAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = UIScreen.mainScreen.bounds;
    self.view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.7];
    
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    self.contentView.layer.cornerRadius = 6;
    
    if (self.title) {
        UILabel *titleLabel = [[UILabel alloc] init];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:self.titleLabel];
        
        titleLabel.textColor = WTColorHex(0x111111);
        titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        titleLabel.text = self.title;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    [self setupActionButtons];
    
    __weak WTAlertController *weakSelf = self;
    __weak UIView *contentView = self.contentView;
    __weak UILabel *titleLabel = self.titleLabel;
    
    UITextView *messageTextView = [[UITextView alloc] init];
    messageTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentView addSubview:messageTextView];
    
    if (self.attributedMessage.length > 0) {
        messageTextView.attributedText = self.attributedMessage;
    } else {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 8; // 字体的行间距
        paragraphStyle.paragraphSpacing = 6;
        paragraphStyle.alignment = self.messageAlignment;
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:14],
                                     NSForegroundColorAttributeName:WTColorHex(0x444444),
                                     NSParagraphStyleAttributeName:paragraphStyle};
        messageTextView.attributedText = [[NSAttributedString alloc] initWithString:self.message attributes:attributes];
    }

    
    messageTextView.editable = NO;
    NSInteger height = ceilf([messageTextView sizeThatFits:CGSizeMake(250, MAXFLOAT)].height);
    messageTextView.scrollEnabled = height > 480;
    
    [messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (height > 480) {
            make.height.equalTo(@(480));
        }
        make.bottom.equalTo(weakSelf.actionButtons.lastObject.mas_top).offset(-30);
        make.leading.equalTo(contentView.mas_leading).offset(30);
        make.trailing.equalTo(contentView.mas_trailing).offset(-30);
        if (titleLabel) {
            make.top.equalTo(titleLabel.mas_bottom).offset(20);
        } else {
            make.top.equalTo(contentView.mas_top).offset(30);
        }
    }];
    
    if (self.titleLabel) {
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(contentView.mas_leading).offset(30);
            make.centerX.equalTo(contentView.mas_centerX);
            make.top.equalTo(contentView.mas_top).offset(30);
        }];
    }
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(310));
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.height.greaterThanOrEqualTo(@(146));
    }];
}

- (void)layoutActionButtonsHorizontally {
    __weak WTAlertController *controller = self;
    __weak UIView *previousButton = nil;
    for (int i = 0; i != self.actionButtons.count; i++) {
        UIButton *button = self.actionButtons[i];
        // 从第二个按钮开始，前面追加一条竖线
        if (previousButton) {
            UIView *verticalButtonSeperator = [[UIView alloc] init];
            [self.contentView addSubview:verticalButtonSeperator];
            verticalButtonSeperator.backgroundColor = WTColorHex(0xEBEBEB);
            
            [verticalButtonSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(previousButton.mas_top);
                make.bottom.equalTo(previousButton.mas_bottom);
                make.leading.equalTo(previousButton.mas_trailing);
                make.width.equalTo(@(1));
            }];
        }
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (!previousButton) {
                make.leading.equalTo(controller.contentView.mas_leading);
                make.width.equalTo(controller.contentView.mas_width).multipliedBy(1.0 / controller.actions.count);
                make.bottom.equalTo(controller.contentView.mas_bottom);
                make.height.greaterThanOrEqualTo(@(50));
            } else {
                make.leading.equalTo(previousButton.mas_trailing);
                make.width.equalTo(previousButton.mas_width);
                make.bottom.equalTo(previousButton.mas_bottom);
                make.height.equalTo(previousButton.mas_height);
            }
        }];
        
        previousButton = button;
    }
}

- (void)layoutActionButtonsVertically {
    __weak WTAlertController *controller = self;
    __weak UIView *previousView = self.contentView;
    for (int i = 0; i != self.actionButtons.count; i++) {
        UIButton *button = self.actionButtons[i];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(previousView.mas_leading);
            make.trailing.equalTo(previousView.mas_trailing);
            make.height.greaterThanOrEqualTo(@(50));
            if (i == 0) {
                make.bottom.equalTo(previousView.mas_bottom);
            } else {
                make.bottom.equalTo(previousView.mas_top);
            }
        }];
        
        previousView = button;
        
        if (i != self.actionButtons.count - 1) {
            UIView *horizontalSeperator = [[UIView alloc] init];
            [self.contentView addSubview:horizontalSeperator];
            horizontalSeperator.backgroundColor = WTColorHex(0xEBEBEB);
            [horizontalSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(previousView.mas_top);
                make.height.equalTo(@(1));
                make.leading.equalTo(controller.contentView.mas_leading);
                make.trailing.equalTo(controller.contentView.mas_trailing);
            }];
        }
    }
}

- (void)setupActionButtons {
    [self resetActions];
    
    __weak WTAlertController *controller = self;
    
    if (self.actions.count < 3) {
        [self layoutActionButtonsHorizontally];
    } else { // self.actions.count > 2
        [self layoutActionButtonsVertically];
    }
    
    __weak UIButton *topmostButton = self.actionButtons.lastObject;
    UIView *horizontalButtonSeperator = [[UIView alloc] init];
    horizontalButtonSeperator.backgroundColor = WTColorHex(0xEBEBEB);
    [self.contentView addSubview:horizontalButtonSeperator];
    
    [horizontalButtonSeperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topmostButton.mas_top);
        make.height.equalTo(@(1));
        make.leading.equalTo(controller.contentView.mas_leading);
        make.trailing.equalTo(controller.contentView.mas_trailing);
    }];
}

- (void)resetActions {
    if (self.actions.count == 0) {
        WTAlertAction *action = [WTAlertAction actionWithTitle:@"我知道了" style:WTAlertActionStyleHighlighted handler:nil];
        [self addAction:action];
    }
    
    NSMutableArray<WTAlertAction *> *actions = [[NSMutableArray alloc] init];
    NSMutableArray<UIButton *> *actionButtons = [[NSMutableArray alloc] init];
    
    // 如果有取消，放在第一个
    NSUInteger cancelActionIndex = [self.actions indexOfObjectPassingTest:^BOOL(WTAlertAction *obj, NSUInteger idx, BOOL *stop) {
        return obj.style == WTAlertActionStyleCancel;
    }];
    
    if (cancelActionIndex != NSNotFound) {
        WTAlertAction *action = self.actions[cancelActionIndex];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:cancelButton];
        
        [cancelButton setTitle:action.title forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [cancelButton setTitleColor:WTColorHex(0x444444) forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(dismissViewControllerWithActionButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [actionButtons addObject:cancelButton];
        [actions addObject:action];
    }

    NSMutableArray<WTAlertAction *> *otherActions = [[NSMutableArray alloc] init];
    NSMutableArray<UIButton *> *otherButtons = [[NSMutableArray alloc] init];
    [self.actions enumerateObjectsUsingBlock:^(WTAlertAction *action, NSUInteger idx, BOOL *stop) {
        if (idx != cancelActionIndex) {
            UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:actionButton];
            
            [actionButton setTitle:action.title forState:UIControlStateNormal];
            actionButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
            
            // 普通按钮设为黑色，高亮设为绿色
            UIColor *color = WTColorHex(0x444444);
            if (action.style == WTAlertActionStyleHighlighted) {
                color = WTColorHex(0x05C1AE);
            }
            [actionButton setTitleColor:color forState:UIControlStateNormal];
            [actionButton addTarget:self action:@selector(dismissViewControllerWithActionButton:) forControlEvents:UIControlEventTouchUpInside];
            
            [otherButtons addObject:actionButton];
            [otherActions addObject:action];
        }
    }];

    self.actions = [actions arrayByAddingObjectsFromArray:otherActions.reverseObjectEnumerator.allObjects];
    self.actionButtons = [actionButtons arrayByAddingObjectsFromArray:otherButtons.reverseObjectEnumerator.allObjects];
}

- (void)dismissViewControllerWithActionButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        NSUInteger idx = [self.actionButtons indexOfObject:button];
        if (idx != NSNotFound && self.actions[idx].handler) {
            self.actions[idx].handler(self.actions[idx]);
        }
    }];
}

- (void)addAction:(WTAlertAction *)action {
    self.actions = [self.actions arrayByAddingObject:action];
}

- (BOOL)shouldAutorotate {
    return self.isAutorotateEnabled;
}

@end
