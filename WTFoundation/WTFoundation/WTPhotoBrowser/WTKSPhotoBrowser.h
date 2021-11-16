//
//  WTKSPhotoBrowser.h
//  WTComponents
//
//  Created by 计恩良 on 2020/8/31.
//  Copyright © 2020 计恩良. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WTKSPhotoBrowser : NSObject
+ (void)showPhotoBrowser:(NSArray *)items selectIndex:(NSInteger)selectedIndex controller:(UIViewController *)vc;
@end
