//
//  WTHTTPRequestHandler.h
//
//  Created by jienliang on 16/5/5.
//

#import <Foundation/Foundation.h>
#import "WTHTTPRequestBuilder.h"
@class WTURLSessionManager;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const WTWebServiceErrorDomain;

extern NSString *const WTErrorDescriptionInvalidData;

typedef NS_ENUM(NSInteger, WTWebServiceErrorCode) {
	WTWebServiceNetworkRequestError = -1,
	WTWebServiceInvalidJSONDataError = -2
};


typedef NSString * _Nullable (^WTQueryStringSerializationBlock)(NSURLRequest *request, id parameters, NSError *__autoreleasing *error);


@protocol WTHTTPRequestHandlerDelegate <NSObject>
// 如果需要对queryString的构造进行特殊处理，重写此方法
- (WTQueryStringSerializationBlock) queryStringSerializationBlock;

@end


@interface WTHTTPRequestHandler : NSObject

@property (nonatomic, copy, nullable) NSString *baseURL;
@property (nonatomic) WTURLSessionManager *sessionManager;
@property (nonatomic, weak) id<WTHTTPRequestHandlerDelegate> delegate;

/**
 *  init an instance of XWTHTTPClient
 *
 *  @param baseURL        baseURL
 *  @param sessionManager sessionManager
 *  @param auth           auth
 *
 *  @return an instance of XWTHTTPClient
 */
- (instancetype)initWithBaseURL:(NSString *)baseURL sessionManager:(WTURLSessionManager *)sessionManager;

/**
 *  HTTP GET
 *
 *  @param path				 relative URL path
 *  @param parameters        query strings
 *  @param HTTPHeaderFields HTTP Header Fields
 *  @param timeoutInterval   timeout
 *  @param completionHandler the block to be called when task completed
 *
 *  @return HTTP Session Data Task
 */
- (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)parameters HTTPHeaderFields:(nullable NSDictionary<NSString *, NSString *> *)HTTPHeaderFields timeoutInterval:(NSTimeInterval)timeoutInterval localTime:(NSTimeInterval)localTime completionHandler:(nullable void(^)(id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/**
 *  HTTP POST
 *
 *  @param path         relative URL path
 *  @param parameters        query strings
 *  @param HTTPHeaderFields HTTP Header Fields
 *  @param body              http body to post
 *  @param timeoutInterval   timeout
 *  @param completionHandler the block to be called when task completed
 *
 *  @return HTTP Session Data Task
 */
- (NSURLSessionDataTask *)POST:(NSString *)path parameters:(NSDictionary *)parameters HTTPHeaderFields:(nullable NSDictionary<NSString *, NSString *> *)HTTPHeaderFields body:(NSData *)body timeoutInterval:(NSTimeInterval)timeoutInterval localTime:(NSTimeInterval)localTime completionHandler:(nullable void(^)(id _Nullable responseObject, NSError * _Nullable error))completionHandler;

- (NSURLSessionDataTask *)POST:(NSString *)path
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
               timeoutInterval:(NSTimeInterval)timeoutInterval
					 localTime:(NSTimeInterval)localTime
             completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler;

// 带有HTTPHeaderFields
- (NSURLSessionDataTask *)POST:(NSString *)path
					parameters:(NSDictionary *)parameters
			  HTTPHeaderFields:(nullable NSDictionary<NSString *, NSString *> *)HTTPHeaderFields
	 constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
			   timeoutInterval:(NSTimeInterval)timeoutInterval
					 localTime:(NSTimeInterval)localTime
			 completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler;

@end

NS_ASSUME_NONNULL_END
