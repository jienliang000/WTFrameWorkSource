//
//  WTBaseHTTPService.h
//  WTProject
//
//  Created by 计恩良 on 16/7/27.
//  Copyright © 2016年 elji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHTTPWebRequest.h"
#import "WTHTTPServiceConfiguration.h"
#import "WTTokenTimeoutErrorDelegate.h"

@class WTURLSessionManager;

/**
 为一类业务接口提供的封装类，维护一个WTHTTPRequestHandler对象，供WTHTTPWebRequest使用
 派生类在实现自己的业务接口时，通过创建WTHTTPWebRequest -> 调用doRequest来进行网络请求，可自动处理token过期和auth过期的问题
 */
@interface WTBaseHTTPService : NSObject

/// 为了方便派生类获取当前登录用户token
@property (nonatomic, readonly, nullable) NSString *token;

/// 处理token过期的委托
@property (class, nonatomic, weak) id<WTTokenTimeoutErrorDelegate> tokenTimeoutErrorDelegate;

@property (nonatomic, readonly) WTURLSessionManager *sessionManager;
@property (nonatomic, readonly) WTHTTPRequestHandler *requestHandler;

- (instancetype)initWithParams:(WTHTTPServiceConfiguration *)params NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

/**
 进行request请求，会特殊处理token过期和auth过期的情况
 首先尝试通过API网关请求，如果接口不支持API网关调用，则直接请求服务端接口

 @param request 需要进行请求的reqest
 @param completionHandler 请求结果回调。如果token未过期，返回request的请求结果；如果token过期但通过tokenTimeoutErrorHandler处理成功，则返回重新request请求的结果；如果token过期且未设置tokenTimeoutErrorHandler或tokenTimeoutErrorHandler处理失败，则返回token过期错误
 @return 网络请求
 */
- (NSURLSessionDataTask *)doRequest:(WTHTTPWebRequest *)request completionHandler:(void (^)(id _Nullable result, NSError * _Nullable error))completionHandler NS_SWIFT_NAME(handle(_:completion:));

/// 直接通过调用服务端接口请求
- (NSURLSessionDataTask *)directlyRequest:(WTHTTPWebRequest *)request completion:(void (^)(id _Nullable, NSError * _Nullable))completion;

@end
