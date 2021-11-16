//
//  WTWebViewController.h
//  XZXBusiness
//
//  Created by pp on 2019/1/19.
//  Copyright © 2018 iflytek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WTViewController.h"
@class WTWebViewController;

@protocol WTWebViewNavigationDelegate <NSObject>
@optional
- (void)webViewController:(WTWebViewController *)webViewController decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy policy))decisionHandler;
/// @discussion If you implement this method, -webViewController:decidePolicyForNavigationAction:decisionHandler: will not be called.
- (void)webViewController:(WTWebViewController *)webViewController decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences *))decisionHandler API_AVAILABLE(ios(13.0));
/// Invoked when a main frame navigation starts.
- (void)webViewController:(WTWebViewController *)webViewController didStartProvisionalNavigation:(WKNavigation *)navigation;
/// Invoked when an error occurs while starting to load data for the main frame.
- (void)webViewController:(WTWebViewController *)webViewController didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error;
/// Invoked when an error occurs during a committed main frame navigation.
- (void)webViewController:(WTWebViewController *)webViewController didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;
/// Invoked when a main frame navigation completes.
- (void)webViewController:(WTWebViewController *)webViewController didFinishNavigation:(WKNavigation *)navigation;
@end

@interface WTWebViewController : WTViewController
@property (nonatomic, copy, nullable) NSString *localizedTitle;
@property (nonatomic, readonly, nullable) WKWebView *webView;
@property (nonatomic,copy, nullable) NSURL *url;
@property (nonatomic, assign) BOOL progressViewHidden;
@property (nonatomic, weak, nullable) id<WTWebViewNavigationDelegate> navigationDelegate;

@property (nonatomic, copy, nullable) NSDictionary<NSString *, id<WKScriptMessageHandler>> *(^customScriptMessageHandlers)(void);

- (void)loadRequest;
- (void)reload;
@end
