//
//  WTJsonUtil.h
//  WTDemo
//
//  Created by 计恩良 on 2019/1/9.
//  Copyright © 2019年 计恩良. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface WTJsonUtil : NSObject
+ (NSString *) jsonStringWithObject:(id) object;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
