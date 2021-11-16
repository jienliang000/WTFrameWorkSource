//
//  WTProduct.h
//  WTFoundation
//
//  Created by jienliang on 16/7/29.
//  Copyright © 2016年 elji. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class WTProductManager;
@class WTProductViewControllerCreateParams;
@class WTProductViewControllerCreateResult;
@class WTProductServiceParams;

/// 定义所有接入容器的产品所需要提供的接口
@protocol WTProduct <NSObject>

/// 为该产品分配的id
@property (nonatomic, readonly) NSString * _Nonnull productId;

/// 创建产品的界面，主调方显示产品返回的VC
/// @param productManager 调用本方法的productManager对象
/// @param params 创建界面所需的参数
/// @param completion 创建界面结果回调。如果成功，viewController设置为创建的vc，error返回nil；如果无法创建，产品创建error并设置必要信息，至少包括code和userInfo，userInfo需设置NSLocalizedDescriptionKey。业务可以把error.localizedDescription作为错误提示向用户显示
- (void)productManager:(WTProductManager *_Nonnull)productManager createViewControllerWithParams:(WTProductViewControllerCreateParams *_Nonnull)params completion:(void(^_Nullable)(WTProductViewControllerCreateResult * _Nullable result, NSError * _Nullable error))completion;
/// 创建业务自定义WebViewController，用于加载产品跳转入口的web页面，不实现该方法则使用ZXWebViewController加载web页面。注意：如果实现该接口，需要完成WebViewController的初始化（例如设置URL），productManager不对result做任何特殊处理
/// @param productManager 调用本方法的productManager对象
/// @param params 创建界面所需的参数
/// @param completion 创建WebViewController结果回调
- (void)productManager:(WTProductManager *)productManager createWebViewControllerWithParams:(WTProductViewControllerCreateParams *)params completion:(void(^)(WTProductViewControllerCreateResult * _Nullable result, NSError * _Nullable error))completion;


- (WTProductViewControllerCreateResult *)createControllerWithParams:(WTProductViewControllerCreateParams *)params;
@end
