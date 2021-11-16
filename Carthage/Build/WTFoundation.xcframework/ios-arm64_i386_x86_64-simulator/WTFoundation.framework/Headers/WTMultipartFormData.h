//
//  WTMultipartFormData.h
//  WTFoundation
//
//  Created by jienliang on 2019/11/11.
//

#import <Foundation/Foundation.h>

@protocol WTMultipartFormData <NSObject>

- (void)appendPartWithFileData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
