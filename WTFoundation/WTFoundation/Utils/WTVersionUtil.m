//
//  WTVersionUtil.m
//  XZXBusiness
//
//  Created by 施博 on 2019/8/15.
//  Copyright © 2019 iflytek. All rights reserved.
//

#import "WTVersionUtil.h"
#import "WTAppInfo.h"
#define ZX_VERSION_SEGMENT_COUNT 3
#define ZX_MODULE_UPDATE_INFO_KEY @"moduleUpdateInfo"

@implementation WTVersionUtil

+ (BOOL)isInScopeOfLowestVersion:(NSString *)lowestVersion highestVersion:(NSString *)highestVersion {
    NSArray<NSNumber *> *currentVersionSegments = [self splitVersion:WTAppInfo.appVersion];
    
    NSArray<NSNumber *> *lowestVersionSegments = nil;
    if (lowestVersion) {
        lowestVersionSegments = [self splitVersion:lowestVersion];
        
        if ([self isVersion:currentVersionSegments lowerThanVersion:lowestVersionSegments]) {
            return NO;
        }
    }
    
    NSArray<NSNumber *> *highestVersionSegments = nil;
    if (highestVersion) {
        highestVersionSegments = [self splitVersion:highestVersion];
        
        if ([self isVersion:highestVersionSegments lowerThanVersion:currentVersionSegments]) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSArray<NSNumber *> *)splitVersion:(NSString *)versionString {
    NSArray<NSString *> *version = [versionString componentsSeparatedByString:@"."];
    // 保证解析为3段并自动填补空缺为0
    NSMutableArray<NSNumber *> *ret = [[NSMutableArray alloc] initWithObjects:@(0), @(0), @(0), nil];
    for (int i = 0; i < ZX_VERSION_SEGMENT_COUNT && i < version.count; i++) {
        ret[i] = @(version[i].intValue);
    }
    
    return ret;
}

+ (BOOL)isVersion:(NSArray<NSNumber *> *)lhsVersion lowerThanVersion:(NSArray<NSNumber *> *)rhsVersion {
    int lhsMajor = lhsVersion[WTVersionSegmentMajor].intValue;
    int lhsMinor = lhsVersion[WTVersionSegmentMinor].intValue;
    int lhsBuild = lhsVersion[WTVersionSegmentBuild].intValue;
    int rhsMajor = rhsVersion[WTVersionSegmentMajor].intValue;
    int rhsMinor = rhsVersion[WTVersionSegmentMinor].intValue;
    int rhsBuild = rhsVersion[WTVersionSegmentBuild].intValue;
    
    if (lhsMajor < rhsMajor) {
        return YES;
    } else if (lhsMajor > rhsMajor) {
        return NO;
    } else if (lhsMinor < rhsMinor) { // major == major
        return YES;
    } else if (lhsMinor > rhsMinor) {
        return NO;
    } else { // major == major, minor == minor
        return lhsBuild < rhsBuild;
    }
}
@end
