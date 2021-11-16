//
//  WTCommonUtil.m
//  AppPublic
//
//  Created by jienliang on 2018/4/3.
//  Copyright © 2018年 jack Kong. All rights reserved.
//

#import "WTCommonUtil.h"

@implementation WTCommonUtil
+ (void)call:(NSString *)phoneNo
{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNo];
    if(@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

+ (BOOL)checkPrice:(NSString *)price {
    NSString *pattern = @"^([1-9]\\d*|0)(\\.\\d?[1-9])?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:price];
    return isMatch;
}

+ (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

+ (WTAppDelegate *)appDelegate {
    return ((WTAppDelegate *)[UIApplication sharedApplication].delegate);
}
@end
