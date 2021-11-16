//
//  WTQiniuUpload.m
//  QuLang
//
//  Created by 计恩良 on 2020/5/20.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTQiniuUpload.h"
typedef void(^successBlock)(NSString *imgUrl);
typedef void(^failureBlock)(NSString *message);

@import QiniuSDK;
@import ReactiveObjC;
@interface WTQiniuUpload ()
@property(copy,nonatomic) void(^uploadImgSuccessBlock)(NSString *qnUrl);
@property(copy,nonatomic) void(^uploadImgFailureBlock)(NSString *message);
@end

@implementation WTQiniuUpload

+ (instancetype)shareInstance
{
    static WTQiniuUpload *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}
//获取当前手机时间
+ (NSString *)currtenDateTimeStr {
    NSDateFormatter *formatter;
    NSString *dateStr;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateStr = [formatter stringFromDate:[NSDate date]];
    return dateStr;
}

//获取随机字符串，用于生成文件名称
+ (NSString*)randomStringWithLength:(int)len {
    NSString * letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString * randomString = [NSMutableString stringWithCapacity:len];
    for(int i = 0; i < len; i++){
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random_uniform((int)[letters length])]];
    }
    return randomString;
}

- (void)uploadSingleImage:(NSData *)imageData token:(NSString *)token success:(successBlock)success failure:(failureBlock)failure {
    if (!imageData) {
        if (failure) {
            failure(@"图片不存在");
        }
        return;
    }
    //生成文件名称，调用上面的时间函数，和随机字符串函数
    NSString *fileName = [NSString stringWithFormat:@"%@_%@",[WTQiniuUpload currtenDateTimeStr],[WTQiniuUpload randomStringWithLength:8]];//
    if ([imageData isKindOfClass:[NSString class]]) {
        fileName = [NSString stringWithFormat:@"%@_%@.mp4",[WTQiniuUpload currtenDateTimeStr],[WTQiniuUpload randomStringWithLength:8]];//视频
        imageData = [NSData dataWithContentsOfFile:(NSString *)imageData];
    } else if ([imageData isKindOfClass:[UIImage class]]) {
        fileName = [NSString stringWithFormat:@"%@_%@.png",[WTQiniuUpload currtenDateTimeStr],[WTQiniuUpload randomStringWithLength:8]];//图片
        imageData = UIImagePNGRepresentation((UIImage *)imageData);
    }
    
    QNUploadManager *qnManager = [[QNUploadManager alloc]init];
    [qnManager putData:imageData key:fileName token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (info.isOK) {
            //成功后返回图片URL
            NSString *url = [NSString stringWithFormat:@"%@/%@",WTQiniuUpload.shareInstance.qiNiuHostUrl,resp[@"key"]];
            if (success) {
                success(url);
            }
        } else {
            if (failure) {
                failure(@"");
            }
        }
    } option:nil];
}

- (void)uploadMuchImage:(NSArray *)imageArrayData token:(NSString *)token success:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSString * _Nonnull))failure {
    __block NSUInteger currentIndex = 0;
    NSMutableArray * qnImgArray = @[].mutableCopy;
    @weakify(self)
    self.uploadImgSuccessBlock = ^(NSString * _Nonnull qnUrl) {
        @strongify(self)
        [qnImgArray addObject:qnUrl];
        currentIndex++;
        if([qnImgArray count] == [imageArrayData count]) {
            success([qnImgArray copy]);
            return;
        } else {
            [self uploadSingleImage:imageArrayData[currentIndex] token:token success:self.uploadImgSuccessBlock failure:self.uploadImgFailureBlock];
        }
    };
    self.uploadImgFailureBlock = ^(NSString * _Nonnull message) {
        failure(@"上传失败!");
        return ;
    };
    [self uploadSingleImage:imageArrayData[0] token:token success:self.uploadImgSuccessBlock failure:self.uploadImgFailureBlock];
} 

@end
