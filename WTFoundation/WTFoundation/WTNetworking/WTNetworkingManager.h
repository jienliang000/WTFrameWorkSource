//
//  WTNetworkingManager.h
//  XWTBusiness
//
//  Created by 计恩良 on 2019/8/19.
//  Copyright © 2019 elji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHTTPServiceConfiguration.h"
#import "WTNetworkingRequest.h"
#import "WTNetworkReachability.h"

@class RACSignal;

/**
 提供通用的网络请求方法，内部通过HTTPService实现
 */
@interface WTNetworkingManager : NSObject

/**
 可通过WTHTTPServiceConfiguration设置baseURL，后续使用时WTNetworkingParams的path应该为相对路径

 @param params 初始化参数
 @return WTNetworkingManager实例
 */
- (instancetype)initWithParams:(WTHTTPServiceConfiguration *)params NS_DESIGNATED_INITIALIZER;

/**
 不设置baseURL，使用时WTNetworkingParams的path应该为绝对路径
 completion保证在主线程回调

 @return WTNetworkingManager实例
 */
- (instancetype)init;

/**
 进行网络请求

 @param params 请求所需要的参数
 @param completion 请求完成的回调
 */
- (NSURLSessionTask *)requestWithParams:(WTNetworkingParams *)params completion:(void (^)(id _Nullable result, NSError * _Nullable error))completion;

- (RACSignal *)signalOfRequestWithParams:(WTNetworkingParams *)params;

@end
