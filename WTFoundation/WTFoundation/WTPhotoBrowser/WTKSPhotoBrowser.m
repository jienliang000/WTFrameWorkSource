//
//  WTKSPhotoBrowser.m
//  WTComponents
//
//  Created by 计恩良 on 2020/8/31.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTKSPhotoBrowser.h"
#import "WTKSPhotoItem.h"
@import KSPhotoBrowser;
@interface WTKSPhotoBrowser ()<KSPhotoBrowserDelegate>
@end

@implementation WTKSPhotoBrowser
+ (void)showPhotoBrowser:(NSArray *)items selectIndex:(NSInteger)selectedIndex controller:(UIViewController *)vc {
    NSMutableArray *ar = @[].mutableCopy;
    for (int i = 0; i < items.count; i++) {
        WTKSPhotoItem *it = items[i];
        [ar addObject:it.getPhotoItem];
    }
    KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:ar selectedIndex:selectedIndex];
//    browser.delegate = self;
    browser.dismissalStyle = KSPhotoBrowserInteractiveDismissalStyleRotation;
    browser.backgroundStyle = KSPhotoBrowserBackgroundStyleBlurPhoto;
    browser.loadingStyle = KSPhotoBrowserImageLoadingStyleDeterminate;
    browser.pageindicatorStyle = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces = YES;
    [browser showFromViewController:vc];
}
@end
