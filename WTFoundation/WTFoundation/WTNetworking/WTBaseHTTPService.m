//
//  WTBaseHTTPService.m
//  WTProject
//
//  Created by 计恩良 on 16/7/27.
//  Copyright © 2016年 elji. All rights reserved.
//

#import "WTBaseHTTPService.h"
#import "WTURLSessionManager.h"
#import "WTHTTPRequestHandler.h"
#import "WTHTTPWebRequest+Private.h"
#import "WTNetworkReachability.h"

@interface WTBaseHTTPService ()
@property (nonatomic) WTURLSessionManager *sessionManager;
@property (nonatomic) WTHTTPRequestHandler *requestHandler;
@end

@implementation WTBaseHTTPService

static id<WTTokenTimeoutErrorDelegate> _tokenTimeoutErrorDelegate = nil;

+ (id<WTTokenTimeoutErrorDelegate>)tokenTimeoutErrorDelegate {
	return _tokenTimeoutErrorDelegate;
}

+ (void)setTokenTimeoutErrorDelegate:(id<WTTokenTimeoutErrorDelegate>)tokenTimeoutErrorDelegate {
	_tokenTimeoutErrorDelegate = tokenTimeoutErrorDelegate;
}

- (NSString *)token {
    return nil;//ZXProductManager.shared.userManager.token;
}

- (instancetype)initWithParams:(WTHTTPServiceConfiguration *)params {
	self = [super init];
	if (self) {
		_sessionManager = [[WTURLSessionManager alloc] initWithSessionConfiguration:params.sessionConfiguration];
		_requestHandler = [[WTHTTPRequestHandler alloc] initWithBaseURL:params.baseURL sessionManager:_sessionManager];
    }
	return self;
}

- (NSURLSessionDataTask *)doRequest:(WTHTTPWebRequest *)request completionHandler:(void (^)(id, NSError *))completionHandler {
	NSURLSessionDataTask *task = [self directlyRequest:request completion:completionHandler];
	return task;
}

- (NSURLSessionDataTask *)directlyRequest:(WTHTTPWebRequest *)request completion:(void (^)(id, NSError *))completion {
	NSURLSessionDataTask *task = [request getResponse:^(id result, NSError *error) {
        NSLog(@"网络请求url:%@ >>>>>>>   response=%@  >>>>>>>  error=%@",request.URLPath,result,error);
		// 处理token过期的情况
        if (error.code == [WTHTTPServiceConfiguration.tokenErrorCode integerValue]) {
            NSLog(@"token timeout.");
			if (WTBaseHTTPService.tokenTimeoutErrorDelegate && ++request.tokenTimeoutCount < request.tokenTimeoutMaxRetryCount) {
                // 设置了TOKEN_TIMEOUT错误处理器，则进行处理
				[WTBaseHTTPService.tokenTimeoutErrorDelegate handleTokenTimeoutErrorWithCompletionHandler:^(NSString *newToken, NSError *tokenError) {
					if (!tokenError) {
                        NSLog(@"handle token timeout OK.");
						// 处理成功，重设request的token，并重新请求
						request.token = newToken;
						[self directlyRequest:request completion:completion];
					} else {
                        NSLog(@"handle token timeout error: %@", tokenError);
                        completion(result, tokenError);
					}
				}];
			} else { // 没有设置TOKEN_TIMEOUT错误处理器，返回原始TOKEN_TIMEOUT错误
                NSLog(@"handle token timeout skipped. delegate: %p, count: %d.", WTBaseHTTPService.tokenTimeoutErrorDelegate, request.tokenTimeoutCount);
                completion(result, error);
			}
		} else if (completion) {
            NSLog(@"request(%@) done. error: %@", request.URLPath, error);
			completion(result, error);
		}
	}];
	[task resume];
	return task;
}

@end
