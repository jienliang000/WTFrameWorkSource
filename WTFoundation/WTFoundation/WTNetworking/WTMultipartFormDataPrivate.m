//
//  WTMultipartFormDataPrivate.m
//  WTFoundation
//
//  Created by jienliang on 2019/11/11.
//

#import "WTMultipartFormDataPrivate.h"

@implementation WTMultipartFormData

- (void)appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
   return [self.afFormData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
}

@end
