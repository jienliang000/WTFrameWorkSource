//
//  WTPageControl.h
//  WTCyclePagerViewDemo
//
//  Created by elji on 2017/6/20.
//  Copyright © 2017年 elji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTPageControl : UIControl

@property (nonatomic, assign) NSInteger numberOfPages;          // default is 0
@property (nonatomic, assign) NSInteger currentPage;            // default is 0. value pinned to 0..numberOfPages-1

@property (nonatomic, assign) BOOL hidesForSinglePage;          // hide the the indicator if there is only one page. default is NO

@property (nonatomic, assign) CGFloat pageIndicatorSpaing;
@property (nonatomic, assign) UIEdgeInsets contentInset; // center will ignore this
@property (nonatomic, assign ,readonly) CGSize contentSize; // real content size

// indicatorTint color
@property (nullable, nonatomic,strong) UIColor *pageIndicatorTintColor;
@property (nullable, nonatomic,strong) UIColor *currentPageIndicatorTintColor;

// indicator image
@property (nullable, nonatomic,strong) UIImage *pageIndicatorImage;
@property (nullable, nonatomic,strong) UIImage *currentPageIndicatorImage;

@property (nonatomic, assign) UIViewContentMode indicatorImageContentMode; // default is UIViewContentModeCenter

@property (nonatomic, assign) CGSize pageIndicatorSize; // indicator size
@property (nonatomic, assign) CGSize currentPageIndicatorSize; // default pageIndicatorSize

@property (nonatomic, assign) CGFloat animateDuring; // default 0.3

- (void)setCurrentPage:(NSInteger)currentPage animate:(BOOL)animate;

@end
