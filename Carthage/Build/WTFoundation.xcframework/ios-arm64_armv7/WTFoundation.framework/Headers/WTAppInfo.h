//
//  WTAppInfo.h
//  WTFoundation
//
//  Created by jienliang on 2017/9/15.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTAppInfo : NSObject

@property (nonatomic, readonly, class) NSString *deviceId;
@property (nonatomic, readonly, class) NSString *systemVersion;
@property (nonatomic, readonly, class) NSString *appVersion;
@property (nonatomic, readonly, class) NSString *bundleId;
@property (nonatomic, readonly, class) NSString *browserVersion;
@property (nonatomic, readonly, class) NSString *deviceType;
@property (nonatomic, readonly, class) NSString *deviceName;

@end
