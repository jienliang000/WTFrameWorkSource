//
//  WTHTTPWebRequest.m
//
//  Created by 计恩良 on 16/5/11.
//  Copyright © 2016年 elji. All rights reserved.
//

#import "WTURLSessionManager.h"
#import "WTHTTPWebRequest.h"
#import "WTHTTPRequestHandler.h"
#import "WTAppInfo.h"
#import "WTHTTPWebRequest+Private.h"
#import "WTHTTPServiceConfiguration.h"
static NSString * const kParameter_Token = @"token";
static const NSTimeInterval kDefaultRequestTimeout = 30;

@implementation WTHTTPWebRequestMultipartData

- (instancetype)initWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    self = [super init];
    if (self) {
        _data = data;
        _name = [name copy];
        _fileName = [fileName copy];
        _mimeType = [mimeType copy];
    }
    return self;
}

@end


@implementation WTHTTPWebRequest

@synthesize tokenTimeoutCount = _tokenTimeoutCount;
@synthesize tokenTimeoutMaxRetryCount = _tokenTimeoutMaxRetryCount;

- (NSString *)errorCodeOfResopnse:(NSDictionary *)response {
    if (self.responseDelegate) {
        return [self.responseDelegate errorCodeOfResponse:response];
    } else {
        return response[WTHTTPServiceConfiguration.codeKey];
    }
}

- (BOOL)response:(NSDictionary *)response isOKwithErrorCode:(NSInteger)errorCode {
    if (self.responseDelegate) {
        return [self.responseDelegate response:response isOKwithErrorCode:errorCode];
    } else {
        return errorCode == [WTHTTPServiceConfiguration.successValue integerValue];
    }
}

- (id)resultObjectOfResopnse:(NSDictionary *)response {
    if (self.responseDelegate) {
        return [self.responseDelegate resultObjectOfResponse:response];
    } else {
        return response[WTHTTPServiceConfiguration.dataKey];
    }
}

- (NSString *)errorInfoOfResopnse:(NSDictionary *)response {
    if (self.responseDelegate) {
        return [self.responseDelegate errorInfoOfResponse:response];
    } else {
        return response[WTHTTPServiceConfiguration.errorMessageKey];
    }
}

- (instancetype)initWithHandler:(WTHTTPRequestHandler *)requestHandler token:(NSString *)token {
    self = [super init];
    if (self) {
        self.requestHandler = requestHandler;
        self.token = token;
        self.timeoutInterval = kDefaultRequestTimeout;
        self.tokenTimeoutMaxRetryCount = 3;
    }
    return self;
}

- (WTHTTPMethod)method {
    return WTHTTPMethodGET;
}

- (NSDictionary<NSString *,NSString *> *)HTTPHeaderFields {
    NSMutableDictionary<NSString *,NSString *> *headerFields = [NSMutableDictionary dictionary];
    headerFields[@"browserVersion"] = WTAppInfo.browserVersion;
    headerFields[@"deviceId"] = WTAppInfo.deviceId;
    headerFields[@"appName"] = WTAppInfo.bundleId;
    headerFields[@"deviceName"] = [WTAppInfo.deviceName stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLUserAllowedCharacterSet];
    headerFields[@"deviceType"] = WTAppInfo.deviceType;
    if (_HTTPHeaderFields) {
        [headerFields addEntriesFromDictionary:_HTTPHeaderFields];
    }
    
    return headerFields;
}

- (NSURLSessionDataTask *)getResponse:(void (^)(id, NSError *))completionHandler {
    NSMutableDictionary<NSString *, NSString *> *parameters = [NSMutableDictionary dictionary];
    parameters[kParameter_Token] = self.token;
    // request添加自己的queryString
    [self addSpecificParameters:parameters];
    
    NSTimeInterval localTime = [[NSDate date] timeIntervalSince1970] * 1000;
    /// 处理GET请求
    if (self.method == WTHTTPMethodGET) {
        return [self.requestHandler GET:self.URLPath parameters:parameters HTTPHeaderFields:self.HTTPHeaderFields timeoutInterval:self.timeoutInterval localTime:localTime completionHandler:^(id responseObject, NSError *error) {
            [self handleResponse:responseObject error:error localTime:localTime completion:completionHandler];
        }];
    } else { /// 处理POST请求
        NSAssert(self.method == WTHTTPMethodPOST, @"undefined WTHTTPMethod");
        /// request创建POST的数据
        NSData *body = self.body;
        NSArray<WTHTTPWebRequestMultipartData *> *mpdata = self.mutipartData;
        
        /// 处理多段POST请求
        if (mpdata) {
            void (^block)(id <WTMultipartFormData> formData) = ^(id<WTMultipartFormData> formData) {
                [mpdata enumerateObjectsUsingBlock:^(WTHTTPWebRequestMultipartData *obj, NSUInteger idx, BOOL *stop) {
                    [formData appendPartWithFileData:obj.data name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
                }];
            };
            
            return [self.requestHandler POST:self.URLPath parameters:parameters HTTPHeaderFields:self.HTTPHeaderFields constructingBodyWithBlock:block timeoutInterval:self.timeoutInterval localTime:localTime completionHandler:^(id responseObject, NSError *error) {
                [self handleResponse:responseObject error:error localTime:localTime completion:completionHandler];
            }];
        } else { /// 处理普通POST请求
            return [self.requestHandler POST:self.URLPath parameters:parameters HTTPHeaderFields:self.HTTPHeaderFields body:body timeoutInterval:self.timeoutInterval localTime:localTime completionHandler:^(id responseObject, NSError *error) {
                [self handleResponse:responseObject error:error localTime:localTime completion:completionHandler];
            }];
        }
    }
}

- (void)handleResponse:(NSDictionary *)response error:(NSError *)error localTime:(NSTimeInterval)localTime completion:(void (^)(id, NSError *))completion {
    NSLog(@"request: %@(%@), error: %@", self.class, self.URLPath, error);
    if (error) {
        id result = [self parseResponse:response onError:error];
        completion(result, error);
        return;
    }
    
    id resultObject = [self resultObjectOfResopnse:response];
    
    if ([self errorCodeOfResopnse:response]) {
        NSInteger errorCode = [[self errorCodeOfResopnse:response] integerValue];
        if ([self response:response isOKwithErrorCode:errorCode]) {
            id result = nil;
            if (resultObject != [NSNull null]) {
                result = [self parseResponse:resultObject];
            }
            completion(result, nil);
        } else {
            NSString *msg = response[@"message"];
            if (msg==nil) {
                msg = WTErrorDescriptionInvalidData;
            }
            NSError *invalidDataError = [NSError errorWithDomain:WTWebServiceErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey:msg}];
            completion(resultObject, invalidDataError);
        }
    } else { /// 结果虽然是JSON格式，但是数据结构错误
        NSError *invalidDataError = [NSError errorWithDomain:WTWebServiceErrorDomain code:WTWebServiceInvalidJSONDataError userInfo:@{NSLocalizedDescriptionKey:WTErrorDescriptionInvalidData}];
        completion(resultObject, invalidDataError);
    }
}

- (void)addSpecificParameters:(NSMutableDictionary *)parameters {
}

- (NSString *)URLPath {
    NSString *reason = [NSString stringWithFormat:@"%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

- (id)parseResponse:(id)responseObject {
    return responseObject;
}

- (id)parseResponse:(id)responseObject onError:(NSError *)error {
    return nil;
}

@end
