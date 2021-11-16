//
//  WTKSPhotoItem.h
//  WTComponents
//
//  Created by 计恩良 on 2020/8/31.
//  Copyright © 2020 计恩良. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WTKSPhotoItem : NSObject
- (id _Nullable )getPhotoItem;
+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                  imageUrl:(nullable NSURL *)url;
+ (nonnull instancetype)itemWithSourceView:(nullable UIImageView *)view
                                     image:(nullable UIImage *)image;
@end
