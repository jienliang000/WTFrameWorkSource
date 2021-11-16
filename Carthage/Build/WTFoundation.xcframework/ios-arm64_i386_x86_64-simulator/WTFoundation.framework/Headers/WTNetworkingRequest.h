//
//  WTNetworkingRequest.h
//  WTBusiness
//
//  Created by jienliang on 2019/8/19.
//  Copyright © 2019 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WTHTTPWebRequest.h"

@interface WTNetworkingParams : NSObject
/// 请求的URL，如果WTNetworkingManager未设置baseURL，这里须设置绝对路径
@property (nonatomic, copy) NSString *path;
/// 请求方法，GET或POST，默认GET
@property (nonatomic) WTHTTPMethod method;
/// 自定义请求用token，如不设置，将使用当前用户的token
@property (nonatomic, copy, nullable) NSString *token;
/// 获取请求参数回调
@property (nonatomic, copy, nullable) NSDictionary<NSString *, id> * _Nullable (^arguments)(void);
/// 设置HTTP请求的body
@property (nonatomic, copy, nullable) NSData *body;

/// 用于解析响应结果的block，responseObject一般是NSDictionary，返回解析后得到的对象
@property (nonatomic, copy, nullable) id _Nullable (^parseResponse)(id _Nullable responseObject, NSError * _Nullable error);
/// 设置请求头信息
@property (nonatomic, copy, nullable) NSDictionary<NSString *, NSString *> *HTTPHeaderFields;
/// 请求超时时间（以秒为单位）
@property (nonatomic) NSTimeInterval timeoutInterval;

- (instancetype)initWithPath:(NSString *)path method:(WTHTTPMethod)method;
- (instancetype)initWithPath:(NSString *)path;

@end


@interface WTNetworkingRequest : WTHTTPWebRequest
- (instancetype)initWithHandler:(WTHTTPRequestHandler *)requestHandler params:(WTNetworkingParams *)params token:(nullable NSString *)token NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithHandler:(WTHTTPRequestHandler *)requestHandler token:(nullable NSString *)token NS_UNAVAILABLE;
@end
