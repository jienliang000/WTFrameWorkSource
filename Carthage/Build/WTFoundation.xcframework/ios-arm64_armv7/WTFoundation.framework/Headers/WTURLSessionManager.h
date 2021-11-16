//
//  ZXURLSessionManager.h
//  ZXFoundation
//
//  Created by 计恩良 on 2019/11/11.
//  Copyright © 2019 Anhui WTProject Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTURLSessionManager : NSObject

- (instancetype) initWithSessionConfiguration:(nullable NSURLSessionConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

/**
 Creates an `NSURLSessionDataTask` with the specified request.
 
 @param request The HTTP request for the request.
 @param completionHandler A block object to be executed when the task finishes. This block has no return value and takes three arguments: the server response, the response object created by that serializer, and the error that occurred, if any.
 */
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
							completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;
@end
