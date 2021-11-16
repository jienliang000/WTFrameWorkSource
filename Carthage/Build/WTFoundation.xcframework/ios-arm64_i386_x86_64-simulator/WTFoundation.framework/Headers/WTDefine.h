//
//  WTDefine.h
//  WTFoundation
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//

#ifndef WTDefine_h
#define WTDefine_h
/**
 *    @brief    push一个viewController
 */
#define WTRootNavPush(vc) [(UINavigationController *)[WTCommonUtil appDelegate].window.rootViewController pushViewController:vc animated:YES]
/**
 *    @brief    弹出一个viewController
 */
#define WTRootNavPop(_ANIMATE) [(UINavigationController *)[WTCommonUtil appDelegate].window.rootViewController popViewControllerAnimated:_ANIMATE]
/**
 *  缩放比例(750*1334)
 */
#define Iphone6STransitionRatio(padding) ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? roundf((padding/2)*1.5) : roundf(padding/2))
/**
 *    @brief    系统版本号.
 */
#define WTSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

/**
 *  @brief  数组为空判断.
 */
#define WTIsArrayEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
/**
 *  @brief  字典为空判断.
 */
#define WTIsDictEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
/**
 *    @brief    注册一个接收通知
 */
#define WTNotificationAdd(notifiName,notifiSelector) \
[[NSNotificationCenter defaultCenter] addObserver:self selector:(notifiSelector) name:(notifiName) object:nil]
/**
 *    @brief    发送一个通知
 */
#define WTNotificationPost(notifiName,obj) \
[[NSNotificationCenter defaultCenter] postNotificationName:notifiName object:obj]
/**
 *    @brief    删除所有通知
 */
#define WTNotificationRemoveAll()     \
[[NSNotificationCenter defaultCenter] removeObserver:self]
/********存储数据*********/
#define WTUserDefaults [NSUserDefaults standardUserDefaults]

#define WTUserDefaultsSetObj(obj, key) \
[WTUserDefaults setObject:obj forKey:key]; \
[WTUserDefaults synchronize];

#define WTUserDefaultsObjForKey(key) [WTUserDefaults objectForKey:key]
/**
 *  @brief  弱引用.
 */
#define WT(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define WO(obj,weakObj)  __weak __typeof(&*obj)weakObj = obj;
/***GCD线程****/
//GCD - 在Main线程上运行
#ifndef dispatch_main_async_safe
#define dispatch_main_async_safe(block) dispatch_queue_async_safe(dispatch_get_main_queue(), block)
#endif

//GCD - 开启异步线程
#ifndef dispatch_queue_async_safe
#define dispatch_queue_async_safe(queue, block)\
if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {\
block();\
} else {\
dispatch_async(queue, block);\
}
#endif

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#endif
