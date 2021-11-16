//
//  WTTextField.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTTextField : UITextField
@property (nonatomic,assign) int maxLen;
@property (nonatomic,assign) BOOL hasCopyAndPast;
@property (nonatomic,copy) UIColor *placeHolderColor;
@property (copy, readwrite, nonatomic) void (^textFieldDidChanged)(void);

@end
