//
//  WTCustomNavBar.h
//  WTBaseCore
//
//  Created by jienliang on 2017/12/5.
//  Copyright © 2017年 jienliang. All rights reserved.
//
#import "WTCustomNavBar.h"
#import "WTUIKitDefine.h"
#import "WTUIConstant.h"
#import "WTImageUtil.h"
@import Masonry;
#define WT_Color_DefaultNaviTitleColor WTColorHex(0x111111)

@implementation WTCustomBarItem
- (id)init {
    if (self = [super init]) {
        self.itemWidth = 50;
        self.imgSize = CGSizeMake(20, 20);
        self.itemTextColor = WT_Color_DefaultNaviTitleColor;
        self.itemTextFont = [UIFont systemFontOfSize:14];
        self.itemHighlightBackgroundColor = [UIColor colorWithRed:231 green:231 blue:231 alpha:1];
    }
    return self;
}
@end
//自定义左右操作按钮
@interface WTCustomBarButton : UIButton
@property (nonatomic, weak) WTCustomBarItem *barItem;
@end

@implementation WTCustomBarButton
@end

@implementation WTCustomNavBar {
    UILabel *titleLab;
    UIImageView *lineImg;
}

- (id)init {
    self = [super init];
    if (self) {
        self.titleFont = [UIFont boldSystemFontOfSize:18];
        self.titleColor = WT_Color_DefaultNaviTitleColor;
        self.bgColor = [UIColor whiteColor];
        
        titleLab = [[UILabel alloc] init];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.tag = 11;
        [self addSubview:titleLab];
        
        lineImg = [[UIImageView alloc] init];
        lineImg.tag = 12;
        lineImg.backgroundColor = WTColorHex(0xEBEBEB);
        [self addSubview:lineImg];

        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(50);
            make.right.equalTo(self).offset(-50);
            make.top.mas_equalTo(WT_StatusBar_Height);
            make.height.mas_equalTo(WTUIConstant.navBarTitleHeight);
        }];
        [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).offset(0);
            make.top.mas_equalTo(WT_NavigationBar_Height-WT_Line_Height);
            make.height.mas_equalTo(WT_Line_Height);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = self.bgColor;
    if (self.lineColor) {
        lineImg.backgroundColor = self.lineColor;
    }
    titleLab.text = self.title;
    titleLab.font = self.titleFont;
    titleLab.textColor = self.titleColor;
    
    //////////布局item//////////
    for (UIView *v in [self subviews]) {
        if (v.tag!=11&&v.tag!=12) {
            [v removeFromSuperview];
        }
    }
    float offsetX = 0;
    if (self.leftItemList&&[self.leftItemList count]>0) {
        for (int i = 0; i < self.leftItemList.count; i++) {
            WTCustomBarItem *it = self.leftItemList[i];
            UIButton *btn = nil;
            if (it.itemStyle == 1) {
                btn = [self createImgBtn:it];
            } else if (it.itemStyle == 0) {
                btn = [self createTitleBtn:it];
            }
            btn.frame = CGRectMake(offsetX,btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
            offsetX = btn.frame.origin.x + btn.frame.size.width;
            [self addSubview:btn];
        }
    }

    offsetX = WTScreenWidth;
    if (self.rightItemList&&[self.rightItemList count]>0) {
        for (int i = 0; i < self.rightItemList.count; i++) {
            WTCustomBarItem *it = self.rightItemList[i];
            WTCustomBarButton *btn = nil;
            if (it.itemStyle == 1) {
                btn = [self createImgBtn:it];
            } else if (it.itemStyle == 0) {
                btn = [self createTitleBtn:it];
            }
            btn.frame = CGRectMake(offsetX-btn.frame.size.width, btn.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
            offsetX = btn.frame.origin.x;
            [self addSubview:btn];
        }
    }
}

- (WTCustomBarButton *)createImgBtn:(WTCustomBarItem *)item {
    float offsetX = (item.itemWidth-item.imgSize.width)/2;
    float offsetY = (WTUIConstant.navBarTitleHeight-item.imgSize.height)/2;
    
    WTCustomBarButton *btn = [[WTCustomBarButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-WTUIConstant.navBarTitleHeight, item.itemWidth, WTUIConstant.navBarTitleHeight)];
    [btn setImage:item.itemImage forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(offsetY, offsetX, offsetY, offsetX)];
    btn.barItem = item;
    [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnPress:(WTCustomBarButton *)btn {
    if (btn.barItem.onClick) {
        btn.barItem.onClick();
    }
}

- (WTCustomBarButton *)createTitleBtn:(WTCustomBarItem *)item {
    UIColor *ccc = [UIColor clearColor];
    CGSize sz = [self sizeForFont:item.itemTitle Font:item.itemTextFont CtrlSize:CGSizeMake(MAXFLOAT, WTUIConstant.navBarTitleHeight)];
    float w = sz.width + 8 + 8;
    if (w < item.itemWidth) {
        w = item.itemWidth;
    }
    WTCustomBarButton *btn = [[WTCustomBarButton alloc] initWithFrame:CGRectMake(0, self.frame.size.height-WTUIConstant.navBarTitleHeight, w, WTUIConstant.navBarTitleHeight)];
    [btn setTitle:item.itemTitle forState:UIControlStateNormal];
    [btn setBackgroundImage:[WTImageUtil imageWithColor:ccc] forState:UIControlStateNormal];
    [btn setBackgroundImage:[WTImageUtil imageWithColor:item.itemHighlightBackgroundColor] forState:UIControlStateHighlighted];
    [btn setTitleColor:item.itemTextColor forState:UIControlStateNormal];
    btn.titleLabel.font = item.itemTextFont;
    btn.barItem = item;
    [btn addTarget:self action:@selector(btnPress:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (CGSize)sizeForFont:(NSString *)str Font:(UIFont *)font CtrlSize:(CGSize)size
{
    CGSize sz = CGSizeZero;
    NSDictionary *attributes = @{NSFontAttributeName:font,};
    sz = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |
          NSStringDrawingUsesLineFragmentOrigin |
          NSStringDrawingUsesFontLeading
                        attributes:attributes
                           context:nil].size;
    return sz;
}
@end
