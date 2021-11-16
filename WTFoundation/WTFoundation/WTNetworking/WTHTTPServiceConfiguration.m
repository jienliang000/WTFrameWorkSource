//
//  WTHTTPServiceConfiguration.m
//  WTFoundation
//
//  Created by 计恩良 on 2016/9/30.
//  Copyright © 2016年 elji. All rights reserved.
//

#import "WTHTTPServiceConfiguration.h"
@interface WTHTTPServiceConfiguration ()
@end

@implementation WTHTTPServiceConfiguration

static NSString *_successValue = @"000";
static NSString *_tokenErrorCode = @"10001";

static NSString *_dataKey = @"data";
static NSString *_codeKey = @"code";
static NSString *_errorMessageKey = @"message";
static NSString *_host = @"";
+ (NSString *)successValue {
    return _successValue;
}

+ (void)setSuccessValue:(NSString *)bizCode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _successValue = [bizCode copy];
    });
}

+ (NSString *)host {
    return _host;
}

+ (void)setHost:(NSString *)host {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _host = [host copy];
    });
}

+ (NSString *)dataKey {
    return _dataKey;
}

+ (void)setDataKey:(NSString *)bizCode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dataKey = [bizCode copy];
    });
}

+ (NSString *)codeKey {
    return _codeKey;
}

+ (void)setCodeKey:(NSString *)bizCode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _codeKey = [bizCode copy];
    });
}

+ (NSString *)errorMessageKey {
    return _errorMessageKey;
}

+ (void)setErrorMessageKey:(NSString *)bizCode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _errorMessageKey = [bizCode copy];
    });
}

+ (NSString *)tokenErrorCode {
    return _tokenErrorCode;
}

+ (void)setTokenErrorCode:(NSString *)bizCode {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tokenErrorCode = [bizCode copy];
    });
}

@end
