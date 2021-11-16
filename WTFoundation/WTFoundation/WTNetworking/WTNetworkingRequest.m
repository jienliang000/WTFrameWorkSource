//
//  WTNetworkingRequest.m
//  WTBusiness
//
//  Created by jienliang on 2019/8/19.
//  Copyright © 2019 jienliang. All rights reserved.
//

#import "WTNetworkingRequest.h"

@implementation WTNetworkingParams

- (instancetype)initWithPath:(NSString *)path method:(WTHTTPMethod)method {
    self = [super init];
    if (self) {
        self.path = path;
        self.method = method;
        self.timeoutInterval = 10;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    return [self initWithPath:path method:WTHTTPMethodGET];
}

@end


@interface WTNetworkingRequest ()
@property (nonatomic, nullable) WTNetworkingParams *params;
@end

@implementation WTNetworkingRequest

- (instancetype)initWithHandler:(WTHTTPRequestHandler *)requestHandler params:(WTNetworkingParams *)params token:(NSString *)token {
    self = [super initWithHandler:requestHandler token:token];
    if (self) {
        self.params = params;
    }
    return self;
}

- (void)addSpecificParameters:(NSMutableDictionary *)parameters {
    if (self.params.arguments) {
         NSDictionary<NSString *, id> *arguments = self.params.arguments();
        [arguments enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            parameters[key] = obj;
        }];
    }
}

- (NSString *)URLPath {
    return self.params.path;
}

- (WTHTTPMethod)method {
    return self.params.method;
}

- (id)parseResponse:(id)responseObject {
    if (self.params.parseResponse) {
        return self.params.parseResponse(responseObject, nil);
    } else {
       return [super parseResponse:responseObject];
    }
}

- (id)parseResponse:(id)responseObject onError:(NSError *)error {
    if (self.params.parseResponse) {
        return self.params.parseResponse(responseObject, error);
    } else {
        return [super parseResponse:responseObject onError:error];
    }
}

@end
