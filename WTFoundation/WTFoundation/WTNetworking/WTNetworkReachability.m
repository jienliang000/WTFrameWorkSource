//
//  WTNetworkReachability.m
//  WTFoundation
//
//  Created by jienliang on 2020/4/21.
//

#import "WTNetworkReachability.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface WTNetworkReachability ()
@property (nonatomic) AFNetworkReachabilityManager *reachabilityManager;
@end

@implementation WTNetworkReachability

+ (WTNetworkReachability *)shared {
    static dispatch_once_t onceToken;
    static WTNetworkReachability *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [WTNetworkReachability reachability];
    });
    return instance;
}

+ (instancetype)reachability {
    return [[WTNetworkReachability alloc] initWithDomain:nil];
}

+ (instancetype)reachabilityWithHostName:(NSString *)hostName {
    return [[WTNetworkReachability alloc] initWithDomain:hostName];
}

- (instancetype)initWithDomain:(NSString *)domain {
    self = [super init];
    if (self) {
        self.reachabilityManager = domain.length > 0 ? [AFNetworkReachabilityManager managerForDomain:domain] : [AFNetworkReachabilityManager manager];
        
        RAC(self, reachabilityStatus) = [RACObserve(self.reachabilityManager, networkReachabilityStatus) map:^NSNumber *(NSNumber *value) {
            return @([WTNetworkReachability reachabilityStatusFromAFStatus:value.integerValue]);
        }];
        
        _reachabilityStatusChanged = [[[[[[[NSNotificationCenter.defaultCenter rac_addObserverForName:AFNetworkingReachabilityDidChangeNotification object:nil]
            takeUntil:self.rac_willDeallocSignal]
            distinctUntilChanged]
            map:^NSNumber *(NSNotification *value) {
                NSNumber *afStatus = value.userInfo[AFNetworkingReachabilityNotificationStatusItem];
                return @([WTNetworkReachability reachabilityStatusFromAFStatus:afStatus.integerValue]);
            }]
            deliverOn:RACScheduler.mainThreadScheduler]
            replayLast]
            setNameWithFormat:@"%@ -reachabilityStatusChanged", self];
        }
    return self;
}

- (void)startMonitor {
    [self.reachabilityManager startMonitoring];
}

- (void)stopMonitor {
    [self.reachabilityManager stopMonitoring];
}

+ (WTNetworkReachabilityStatus)reachabilityStatusFromAFStatus:(AFNetworkReachabilityStatus)afStatus {
    WTNetworkReachabilityStatus status;
    switch (afStatus) {
        case AFNetworkReachabilityStatusNotReachable:
            status = WTNetworkReachabilityStatusUnreachable;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            status = WTNetworkReachabilityStatusReachableViaWiFi;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            status = WTNetworkReachabilityStatusReachableViaWWAN;
            break;
            
        default:
            status = WTNetworkReachabilityStatusUnknown;
            break;
    }
    return status;
}

- (BOOL)isReachable {
    return self.reachabilityManager.isReachable;
}

- (BOOL)isReachableViaWWAN {
    return self.reachabilityManager.isReachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
    return self.reachabilityManager.isReachableViaWiFi;
}

- (void)dealloc {
    [self stopMonitor];
}

@end
