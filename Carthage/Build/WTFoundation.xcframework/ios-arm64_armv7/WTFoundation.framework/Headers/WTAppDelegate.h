//
//  WTAppDelegate.h
//  WTAppDelegate
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface WTAppDelegate : UIResponder
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL isFullScreen;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
- (void)goHome;

@end

