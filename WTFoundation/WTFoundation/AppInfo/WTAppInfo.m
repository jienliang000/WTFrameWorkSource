//
//  WTAppInfo.m
//  WTFoundation
//
//  Created by jienliang on 2017/9/15.
//  Copyright © 2017年 jienliang. All rights reserved.
//

#import "WTAppInfo.h"
@import AdSupport.ASIdentifierManager;
@import UIKit.UIDevice;
#import <sys/utsname.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation WTAppInfo

+ (NSString *)deviceId {
    __block NSString *idfaStr = nil;
    // iOS14方式访问 IDFA
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                idfaStr = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
            }
        }];
    } else {
        // 使用原方式访问 IDFA
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfaStr = ASIdentifierManager.sharedManager.advertisingIdentifier.UUIDString;
        }
    }
    return idfaStr;
}

+ (NSString *)systemVersion {
    return UIDevice.currentDevice.systemVersion;
}

+ (NSString *)appVersion {
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)bundleId {
	return NSBundle.mainBundle.bundleIdentifier;
}

+ (NSString *)browserVersion {
	static NSString *version = nil;
	
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		version = [NSString stringWithFormat:@"iOS_%@", WTAppInfo.appVersion];
	});
	
	return version;
}

+ (NSString *)deviceType {
    static NSString *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        model = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    });
    return model;
}

+ (NSString *)deviceName {
    return UIDevice.currentDevice.name;
}

@end
