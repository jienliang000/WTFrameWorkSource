//
//  ZXWebViewController.m
//  XZXBusiness
//
//  Created by pp on 2019/1/19.
//  Copyright © 2018 iflytek. All rights reserved.
//

#import "WTWebViewController.h"
#import "WTUIKitDefine.h"
#import "WTToast.h"
#import "WTAppInfo.h"
@import Masonry;
@import ReactiveObjC;

@interface WTWebViewController () <WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (nonatomic) WKWebView *webView;
@property (nonatomic, copy) NSDictionary<NSString *, id<WKScriptMessageHandler>> *scriptMessageHandlers;
@property (nonatomic) UIProgressView *progressView;
//wkWebView自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
@property (nonatomic) WKUserContentController *userContentController;
@property (nonatomic, copy, nullable) NSString *originalUserAgent;
@end

@implementation WTWebViewController
- (void)dealloc {
    [self.scriptMessageHandlers.allKeys enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
        [self.userContentController removeScriptMessageHandlerForName:name];
    }];
    [self restoreUserAgent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.title = self.localizedTitle;
    
    if (self.customScriptMessageHandlers) {
        self.scriptMessageHandlers = self.customScriptMessageHandlers();
    }
    [self customInitialization];
}

- (void)customInitialization {
    // 保存原始userAgent，并自定义userAgent
    self.webView = [[WKWebView alloc] init];
    RACSignal<NSString *> *userAgentSignal = [[WTWebViewController webView:self.webView evaluateJavaScript:@"navigator.userAgent"] catchTo:[RACSignal return:nil]];
    
    RAC(self, originalUserAgent) = [userAgentSignal filter:^BOOL(NSString *userAgent) {
        return ![userAgent containsString:@"zx_iOS_"];
    }];
    
    @weakify(self);
    [[userAgentSignal map:^NSString *(NSString *originalUserAgent) {
        return [NSString stringWithFormat:@"%@ zx_iOS_%@", originalUserAgent, WTAppInfo.appVersion];
    }] subscribeNext:^(NSString *newUserAgent) {
        @strongify(self);
        // 设置global User-Agent
        [NSUserDefaults.standardUserDefaults registerDefaults:@{@"UserAgent": newUserAgent}];
        // 创建和初始化webView
        [self setupWebView];
        if (@available(iOS 9.0, *)) {
            self.webView.customUserAgent = newUserAgent;
        }
    } completed:^{
        @strongify(self);
        [self loadRequest];
    }];
}

- (void)setupWebView {
    // 1. 初始化并设置userContentController
    // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
    self.userContentController = [[WKUserContentController alloc] init];
    [self.scriptMessageHandlers enumerateKeysAndObjectsUsingBlock:^(NSString *key, id<WKScriptMessageHandler> handler, BOOL *stop) {
        [self.userContentController addScriptMessageHandler:handler name:key];
    }];
    
    // 2.初始化并设置configuration
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    // 允许在线播放
    configuration.allowsInlineMediaPlayback = YES;
    // 允许自动播放
    if (@available(iOS 10.0, *)) {
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } else {
        configuration.mediaTypesRequiringUserActionForPlayback = NO;
    }
    // 允许可以与网页交互，选择视图
    configuration.selectionGranularity = YES;
    // web内容处理池
    configuration.processPool = [[WKProcessPool alloc] init];
    // 是否支持记忆读取
    configuration.suppressesIncrementalRendering = YES;
    // 设置自定义的userContentController
    configuration.userContentController = self.userContentController;
    
    // 3.通过configuration初始化webView
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    self.webView.backgroundColor = WT_Color_BackGround;
    // 设置代理
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
    @weakify(self)
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    // 4.初始化并设置进度条
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.progressTintColor = [UIColor blueColor];
    [self.view addSubview:self.progressView];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.webView.mas_top);
        make.leading.equalTo(self.webView.mas_leading);
        make.trailing.equalTo(self.webView.mas_trailing);
        make.height.equalTo(@2);
    }];
    
    // 给webView的加载进度和标题添加监听
    [[[[[[RACSignal combineLatest:@[RACObserve(self.webView, estimatedProgress), RACObserve(self, progressViewHidden)]] takeUntil:self.rac_willDeallocSignal] filter:^BOOL(RACTuple *value) {
        NSNumber *progressViewHidden = value[1];
        return !progressViewHidden.boolValue;
    }] reduceEach:^NSNumber *(NSNumber *estimatedProgress, NSNumber *progressViewHidden){
        return estimatedProgress;
    }] deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSNumber *x) {
        @strongify(self);
        double progress = x.doubleValue;
        self.progressView.alpha = 1;
        [self.progressView setProgress:progress animated:YES];
        if (progress >= 1) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0 animated:YES];
            }];
        }
    }];
}

//恢复原始User-Agent
- (void)restoreUserAgent {
    if (self.originalUserAgent) {
        [NSUserDefaults.standardUserDefaults registerDefaults:@{@"UserAgent":self.originalUserAgent}];
    }
}

