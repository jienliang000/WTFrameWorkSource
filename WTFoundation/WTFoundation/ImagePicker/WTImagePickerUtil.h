//
//  WTImagePickerUtil.h
//  WTImagePicker
//
//  Created by jienliang on 2018/2/1.
//  Copyright © 2018年 jienliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, WTImagePickerUtilType) {
    WTImagePickerUtilTypeActionSingle          = 0,//带提示框，且不需要裁剪
    WTImagePickerUtilTypeActionSingleCrop          = 1,//带提示框，且需要裁剪
    WTImagePickerUtilTypeActionMulti     = 2,//带提示框，选择多张图片
    WTImagePickerUtilTypeTakePhoto = 3,//直接进入相机不可裁剪
    WTImagePickerUtilTypeTakePhotoCrop = 4,//直接进入相机可裁剪
    WTImagePickerUtilTypeAlbumSingle = 5,//,直接进入相册选择单张相片不可裁剪
    WTImagePickerUtilTypeAlbumSingleCrop = 6,//,直接进入相册选择单张相片可裁剪
    WTImagePickerUtilTypeAlbumMulti = 7,//,直接进入相册选择多张相片
};

@interface WTImagePickerUtil : NSObject
//最大选择相片数目,只有数量为1才支持裁剪
@property (nonatomic,assign) int maxCount;
//是否允许裁剪 只有maxCount为1时才生效
@property (nonatomic,assign) BOOL allowCrop;
//是否允许圆形裁剪
@property (nonatomic,assign) BOOL needCircleCrop;

@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets);

+ (instancetype)shareInstance;

- (void)showImagePicker:(WTImagePickerUtilType)type inViewController:(UIViewController *)vc;
@end
