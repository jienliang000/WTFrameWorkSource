//
//  WTAppDelegate.h
//  WTAppDelegate
//
//  Created by jienliang on 17/6/23.
//  Copyright (c) 2017年 jienliang. All rights reserved.
//
#import "WTAppDelegate.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@import IQKeyboardManager;
@interface WTAppDelegate ()
@end

@implementation WTAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //键盘处理
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    self.isFullScreen = NO;
    //创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
     return YES;
}

- (void)goHome {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error {    
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {     
     UIApplication *app = [UIApplication sharedApplication];
     __block    UIBackgroundTaskIdentifier bgTask;
     bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
          dispatch_async(dispatch_get_main_queue(), ^{
               if (bgTask != UIBackgroundTaskInvalid)
          {
               bgTask = UIBackgroundTaskInvalid;
          }
          });
     }];
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          dispatch_async(dispatch_get_main_queue(), ^{
               if (bgTask != UIBackgroundTaskInvalid)
          {
               bgTask = UIBackgroundTaskInvalid;
          }
          });
     });
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if(self.isFullScreen){
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;

}

@end
