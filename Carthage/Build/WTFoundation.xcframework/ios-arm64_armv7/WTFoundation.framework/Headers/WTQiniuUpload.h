//
//  WTQiniuUpload.h
//  QuLang
//
//  Created by 计恩良 on 2020/5/20.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WTQiniuUpload : NSObject
@property (nonatomic,copy) NSString *qiNiuHostUrl;
//单例对象
+ (instancetype)shareInstance;
/**
 多文件上传

 @param imageArrayData 图片数组
 @param token token
 @param success 上传成功
 @param failure 上传失败
 */
- (void)uploadMuchImage:(NSArray *)imageArrayData token:(NSString *)token success:(void(^)(NSArray *imgArrayUrl))success failure:(void(^)(NSString *message))failure;
@end
