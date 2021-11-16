//
//  WTStringUtil.h
//  WTFoundation
//
//  Created by jienliang on 16/11/22.
//  Copyright © 2016年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WTStringUtil : NSObject
/**
*    @brief    md5
*
*    @return    string.
*/
+ (NSString *)md5:(NSString *)str;
/**
*    @brief    过滤前后空格.
*
*    @return    string.
*/
+ (NSString *)trim:(NSString *)str;
/**
 *    @brief    判断是否串是否为空.
 *
 *    @return    BOOL.
 */
+ (BOOL)strNilOrEmpty:(NSString *)str;
/**
 *    @brief    格式化字符串.
 *
 *    @return    字符串实例.
 */
+ (NSString *)strRelay:(NSString *)str;
/**
 *  生成一个唯一UUID字符串
 */
+ (NSString *)getUUID;
/**
*  是否包含表情字符
*/
+ (BOOL)containsEmojiInString:(NSString *)string;
@end
