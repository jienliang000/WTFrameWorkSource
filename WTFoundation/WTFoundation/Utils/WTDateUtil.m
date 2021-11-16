//
//  WTDateUtil.m
//  IFXY
//
//  Created by admin on 2018/6/21.
//  Copyright © 2018年 IFly. All rights reserved.
//

#import "WTDateUtil.h"

@implementation WTDateUtil
+ (NSString *)date2String:(NSDate *)date format:(NSString *)format {
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:format];
     NSString *dateStr = [dateFormatter stringFromDate:date];
     return dateStr;
}

+ (NSDate *)string2Date:(NSString *)dateStr format:(NSString *)format {
     NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
     [dateFormat setDateFormat:format];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
     NSDate *date =[dateFormat dateFromString:dateStr];
     return date;
}

+ (NSString *)date2StringNow {
     NSDate *dateNow = [NSDate date];
     return [WTDateUtil date2String:dateNow format:WTDateFormatDate];
}

+ (NSString *)date2String:(NSDate *)date {
     return [WTDateUtil date2String:date format:WTDateFormatDate];
}

+ (NSString *)date2StringDay:(NSDate *)date {
     return [WTDateUtil date2String:date format:WTDateFormatDay];
}

+ (NSString *)date2StringTime:(NSDate *)date {
     return [WTDateUtil date2String:date format:WTDateFormatTime];
}

/**获取两个时间差值*/
+ (long long)getDurationStartTime:(NSString *)startTime endTime:(NSString *)endTime {
     if (startTime && endTime) {
          NSDateFormatter *strDateStr = [[NSDateFormatter alloc]init];
          [strDateStr setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
          NSDate *startdate = [strDateStr dateFromString:startTime];
          NSDate *enddate = [strDateStr dateFromString:endTime];
          //时间转时间戳的方法:
          NSTimeInterval aTime = [enddate timeIntervalSinceDate:startdate];
          return (long long)aTime;
     } else {
          return -1;
     }
}

+ (NSString *)timeIntervalSinceNow:(NSDate *)date {
    NSTimeInterval secondsInterval = [date timeIntervalSinceDate:[NSDate date]];
    BOOL isDatePast = secondsInterval < 0;
    if (isDatePast) {
        secondsInterval = -secondsInterval;
    }
    NSTimeInterval minutesInterval = secondsInterval / 60;
    NSTimeInterval hoursInterval = minutesInterval / 60;
    
    NSString *ret = nil;
    
    if (minutesInterval < 1) {
        ret = isDatePast ? @"刚刚" : @"马上";
    } else if (hoursInterval < 1) {
        ret = [NSString stringWithFormat:(isDatePast ? @"%d分钟前" : @"%d分钟后"), (int)minutesInterval];
    } else if (hoursInterval < 2) {
        ret = isDatePast ? @"1小时前" : @"1小时后";
    } else if (hoursInterval < 24) {
        ret = [NSString stringWithFormat:(isDatePast ? @"%d小时前" : @"%d小时后"), (int)hoursInterval];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        ret = [dateFormatter stringFromDate:date];
    }
    
    return ret;
}
+ (NSString *)timeFormatted:(int)totalSeconds
{

    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}
@end
