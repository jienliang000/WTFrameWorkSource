//
//  WTMultipartFormDataPrivate.h
//  WTFoundation
//
//  Created by jienliang on 2019/11/11.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import "WTMultipartFormData.h"


@interface WTMultipartFormData : NSObject <WTMultipartFormData>

@property (nonatomic, strong) id<AFMultipartFormData> afFormData;

@end

