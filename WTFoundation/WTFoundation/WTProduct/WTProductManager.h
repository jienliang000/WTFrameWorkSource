//
//  WTProductManager.h
//  WTFoundation
//
//  Created by jienliang on 16/7/30.
//  Copyright © 2016年 elji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTProduct.h"
typedef NS_ENUM(NSInteger, WTViewControllerShowMode) {
    /// undefined
    WTViewControllerShowModeUndefined,
    /// push
    WTViewControllerShowModePush,
    /// present
    WTViewControllerShowModePresent
};
@protocol WTProduct;
/// 创建产品VC所需参数
@interface WTProductViewControllerCreateParams : NSObject
/// 源产品Id，建议设置
@property (nonatomic, copy, nullable) NSString *sourceProductId;
/// 产品Id，只配置URL的时候可为空
@property (nonatomic, copy, nullable) NSString *productId;
/// web模式下加载的URL
@property (nonatomic, copy, nullable) NSString *URL;
/// native模式下打开产品所需参数
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *productParams;

@end

/// 创建产品VC的结果
@interface WTProductViewControllerCreateResult : NSObject
@property (nonatomic) WTViewControllerShowMode showMode;
@property (nonatomic) UIViewController * _Nullable viewController;

- (instancetype _Nullable )initWithShowMode:(WTViewControllerShowMode)showMode viewController:(UIViewController *_Nullable)viewController;

@end

@interface WTProductServiceParams : NSObject
/// 源产品Id，建议设置
@property (nonatomic, copy, nullable) NSString *sourceProductId;
/// 产品Id
@property (nonatomic, copy) NSString * _Nonnull productId;
/// 调用参数
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> *arguments;
@end

#pragma mark - WTProductManager
/// 管理产品的进入界面创建
@interface WTProductManager : NSObject

@property (class, nonatomic, readonly) WTProductManager * _Nonnull shared;
/// 根据productId获取对应的product实例
/// @param productId productId
- (nullable id<WTProduct>)productWithId:(nullable NSString *)productId;
/// 注册Product，如果内部已存在id相同的product，则注册失败
/// @param product 需注册的业务模块
- (BOOL)registerProduct:(id<WTProduct>_Nonnull)product;
/// 创建产品界面
/// @param params 创建产品VC所需参数
/// @param completion 创建完成回调，确保在主线程回调
- (void)createViewControllerWithParams:(WTProductViewControllerCreateParams *_Nonnull)params completion:(void(^_Nullable)(WTProductViewControllerCreateResult * _Nullable result, NSError * _Nullable error))completion;

- (WTProductViewControllerCreateResult *)createControllerWithParams:(WTProductViewControllerCreateParams *)params;
@end
