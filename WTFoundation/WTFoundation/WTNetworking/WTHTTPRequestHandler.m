//
//  WTHTTPRequestHandler.m
//
//  Created by jienliang on 16/5/5.
//

#import "WTHTTPRequestHandler.h"
#import "WTURLSessionManager.h"

NSString * const WTWebServiceErrorDomain = @"com.jienliang.epd.error.NAL.request";

static NSString * const kHTTPMethod_GET = @"GET";
static NSString * const kHTTPMethod_POST = @"POST";

/// 网络请求错误的错误描述
static NSString * const kErrorDescription_Networking = @"网络请求失败";
/// JSON数据解析失败的错误描述
NSString * const WTErrorDescriptionInvalidData = @"数据解析错误";


@implementation WTHTTPRequestHandler

- (instancetype)initWithBaseURL:(NSString *)baseURL sessionManager:(WTURLSessionManager *)sessionManager {
    self = [super init];
    if (self) {
        self.baseURL = baseURL;
        self.sessionManager = sessionManager;
    }
    return self;
}


- (NSURLSessionDataTask *)GET:(NSString *)path parameters:(NSDictionary *)parameters HTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields timeoutInterval:(NSTimeInterval)timeoutInterval localTime:(NSTimeInterval)localTime completionHandler:(void (^)(id, NSError *))completionHandler {
	
	return [self p_doRequest:kHTTPMethod_GET path:path parameters:parameters HTTPHeaderFields:HTTPHeaderFields body:nil sessionManager:_sessionManager timeoutInterval:timeoutInterval localTime:localTime completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)POST:(NSString *)path parameters:(NSDictionary *)parameters HTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields body:(NSData *)body timeoutInterval:(NSTimeInterval)timeoutInterval localTime:(NSTimeInterval)localTime completionHandler:(void(^)(id responseObject, NSError *error))completionHandler {
	return [self p_doRequest:kHTTPMethod_POST path:path parameters:parameters HTTPHeaderFields:HTTPHeaderFields body:body sessionManager:_sessionManager timeoutInterval:timeoutInterval localTime:localTime completionHandler:completionHandler];
}

// pp add
- (NSURLSessionDataTask *)POST:(NSString *)path
					parameters:(NSDictionary *)parameters
	 constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
			   timeoutInterval:(NSTimeInterval)timeoutInterval
					 localTime:(NSTimeInterval)localTime
			 completionHandler:(void (^)(id, NSError *))completionHandler {
	return [self POST:path parameters:parameters HTTPHeaderFields:nil constructingBodyWithBlock:block timeoutInterval:timeoutInterval localTime:localTime completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)POST:(NSString *)path
                    parameters:(NSDictionary *)parameters
			  HTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields
     constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
               timeoutInterval:(NSTimeInterval)timeoutInterval
					 localTime:(NSTimeInterval)localTime
             completionHandler:(void (^)(id, NSError *))completionHandler {
	return [self p_doRequest:kHTTPMethod_POST path:path parameters:parameters HTTPHeaderFields:HTTPHeaderFields body:nil constructingBodyWithBlock:block sessionManager:_sessionManager timeoutInterval:timeoutInterval localTime:localTime completionHandler:completionHandler];
}

- (NSURLSessionDataTask *)p_doRequest:(NSString *)method path:(nullable NSString *)path parameters:(NSDictionary *)parameters HTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields body:(NSData *)body constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block sessionManager:(WTURLSessionManager *)sessionManager timeoutInterval:(NSTimeInterval)timeoutInterval localTime:(NSTimeInterval)localTime completionHandler:(void (^)(id, NSError *))completionHandler {
    // build the request
    WTHTTPRequestBuilder *requestBuilder = [WTHTTPRequestBuilder builder];
    requestBuilder.timeoutInterval = timeoutInterval;
	[requestBuilder setQueryStringSerializationWithBlock:[self.delegate queryStringSerializationBlock]];
	
	[HTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
		[requestBuilder setValue:obj forHTTPHeaderField:key];
	}];    
    // format the absolute URL
    NSMutableString *url = [[NSMutableString alloc] init];
    if (self.baseURL) {
        [url appendString:self.baseURL];
    }
    if (path) {
        [url appendString:path];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    if (block) {
        request = [requestBuilder requestWithMethod:method URLString:url parameters:parameters constructingBodyWithBlock:block error:&serializationError];
    } else {
        request = [requestBuilder requestWithMethod:method URLString:url parameters:parameters error:&serializationError];
    }
    
    
    if (serializationError) {
        if (completionHandler) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    // add the request body
    if (body) {
        request.HTTPBody = body;
    }
	
    // start the task
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!completionHandler) {
            return;
        }
        // network request error
        if (error) {
            NSLog(@"request task error: %@", error);
			NSError *networkingError = [NSError errorWithDomain:WTWebServiceErrorDomain code:WTWebServiceNetworkRequestError userInfo:@{NSLocalizedDescriptionKey:kErrorDescription_Networking, NSUnderlyingErrorKey: error}];
            completionHandler(nil, networkingError);
            return;
        }

        NSError *parseError = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
		
        if (!parseError) {
			/// JSON解析成功，且结果格式基本正确
			completionHandler(json, nil);
        } else { // the JSON structure doesn't match out expectations
            NSLog(@"parse data error: %@", error);
			NSError *invalidDataError = [NSError errorWithDomain:WTWebServiceErrorDomain code:WTWebServiceInvalidJSONDataError userInfo:@{NSLocalizedDescriptionKey:WTErrorDescriptionInvalidData, NSUnderlyingErrorKey: parseError}];
			
            completionHandler(nil, invalidDataError);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}

- (NSURLSessionDataTask *)p_doRequest:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters HTTPHeaderFields:(NSDictionary<NSString *, NSString *> *)HTTPHeaderFields body:(NSData *)body sessionManager:(WTURLSessionManager *)sessionManager timeoutInterval:(NSTimeInterval)timeoutInterval localTime:(NSTimeInterval)localTime completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler {
    
	return [self p_doRequest:method path:path parameters:parameters HTTPHeaderFields:HTTPHeaderFields body:body constructingBodyWithBlock:nil sessionManager:sessionManager timeoutInterval:timeoutInterval localTime:localTime completionHandler:completionHandler];
}
@end
