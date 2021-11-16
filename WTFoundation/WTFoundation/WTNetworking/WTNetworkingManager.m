//
//  WTNetworkingManager.m
//  XWTBusiness
//
//  Created by 计恩良 on 2019/8/19.
//  Copyright © 2019 elji. All rights reserved.
//

#import "WTNetworkingManager.h"
#import "WTBaseHTTPService.h"
@import ReactiveObjC;
@interface WTNetworkingManager ()
@property (nonatomic) WTBaseHTTPService *httpService;
@end

@implementation WTNetworkingManager

- (instancetype)initWithParams:(WTHTTPServiceConfiguration *)params {
    self = [super init];
    if (self) {
        self.httpService = [[WTBaseHTTPService alloc] initWithParams:params];
    }
    return self;
}

- (instancetype)init {
    return [self initWithParams:[[WTHTTPServiceConfiguration alloc] init]];
}

- (NSURLSessionTask *)requestWithParams:(WTNetworkingParams *)params completion:(void (^)(id, NSError *))completion {
    WTNetworkingRequest *request = [[WTNetworkingRequest alloc] initWithHandler:self.httpService.requestHandler params:params token:(params.token ?: self.httpService.token)];
    request.HTTPHeaderFields = params.HTTPHeaderFields;
    request.body = params.body;
    request.timeoutInterval = params.timeoutInterval;
    return [self.httpService doRequest:request completionHandler:^(id result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(result, error);
        });
    }];
}

- (RACSignal *)signalOfRequestWithParams:(WTNetworkingParams *)params {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionTask *task = [self requestWithParams:params completion:^(id result, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }] replayLast];
}

#ifdef DEBUG
- (void)dealloc {
    NSLog(@"%@(%p) dealloc.", [self class], self);
}
#endif

@end
