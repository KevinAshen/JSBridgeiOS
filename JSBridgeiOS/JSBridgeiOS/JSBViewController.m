//
//  JSBViewController.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>

@interface JSBViewController ()
////<WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation JSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWKWebView];
}

//初始化WKWebView
- (void)setupWKWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    config.processPool = [[WKProcessPool alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    //注意在这里注入JS对象名称 "JSObject"
    [config.userContentController addScriptMessageHandler:self name:@"JSObject"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    
    [self.view addSubview:self.webView];
    
    NSURL *path = [NSURL URLWithString:@"https://www.konghouy.cn/H5-app/iOS.html#/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:path]];
}

//- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
//    NSLog(@"message.body:%@", message.body);
//
//    NSDictionary *messageDic = (NSDictionary *)message.body;
//    NSString *typeStr = [messageDic objectForKey:@"type"];
//
//
////    if ([message.name isEqualToString:@"JSObject"]) {
////        NSDictionary *resDic = (NSDictionary *)message.body;
////        NSString *resID = [resDic objectForKey:@"callbackId"];
////        NSDictionary *dataDic = [resDic objectForKey:@"data"];
////        NewModalModel *modalModel = [NewModalModel ModelWithDict:dataDic];
////        modalModel.callbackIdStr = resID;
////        [self showModal:modalModel];
////
////        NSLog(@"Dic:%@", resDic);
////        NSLog(@"---%@----", dataDic);
////
////    }
//}

@end
