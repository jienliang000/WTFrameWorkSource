//
//  WTHTTPServiceConfiguration.h
//  WTFoundation
//
//  Created by 计恩良 on 2016/9/30.
//  Copyright © 2016年 elji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTHTTPServiceConfiguration : NSObject
//网络请求成功码
@property (class, nonatomic, copy) NSString *successValue;
//token过期错误码
@property (class, nonatomic, copy) NSString *tokenErrorCode;

//网络请求数据内容key
@property (class, nonatomic, copy) NSString *dataKey;
@property (class, nonatomic, copy) NSString *codeKey;
@property (class, nonatomic, copy) NSString *errorMessageKey;

@property (class, nonatomic, copy) NSString *host;


@property (nonatomic, copy, nullable) NSString *baseURL;
@property (nonatomic, nullable) NSURLSessionConfiguration *sessionConfiguration;

@end