- (void)loadRequest {
    if (!self.url) {
        return;
    }
    __weak WTWebViewController *weakSelf = self;
    [self addSpecialParamsWithCompletionHandler:^(NSURL *URL, NSError *error) {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
        [request setValue:WTAppInfo.browserVersion forHTTPHeaderField:@"browserVersion"];
        NSLog(@"load request: %@", request.URL);
        [weakSelf.webView loadRequest:request];
    }];
}

- (void)reload {
    [self.webView reload];
}

- (void)backAction {
    [self goBack];
}

- (void)goBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

+ (RACSignal *)webView:(WKWebView *)webView evaluateJavaScript:(NSString *)javaScriptString {
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [webView evaluateJavaScript:javaScriptString completionHandler:^(id result, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }] replayLast];
}

/// 添加key-value到queryItems，如果key已存在则跳过
+ (void)setQueryName:(NSString *)name value:(NSString *)value toQueryItems:(NSMutableDictionary<NSString *, NSString *> *)queryItems {
    if (!queryItems[name]) {
        queryItems[name] = value;
    }
}

+ (NSArray<NSURLQueryItem *> *)buildQueryItems:(NSDictionary<NSString *, NSString *> *)nvs {
    return [nvs.rac_sequence foldLeftWithStart:[NSArray array] reduce:^NSArray *(NSArray<NSURLQueryItem *> *accumulator, RACTwoTuple<NSString *, NSString *> *value) {
        RACTupleUnpack(NSString *key, NSString *obj) = value;
        return [accumulator arrayByAddingObject:[[NSURLQueryItem alloc] initWithName:key value:obj]];
    }];
}

- (void)addSpecialParamsWithCompletionHandler:(void(^)(NSURL *URL, NSError *error))completionHandler {
    NSURLComponents *components = [NSURLComponents componentsWithString:self.url.absoluteString];
    NSMutableDictionary<NSString *, NSString *> *nvs = [[NSMutableDictionary alloc] init];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem *obj, NSUInteger idx, BOOL *stop) {
        nvs[obj.name] = obj.value;
    }];
    [WTWebViewController setQueryName:@"app" value:@"1" toQueryItems:nvs];
    [WTWebViewController setQueryName:@"appName" value:WTAppInfo.bundleId toQueryItems:nvs];
    
    components.queryItems = [WTWebViewController buildQueryItems:nvs];
    completionHandler(components.URL, nil);
}

#pragma mark - WKNavigationDelegate implementation
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy policy))decisionHandler {
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"navigationAction URL: %@", URL);
    
    if ([self.navigationDelegate respondsToSelector:@selector(webViewController:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.navigationDelegate webViewController:self decidePolicyForNavigationAction:navigationAction decisionHandler:decisionHandler];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction preferences:(WKWebpagePreferences *)preferences decisionHandler:(void (^)(WKNavigationActionPolicy, WKWebpagePreferences *))decisionHandler API_AVAILABLE(ios(13.0)) {
    preferences.preferredContentMode = WKContentModeMobile;
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"navigationAction URL: %@", URL);
    
    if ([self.navigationDelegate respondsToSelector:@selector(webViewController:decidePolicyForNavigationAction:preferences:decisionHandler:)]) {
        [self.navigationDelegate webViewController:self decidePolicyForNavigationAction:navigationAction preferences:preferences decisionHandler:decisionHandler];
    } else if ([self.navigationDelegate respondsToSelector:@selector(webViewController:decidePolicyForNavigationAction:decisionHandler:)]) {
        [self.navigationDelegate webViewController:self decidePolicyForNavigationAction:navigationAction decisionHandler:^(WKNavigationActionPolicy policy) {
            decisionHandler(policy, preferences);
        }];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow, preferences);
    }
}

// Invoked when a main frame navigation starts.
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webView:%@, navigation:%@", webView, navigation);
    if ([self.navigationDelegate respondsToSelector:@selector(webViewController:didStartProvisionalNavigation:)]) {
        [self.navigationDelegate webViewController:self didStartProvisionalNavigation:navigation];
    }
}

// Invoked when an error occurs while starting to load data for the main frame.
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView:%@, navigation:%@, error:%@", webView, navigation, error);
    if ([self.navigationDelegate respondsToSelector:@selector(webViewController:didFailProvisionalNavigation:withError:)]) {
        [self.navigationDelegate webViewController:self didFailProvisionalNavigation:navigation withError:error];
    }
}

// Invoked when a main frame navigation completes.
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webView:%@, navigation:%@", webView, navigation);
    if ([self.navigationDelegate respondsToSelector:@selector(webViewController:didFinishNavigation:)]) {
        [self.navigationDelegate webViewController:self didFinishNavigation:navigation];
    }
}

// Invoked when an error occurs during a committed main frame navigation.
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"webView:%@, navigation:%@, error:%@", webView, navigation, error);
    if ([self.navigationDelegate respondsToSelector:@selector(webViewController:didFailNavigation:withError:)]) {
        [self.navigationDelegate webViewController:self didFailNavigation:navigation withError:error];
    }
}

#pragma mark - WKUIDelegate implementation
//! alert(message)
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

//! confirm(message)
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//! prompt(prompt, defaultText)
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = defaultText;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(alertController.textFields[0].text);
    }];
    [alertController addAction:confirmAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
