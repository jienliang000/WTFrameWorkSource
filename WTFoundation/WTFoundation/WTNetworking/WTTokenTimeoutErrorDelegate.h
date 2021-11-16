//
//  WTTokenTimeoutErrorDelegate.h
//  WTFoundation
//
//  Created by jienliang on 2016/9/30.
//

#import <Foundation/Foundation.h>
/// 用于处理TOKEN_TIMEOUT错误的委托
@protocol WTTokenTimeoutErrorDelegate <NSObject>
- (void)handleTokenTimeoutErrorWithCompletionHandler:(void (^)(NSString * _Nullable newToken, NSError * _Nullable tokenError))completionHandler;
@end
