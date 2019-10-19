//
//  JSBViewControllerHeader.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/17.
//  Copyright © 2019 J&Z. All rights reserved.
//

#ifndef JSBViewControllerHeader_h
#define JSBViewControllerHeader_h

#import "JSBViewController.h"
#import "JSBRequestModalModel.h"
#import "JSBModalView.h"
#import "JSBBaseModel.h"
#import "JSBBackModalModel.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WebKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "JSBRequestSystemInfoModel.h"
#import "JSBBackSystemInfoModel.h"
#import "JSBSystemInfoUtil.h"
#import "JSBWebviewBackModel.h"
#import "JSBDownloadManager.h"

//显示用WKWebView加载的URL
#define testH5URL @"http://www.konghouy.cn/H5-app/wangyi.html"
//解析用WKWebView加载的本地H5文件名
#define testH5IO @"new-io"

typedef NS_ENUM(NSInteger, JSBModuleType) {
    getSystemInfo = 0,
    showModal,
    webviewConnect,
    webviewBack
};

#endif /* JSBViewControllerHeader_h */
