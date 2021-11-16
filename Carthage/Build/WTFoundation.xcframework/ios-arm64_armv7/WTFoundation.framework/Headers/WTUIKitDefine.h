//
//  WTUIKitDefine.h
//  WTUIKit
//
//  Created by 计恩良 on 2020/8/24.
//  Copyright © 2020 计恩良. All rights reserved.
//

#ifndef WTUIKitDefine_h
#define WTUIKitDefine_h
#define WT_Scale  [WTUIKitUtil getUIKitScale]

/**
 *  @brief  RGB颜色
 */
#define WTColor(r,g,b) WTColorRGBA(r,g,b,1.0)
/**
 *  @brief  RGBA颜色.
 */
#define WTColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
/**
 *  @brief  16进制颜色.
 */
#define WTColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 *  @brief  16进制颜色.
 */
#define WTColorHexA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
/**
 *  @brief  随机颜色.
 */
#define WT_RANDOM_COLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]


/**
 *    @brief    系统字体.
 */
#define WTFontSys(_size) [UIFont systemFontOfSize:_size * WT_Scale]
/**
 *  @brief  加粗系统字体.
 */
#define WTFontBoldSys(_size) [UIFont boldSystemFontOfSize:_size * WT_Scale]



/**
 *    @brief    屏幕宽
 */
#define WTScreenWidth [UIScreen mainScreen].bounds.size.width
/**
 *    @brief    屏高
 */
#define WTScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 *     @brief    线条高度
 */
#define WT_Line_Height  (1 / [UIScreen mainScreen].scale)

/**
 *     @brief     线条颜色
 */
#define WT_Color_Line WTColorHex(0xEBEBEB)
#define WT_Color_BackGround WTColorHex(0xF6FAF9)
/**
*     @brief     判断是否是iphoneX
*/
#define isIPhoneX [WTUIKitUtil isIphoneX]
/**
 *     @brief     底部Tab高度.
 */
#define WT_TabBar_Height WTUIConstant.tabBarHeight
/**
 *     @brief     状态栏高度.
 */
#define WT_StatusBar_Height WTUIConstant.statusBarHeight
/**
 *     @brief     导航栏高度.
 */
#define WT_NavigationBar_Height WTUIConstant.navBarHeight

/**
 *     @brief     状态栏区域高度，如果是iPhoneX加上刘海区域高度
 */
#define WT_SafeArea_Top (isIPhoneX ? 44 : 0)
/**
 *     @brief     iPhoneX底部安全区域高度
 */
#define WT_SafeArea_Bottom (isIPhoneX ? 34 : 0)

#endif
/* WTUIKitDefine_h */
