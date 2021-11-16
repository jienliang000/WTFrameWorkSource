//
//  WTNetworkReachability.h
//  WTFoundation
//
//  Created by jienliang on 2020/4/21.
//  
//

#import <Foundation/Foundation.h>
@class RACSignal;

@class RACSignal<__covariant ValueType>;

typedef NS_ENUM(NSInteger, WTNetworkReachabilityStatus) {
    // 未知状态
    WTNetworkReachabilityStatusUnknown = -1,
    // 网络不可达
    WTNetworkReachabilityStatusUnreachable = 0,
    // 通过蜂窝网络连接
    WTNetworkReachabilityStatusReachableViaWWAN = 1,
    // 通过Wi-Fi连接
    WTNetworkReachabilityStatusReachableViaWiFi = 2,
};

@interface WTNetworkReachability : NSObject

@property (class, nonatomic, readonly) WTNetworkReachability *shared;

/// 用于检查网络的可达性
+ (instancetype)reachability;

/// 用于检查指定主机的可达性
+ (instancetype)reachabilityWithHostName:(NSString *)hostName;

/// Starts monitoring for changes in network reachability status.
- (void)startMonitor;

/// Stops monitoring for changes in network reachability status.
- (void)stopMonitor;

/// 当前的网络可达状态
@property (nonatomic, readonly) WTNetworkReachabilityStatus reachabilityStatus;

@property (nonatomic, readonly, getter=isReachable) BOOL reachable;
@property (nonatomic, readonly, getter=isReachableViaWWAN) BOOL reachableViaWWAN;
@property (nonatomic, readonly, getter=isReachableViaWiFi) BOOL reachableViaWiFi;

/// 订阅此信号，每当网络状态变化时收到通知
/// 订阅时会立刻收到当前的reachabilityStatus
@property (nonatomic, strong, readonly) RACSignal<NSNumber *> *reachabilityStatusChanged;

@end
