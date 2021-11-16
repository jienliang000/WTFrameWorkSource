//
//  ZXModalView.h
//  ZXPopPickerView
//
//  Created by Libo on 2018/9/1.
//  Copyright © 2018年 Cookie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXModalView : UIView
@property (strong, nonatomic) UIView *contentView;
- (instancetype)initWithView:(UIView *)view;
- (void)show;
- (void)hide;
@end
