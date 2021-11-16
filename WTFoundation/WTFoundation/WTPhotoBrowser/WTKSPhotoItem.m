//
//  WTKSPhotoItem.m
//  WTComponents
//
//  Created by 计恩良 on 2020/8/31.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import "WTKSPhotoItem.h"
@import KSPhotoBrowser;
@interface WTKSPhotoItem ()
@property (nonatomic,strong) KSPhotoItem *item;
@end

@implementation WTKSPhotoItem

- (id)getPhotoItem {
    return self.item;
}

+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                  imageUrl:(nullable NSURL *)url {
    WTKSPhotoItem *it = [[WTKSPhotoItem alloc] init];
    it.item = [KSPhotoItem itemWithSourceView:view imageUrl:url];
    return it;
}

+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                     image:(nullable UIImage *)image {
    WTKSPhotoItem *it = [[WTKSPhotoItem alloc] init];
    it.item = [KSPhotoItem itemWithSourceView:view image:image];
    return it;
}
@end
