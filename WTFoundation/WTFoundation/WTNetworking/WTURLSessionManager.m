//
//  WTURLSessionManager.m
//  ZXFoundation
//
//  Created by 计恩良 on 2019/11/11.
//  Copyright © 2019 Anhui WTProject Technology Co.,Ltd. All rights reserved.
//
#import "WTURLSessionManager.h"
#import "WTHTTPRequestBuilder.h"
#import <AFNetworking/AFNetworking.h>
@interface WTURLSessionManager ()
@property (nonatomic) AFURLSessionManager *manager;
@end

@implementation WTURLSessionManager

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
	self = [super init];
	if (self) {
		self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
		self.manager.responseSerializer = responseSerializer;
        self.manager.securityPolicy = [self p_securityPolicy];
	}
	return self;
}

- (instancetype)init {
	return [self initWithSessionConfiguration:nil];
}


- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse * _Nonnull, id _Nullable, NSError * _Nullable))completionHandler {
	return [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
}

- (AFSecurityPolicy *)p_securityPolicy {
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO//如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}

@end
