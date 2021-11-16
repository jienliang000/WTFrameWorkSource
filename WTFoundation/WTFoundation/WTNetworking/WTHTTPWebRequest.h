//
//  WTHTTPWebRequest.h
//
//  Created by 计恩良 on 16/5/11.
//  Copyright © 2016年 elji. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WTHTTPRequestHandler;
@class WTURLSessionManager;

/// HTTP Method
typedef NS_ENUM(NSInteger, WTHTTPMethod) {
	/// GET
	WTHTTPMethodGET,
	/// POST
	WTHTTPMethodPOST
};

extern NSString *const WTWebServiceResultField_ErrorCode;
extern NSString *const WTWebServiceResultField_ErrorInfo;
extern NSString *const WTWebServiceResultField_Result;
extern NSString *const WTWebServiceResultField_Systime;

/// 用于构造多段请求的数据
@interface WTHTTPWebRequestMultipartData : NSObject
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *mimeType;

- (instancetype)initWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end

@class WTHTTPWebRequest;

/// 可自定义响应结果的关键处理步骤
@protocol WTHTTPWebResponseDelegate
- (NSString *)errorCodeOfResponse:(NSDictionary *)response;
- (BOOL)response:(NSDictionary *)response isOKwithErrorCode:(NSInteger)errorCode;
- (NSString *)errorInfoOfResponse:(NSDictionary *)response;
- (id)resultObjectOfResponse:(NSDictionary *)response;
@end

/// 提供网络请求基础框架，任何具体的网络请求可以从这个类派生并实现相应的属性和方法
@interface WTHTTPWebRequest : NSObject

@property (nonatomic, strong) WTHTTPRequestHandler *requestHandler;
@property (nonatomic, copy, nullable) NSString *token;

/// 默认为GET（WTHTTPMethodGET），如有需要，可重写该属性get方法以指定为POST（WTHTTPMethodPOST）
@property (nonatomic, readonly) WTHTTPMethod method;

/// 如果有需要特殊设置的HTTP头，设置这个属性
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *HTTPHeaderFields;

/// 请求超时时间（以秒为单位）
@property (nonatomic) NSTimeInterval timeoutInterval;

/// 派生类重写这个属性返回接口url的相对路径
@property (nonatomic, copy, readonly) NSString *URLPath;

/// 派生类重写这个属性以返回POST时的body，如果同时设置了mutipartData和body，则使用mutipartData，忽略body
@property(nonatomic, copy, nullable) NSData *body;

/// 派生类重写这个属性，提供用于构造多段POST请求的数据集合
@property(nonatomic, copy, nullable) NSArray<WTHTTPWebRequestMultipartData *> *mutipartData;

@property (nonatomic, weak, nullable) id<WTHTTPWebResponseDelegate> responseDelegate;

/// designated initializer
///
/// @param requestHandler requestHandler
/// @param token token
///
/// @return webrequest instance
- (instancetype)initWithHandler:(WTHTTPRequestHandler *)requestHandler token:(nullable NSString *)token NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

/// 获取请求结果
///
/// @param completionHandler 请求完成时回调
///
/// @return session data task
- (NSURLSessionDataTask *)getResponse:(nullable void(^)(id _Nullable result, NSError * _Nullable error))completionHandler;

/// 派生类重写这个方法以向parameters中加入自己的参数
///
/// @param parameters HTTP请求的parameters
- (void)addSpecificParameters:(NSMutableDictionary *)parameters;

/// 派生类重写这个方法在成功时解析response
/// 默认直接返回responseObject
///
/// @param responseObject response对象
///
/// @return 解析得到的接口调用结果
- (nullable id)parseResponse:(id)responseObject;

/// 绝大多数情况下不关心失败情况的response，如需要根据error对失败的response做解析，重写此方法
/// 默认什么也不做，返回nil
///
/// @param responseObject response对象
/// @param error 错误描述
///
/// @return 解析得到的接口调用结果
- (nullable id)parseResponse:(id)responseObject onError:(NSError *)error;

- (void)handleResponse:(NSDictionary *)response error:(nullable NSError *)error localTime:(NSTimeInterval)localTime completion:(void (^)(id _Nullable, NSError * _Nullable))completion;

@end
