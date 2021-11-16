//
//  WTStringUtil.m
//  WTFoundation
//
//  Created by jienliang on 16/11/22.
//  Copyright © 2016年 jienliang. All rights reserved.
//

#import "WTStringUtil.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
@implementation WTStringUtil
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)trim:(NSString *)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)strNilOrEmpty:(NSString *)str {
    return str == nil
    || str == NULL
    || [str isKindOfClass:[NSNull class]]
    ||([str respondsToSelector:@selector(length)]
       && [(NSData *)str length] == 0)
    || ([str respondsToSelector:@selector(count)]
        && [(NSArray *)str count] == 0);
}

+ (NSString *)strRelay:(NSString *)str
{
    if([WTStringUtil strNilOrEmpty:str]){
        return @"";
    }
    else if([str isKindOfClass:[NSString class]]){
        return str;
    } else if ([str isKindOfClass:[NSNumber class]]) {
        return [((NSNumber *)str) stringValue];
    }
    return [WTStringUtil trim:str];
}

+ (NSString *)getUUID {
    CFUUIDRef UUIDobj = CFUUIDCreate(nil);
    NSString *uuid = (__bridge_transfer NSString*)CFUUIDCreateString(nil, UUIDobj);
    CFRelease(UUIDobj);
    return uuid;
}

+ (BOOL)containsEmojiInString:(NSString *)string {
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              const unichar high = [substring characterAtIndex: 0];
                              
                              // Surrogate pair (U+1D000-1F9FF)
                              if (0xD800 <= high && high <= 0xDBFF) {
                                  const unichar low = [substring characterAtIndex: 1];
                                  const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                  
                                  if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                      returnValue = YES;
                                  }
                                  
                                  // Not surrogate pair (U+2100-27BF)
                              } else {
                                  if (0x2100 <= high && high <= 0x27BF){
                                      returnValue = YES;
                                  }
                              }
                          }];
    
    return returnValue;
}

@end
