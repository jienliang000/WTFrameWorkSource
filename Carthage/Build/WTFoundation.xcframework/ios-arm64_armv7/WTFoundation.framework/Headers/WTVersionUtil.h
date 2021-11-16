//
//  WTVersionUtil.h
//  XZXBusiness
//
//  Created by 施博 on 2019/8/15.
//  Copyright © 2019 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WTVersionSegment) {
    WTVersionSegmentMajor,
    WTVersionSegmentMinor,
    WTVersionSegmentBuild
};

@interface WTVersionUtil : NSObject

/**
 判断app版本是否在区间[lowestVersion, highestVersion]之内
 版本号字符串应为"major.minor.build"开头，build后可扩展（如"major.minor.build.xxxx"），只判断major.minor.build

 @param lowestVersion 最低版本，如果为nil则不判断，认为当前版本号满足
 @param highestVersion 最高版本，如果为nil则不判断，认为当前版本号满足
 @return 判断结果
 */
+ (BOOL)isInScopeOfLowestVersion:(nullable NSString *)lowestVersion highestVersion:(nullable NSString *)highestVersion;

@end

