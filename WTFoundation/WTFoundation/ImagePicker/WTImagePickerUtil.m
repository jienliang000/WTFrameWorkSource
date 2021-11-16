//
//  WTImagePickerUtil.m
//  WTImagePicker
//
//  Created by jienliang on 2018/2/1.
//  Copyright © 2018年 jienliang. All rights reserved.
//

#import "WTImagePickerUtil.h"
#import "WTUIKitUtil.h"
@import TZImagePickerController;
#define WTImageScreenWidth [UIScreen mainScreen].bounds.size.width
#define WTImageScreenHeight [UIScreen mainScreen].bounds.size.height


@interface WTImagePickerUtil ()<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
//当前的控制器
@property (nonatomic,weak) UIViewController *parentVC;
@end

@implementation WTImagePickerUtil
static WTImagePickerUtil *instace;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instace = [[self alloc] init];
        instace.maxCount = 1;
        instace.allowCrop = YES;
        instace.needCircleCrop = NO;
    });
    return instace;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
    }
    return _imagePickerVc;
}

- (void)showActionSheet {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.parentVC.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushTZImagePickerController];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {//未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        _imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.parentVC presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - TZImagePickerController

- (void)pushTZImagePickerController {
    if (self.maxCount <= 0) {
        return;
    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:4 delegate:nil pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = YES;//是否返回原图
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;//是否允许选择照片
    imagePickerVc.allowPickingOriginalPhoto = YES;//是否允许选择照片原图
    imagePickerVc.allowPickingGif = NO;//允许选择gif
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCrop;
    imagePickerVc.needCircleCrop = self.needCircleCrop;
    // 设置竖屏下的裁剪尺寸
    [self setCropRect:imagePickerVc];
#pragma mark - 到这里为止
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        if (self.didFinishPickingPhotosHandle) {
            self.didFinishPickingPhotosHandle(photos, assets);
        }
    }];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.parentVC presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)setCropRect:(TZImagePickerController *)imagePickerVc {
    NSInteger left = 15;
    NSInteger widthHeight = WTImageScreenWidth - 2 * left;
    NSInteger top = (WTImageScreenHeight - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:^{
            self.parentVC.navigationController.navigationBarHidden = YES;
        }];
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = YES;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(PHAsset *asset,NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (self.allowCrop) { // 允许裁剪,去裁剪
                            TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                if (self.didFinishPickingPhotosHandle) {                                    self.didFinishPickingPhotosHandle([NSArray arrayWithObject:cropImage], [NSArray arrayWithObject:asset]);
                                }
                            }];
                            [self setCropRect:imagePicker];
                            imagePicker.needCircleCrop = self.needCircleCrop;
                            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
                            [self.parentVC presentViewController:imagePicker animated:YES completion:nil];
                        } else {
                            if (self.didFinishPickingPhotosHandle) {
                                self.didFinishPickingPhotosHandle([NSArray arrayWithObject:image], [NSArray arrayWithObject:assetModel.asset]);
                            }
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)showImagePicker:(WTImagePickerUtilType)type inViewController:(UIViewController *)vc {
    //带actionSheet
    if (type==WTImagePickerUtilTypeActionSingle) {
        self.maxCount = 1;
        self.allowCrop = NO;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self showActionSheet];
    } else if (type==WTImagePickerUtilTypeActionSingleCrop) {
        self.maxCount = 1;
        self.allowCrop = YES;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self showActionSheet];
    } else if (type==WTImagePickerUtilTypeActionMulti) {
        self.maxCount = 9;
        self.allowCrop = NO;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self showActionSheet];
    }
    //不带actionSheet
    else if (type==WTImagePickerUtilTypeTakePhoto) {
        self.maxCount = 1;
        self.allowCrop = NO;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self takePhoto];
    } else if (type==WTImagePickerUtilTypeTakePhotoCrop) {
        self.maxCount = 1;
        self.allowCrop = YES;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self takePhoto];
    } else if (type==WTImagePickerUtilTypeAlbumSingle) {
        self.maxCount = 1;
        self.allowCrop = NO;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self pushTZImagePickerController];
    } else if (type==WTImagePickerUtilTypeAlbumSingleCrop) {
        self.maxCount = 1;
        self.allowCrop = YES;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self pushTZImagePickerController];
    } else if (type==WTImagePickerUtilTypeAlbumMulti) {
        self.maxCount = 9;
        self.allowCrop = NO;
        self.needCircleCrop = NO;
        self.parentVC = vc;
        [self pushTZImagePickerController];
    }
}
@end
