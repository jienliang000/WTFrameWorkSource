//
//  WTProductManager.m
//  WTFoundation
//
//  Created by jienliang on 16/7/30.
//  Copyright © 2016年 elji. All rights reserved.
//

#import "WTProductManager.h"
#import "WTWebViewController.h"
@import ReactiveObjC;
@implementation WTProductViewControllerCreateParams
@end

@implementation WTProductViewControllerCreateResult

- (instancetype)initWithShowMode:(WTViewControllerShowMode)showMode viewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        self.showMode = showMode;
        self.viewController = viewController;
    }
    return self;
}

@end

@implementation WTProductServiceParams
@end

@interface WTProductManager ()
@property (nonatomic) NSMutableDictionary<NSString *, id<WTProduct>> *products;
@property (nonatomic) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, id> *> *productExtras;
@property (nonatomic) NSOperationQueue *backgroundQueue;
@end

@implementation WTProductManager

+ (WTProductManager *)shared {
    static WTProductManager *productManager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        productManager = [[WTProductManager alloc] init];
    });
    return productManager;
}

- (instancetype)init {
	self = [super init];
	if (self) {
        self.products = [[NSMutableDictionary alloc] init];
        self.productExtras = [[NSMutableDictionary alloc] init];
        self.backgroundQueue = [[NSOperationQueue alloc] init];
        self.backgroundQueue.name = @"com.elji.Foundation.ProductManager.backgroundQueue";
	}
	return self;
}
- (WTProductViewControllerCreateResult *)createControllerWithParams:(WTProductViewControllerCreateParams *)params {
    id<WTProduct> product = [self productWithId:params.productId];
    if ([product respondsToSelector:@selector(createControllerWithParams:)]) {
        return [product createControllerWithParams:params];
    }
    return nil;
}
- (void)createViewControllerWithParams:(WTProductViewControllerCreateParams *_Nonnull)params completion:(void(^_Nullable)(WTProductViewControllerCreateResult * _Nullable result, NSError * _Nullable error))completion {
    __auto_type cmp = ^(WTProductViewControllerCreateResult *result, NSError *error) {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            completion(result, error);
        }];
    };
    
    id<WTProduct> product = [self productWithId:params.productId];
    // URL存在，优先处理web页面跳转
    if (params.URL.length > 0) {
        [self p_createWebViewControllerWithProduct:product params:params completion:cmp];
    } else {
        [self p_createNativeViewControllerWithProduct:product params:params completion:cmp];
    }
}

- (void)p_createWebViewControllerWithProduct:(id<WTProduct>)product params:(WTProductViewControllerCreateParams *)params completion:(void (^)(WTProductViewControllerCreateResult *, NSError *))completion {
    if ([product respondsToSelector:@selector(productManager:createWebViewControllerWithParams:completion:)]) {
        NSLog(@"product(%@) supply custom webViewController.", product.productId);
        [product productManager:self createWebViewControllerWithParams:params completion:completion];
    } else {
        NSLog(@"default webViewController will be used.");
        NSURL *url = [NSURL URLWithString:params.URL];
        if (url) {
            WTWebViewController *viewController = [[WTWebViewController alloc] init];
            viewController.hidesBottomBarWhenPushed = YES;
            viewController.url = url;
            completion([[WTProductViewControllerCreateResult alloc] initWithShowMode:WTViewControllerShowModePush viewController:viewController], nil);
        } else {
            completion(nil, [NSError errorWithDomain:@"WTErrorDomain" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"参数错误！"}]);
        }
    }
}

- (void)p_createNativeViewControllerWithProduct:(id<WTProduct>)product params:(WTProductViewControllerCreateParams *)params completion:(void (^)(WTProductViewControllerCreateResult * _Nullable, NSError * _Nullable))completion {
    if (!product) {
        completion(nil, [NSError errorWithDomain:@"WTErrorDomain" code:1001 userInfo:@{NSLocalizedDescriptionKey: @"参数错误！"}]);
        return;
    }
    [product productManager:self createViewControllerWithParams:params completion:^(WTProductViewControllerCreateResult *result, NSError *error) {
        completion(result, error);
    }];
}

- (id<WTProduct>)productWithId:(NSString *)productId {
    return productId.length > 0 ? self.products[productId] : nil;
}

- (BOOL)registerProduct:(id<WTProduct>)product {
    NSString *productId = product.productId;
	if (self.products[productId]) {
		NSLog(@"product of id(%@) already exist!", productId);
	}
	self.products[productId] = product;
	return YES;
}

@end

