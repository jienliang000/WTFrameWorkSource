//
//  WTTokenTimeoutCountable.h
//  XZXBusiness
//
//  Created by jienliang on 2019/7/8.
//  Copyright © 2019 elji. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WTTokenTimeoutCountable <NSObject>
/// TOKEN_TIMEOUT计数
@property (nonatomic) int tokenTimeoutCount;
/// TOKEN_TIMEOUT最多连续重试处理次数
@property (nonatomic) int tokenTimeoutMaxRetryCount;
@end
