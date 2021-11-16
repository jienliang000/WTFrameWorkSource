//
//  WTHTTPRequestBuilder.h
//  WTFoundation
//
//  Created by jienliang on 2019/11/11.
//

#import <Foundation/Foundation.h>
#import "WTMultipartFormData.h"

FOUNDATION_EXPORT NSString * const WTURLRequestSerializationErrorDomain;

typedef NS_ENUM(NSInteger, WTURLRequestSerializationErrorCode) {
	RequestSerializationFailed = -1
};

/**
 *  HTTP请求建造器
 */
@interface WTHTTPRequestBuilder : NSObject

/**
 *  The string encoding used to serialize parameters. `NSUTF8StringEncoding` by default.
 */
@property (nonatomic, readwrite, assign) NSStringEncoding stringEncoding;

/**
 *  Whether created requests can use the device’s cellular radio (if present). `YES` by default.
 */
@property (nonatomic, readwrite, assign) BOOL allowsCellularAccess;

/**
 *  The timeout interval, in seconds, for created requests. The default timeout interval is 60 seconds.
 */
@property (nonatomic, readwrite, assign) NSTimeInterval timeoutInterval;

/**
 Default HTTP header field values to be applied to serialized requests. By default, these include the following:
 
 - `Accept-Language` with the contents of `NSLocale +preferredLanguages`
 - `User-Agent` with the contents of various bundle identifiers and OS designations
 
 @discussion To add or remove default request headers, use `setValue:forHTTPHeaderField:`.
 */
@property (readonly, nonatomic, strong) NSDictionary<NSString *, NSString *> *HTTPRequestHeaders;

/**
 *  Sets the value for the HTTP headers set in request objects made by the HTTP client. If `nil`, removes the existing value for that header.
 *
 *  @param value The HTTP header to set a default value for
 *  @param field value The value set as default for the specified header, or `nil`
 */
- (void)setValue:(nullable NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  Returns the value for the HTTP headers set in the request.
 *
 *  @param field The HTTP header to retrieve the default value for
 *
 *  @return The value set as default for the specified header, or `nil`
 */
- (nullable NSString *)valueForHTTPHeaderField:(NSString *)field;

/**
 Set the a custom method of query string serialization according to the specified block.
 
 @param block A block that defines a process of encoding parameters into a query string. This block returns the query string and takes three arguments: the request, the parameters to encode, and the error that occurred when attempting to encode parameters for the given request.
 */
- (void)setQueryStringSerializationWithBlock:(nullable NSString * (^)(NSURLRequest *request, id parameters, NSError * __autoreleasing *error))block;

/**
 *  create an instance of XZXHTTPRequestBuilder
 *
 *  @return instance of XZXHTTPRequestBuilder
 */
+ (instancetype)builder;

/**
 Creates an `NSMutableURLRequest` object with the specified HTTP method and URL string.
 
 If the HTTP method is `GET`, `HEAD`, or `DELETE`, the parameters will be used to construct a url-encoded query string that is appended to the request's URL. Otherwise, the parameters will be encoded according to the value of the `parameterEncoding` property, and set as the request body.
 
 @param method The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`. This parameter must not be `nil`.
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param error The error that occurred while constructing the request.
 
 @return An `NSMutableURLRequest` object.
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
								 URLString:(NSString *)URLString
								parameters:(nullable id)parameters
									 error:(NSError * _Nullable __autoreleasing *)error;
/**
 Creates an `NSMutableURLRequest` object with the specified HTTP method and URL string.
 
 If the HTTP method is `GET`, `HEAD`, or `DELETE`, the parameters will be used to construct a url-encoded query string that is appended to the request's URL. Otherwise, the parameters will be encoded according to the value of the `parameterEncoding` property, and set as the request body.
 
 @param method The HTTP method for the request, such as `GET`, `POST`, `PUT`, or `DELETE`. This parameter must not be `nil`.
 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be either set as a query string for `GET` requests, or the request HTTP body.
 @param block A block that takes a single argument and appends data to the HTTP body. The block argument is an object adopting the `XZXMultipartFormData` protocol.
 @param error The error that occurred while constructing the request.
 
 @return An `NSMutableURLRequest` object.
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                 URLString:(NSString *)URLString
                                parameters:(id)parameters
                 constructingBodyWithBlock:(void (^)(id <WTMultipartFormData> formData))block
                                     error:(NSError *__autoreleasing  _Nullable *)error;
@end
