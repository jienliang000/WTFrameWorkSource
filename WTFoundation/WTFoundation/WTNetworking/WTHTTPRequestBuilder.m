//
//  ZXHTTPRequestBuilder.m
//  ZXFoundation
//
//  Created by 计恩良 on 2019/11/11.
//  Copyright © 2019 Anhui WTProject Technology Co.,Ltd. All rights reserved.
//

#import "WTHTTPRequestBuilder.h"
#import "WTMultipartFormDataPrivate.h"
#import <AFNetworking/AFNetworking.h>

NSString * const WTURLRequestSerializationErrorDomain = @"com.elji.epd.error.serialization.request";

@interface WTHTTPRequestBuilder ()
@property (nonatomic) AFHTTPRequestSerializer *requestSerializer;
@end

@implementation WTHTTPRequestBuilder

- (instancetype)init {
	self = [super init];
	if (self) {
//		_requestSerializer = [AFHTTPRequestSerializer serializer];
        _requestSerializer = [AFJSONRequestSerializer serializer];
	}
	
	return self;
}

+ (instancetype)builder {
	return [[self alloc] init];
}

#pragma mark - delegate to AFHTTPRequestSerializer

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters error:(NSError *__autoreleasing  _Nullable *)error {
	NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
	
	if (error && *error) {
		*error = [NSError errorWithDomain:WTURLRequestSerializationErrorDomain code:RequestSerializationFailed userInfo:nil];
	}
	
	return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                 constructingBodyWithBlock:(void (^)(id<WTMultipartFormData> formData))block
                                     error:(NSError **)error {
    
    void (^afBlock)(id<AFMultipartFormData> afFormData) = ^(id<AFMultipartFormData> afFormData) {
        WTMultipartFormData *mfd = [[WTMultipartFormData alloc] init];
        mfd.afFormData = afFormData;
        block(mfd);
    };

    NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:afBlock error:error];
    if (error && *error) {
        *error = [NSError errorWithDomain:WTURLRequestSerializationErrorDomain code:RequestSerializationFailed userInfo:nil];
    }
    
    return request;
}

- (NSStringEncoding)stringEncoding {
	return self.requestSerializer.stringEncoding;
}

- (void)setStringEncoding:(NSStringEncoding)stringEncoding {
	self.requestSerializer.stringEncoding = stringEncoding;
}

- (BOOL)allowsCellularAccess {
	return self.requestSerializer.allowsCellularAccess;
}

- (void)setAllowsCellularAccess:(BOOL)allowsCellularAccess {
	self.requestSerializer.allowsCellularAccess = allowsCellularAccess;
}

- (NSTimeInterval)timeoutInterval {
	return self.requestSerializer.timeoutInterval;
}

- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval {
	self.requestSerializer.timeoutInterval = timeoutInterval;
}

- (NSDictionary<NSString *,NSString *> *)HTTPRequestHeaders {
	return self.requestSerializer.HTTPRequestHeaders;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
	[self.requestSerializer setValue:value forHTTPHeaderField:field];
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
	return [self.requestSerializer valueForHTTPHeaderField:field];
}

- (void)setQueryStringSerializationWithBlock:(NSString * _Nonnull (^)(NSURLRequest * _Nonnull, id _Nonnull, NSError * _Nullable __autoreleasing * _Nullable))block {
	[self.requestSerializer setQueryStringSerializationWithBlock:block];
}

@end
