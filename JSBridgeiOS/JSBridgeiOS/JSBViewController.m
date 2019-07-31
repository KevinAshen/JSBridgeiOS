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
#import <CoreBluetooth/CoreBluetooth.h>
#import "JSBRequestSystemInfoModel.h"
#import "JSBBackSystemInfoModel.h"
#import "JSBSystemInfoUtil.h"

typedef NS_ENUM(NSInteger, JSBModuleType) {
    getSystemInfo = 0,
    showModal
};

const NSArray *___JSBModuleType;

@interface JSBViewController ()<WKNavigationDelegate, WKScriptMessageHandler, CBCentralManagerDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (nonatomic, assign) NSInteger moduleType;  //调取模块函数类型

///systemInfo模块
@property (nonatomic, strong) CBCentralManager *bluetoothManager; //蓝牙控制器
@property (nonatomic, strong) JSBBackSystemInfoModel *backSystemInfoModel;

@end

@implementation JSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self necessaryInitialize];
    [self setupWKWebView];
}

- (void)necessaryInitialize {
    ///getSystemInfo模块
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.backSystemInfoModel = [[JSBBackSystemInfoModel alloc] init];
//    self.backSystemInfoModel.message = [[JSBBackSystemInfoMessageModel alloc] init];
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

///getSystemInfo模块
- (void)getSystemInfoWithModel:(JSBRequestSystemInfoModel *)model{
    JSBSystemInfoUtil *utils = [JSBSystemInfoUtil new];
    self.backSystemInfoModel.style = @"1";
    self.backSystemInfoModel.callbackId = model.callbackId;
    self.backSystemInfoModel.message.brand = @"iPhone";
    self.backSystemInfoModel.message.model = [JSBSystemInfoUtil getDeviceName];
    self.backSystemInfoModel.message.pixelRatio = [JSBSystemInfoUtil getPixelScale];
    self.backSystemInfoModel.message.screenWidth = [JSBSystemInfoUtil getDeviceScreenWidth];
    self.backSystemInfoModel.message.screenHeight = [JSBSystemInfoUtil getDeviceScreenHeight];
    self.backSystemInfoModel.message.windowWidth = _webView.frame.size.width;
    self.backSystemInfoModel.message.windowHeight = _webView.frame.size.height;
    self.backSystemInfoModel.message.language = [JSBSystemInfoUtil getDeviceLanguage];
    self.backSystemInfoModel.message.system = [JSBSystemInfoUtil getSystemVersion];
    self.backSystemInfoModel.message.statusBarHeight = 20;
    self.backSystemInfoModel.message.albumAuthorized = [JSBSystemInfoUtil getPhotoLibrary];
    self.backSystemInfoModel.message.cameraAuthorized = [JSBSystemInfoUtil getCamera];
    self.backSystemInfoModel.message.locationAuthorized = [JSBSystemInfoUtil getLocation];
    self.backSystemInfoModel.message.microphoneAuthorized = [JSBSystemInfoUtil getMicrophone];
    self.backSystemInfoModel.message.notificationAuthorized = [utils checkCurrentNotificationStatus];
    self.backSystemInfoModel.message.locationEnabled = [JSBSystemInfoUtil getGPSEnabled];
    self.backSystemInfoModel.message.wifiEnabled = [JSBSystemInfoUtil getWiFiEnabled];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    ///获取调用模块类型
    NSDictionary *messageDic = (NSDictionary *)message.body;
    NSString *typeStr = [messageDic objectForKey:@"type"];

    if ([message.name isEqualToString:@"JSObject"]) {
        if ([message.name isEqualToString:@"JSObject"]) {
            switch (cJSBModuleTypeEnum(typeStr)) {
                case getSystemInfo: {
                    JSBRequestSystemInfoModel *requestSystemInfoModel = [[JSBRequestSystemInfoModel alloc] initWithDictionary:messageDic error:nil];
                    [self getSystemInfoWithModel:requestSystemInfoModel];
                    NSDictionary *systemInfoDic = [_backSystemInfoModel toDictionary];
//                    NSString *str = [_backSystemInfoModel toJSONString];
                    DLog(@"%@", systemInfoDic);
                    break;
                }
            }
        }
//        NSDictionary *resDic = (NSDictionary *)message.body
//        JSBRequestSystemInfoModel *requestSystemInfoModel = [[JSBRequestSystemInfoModel alloc] initWithDictionary:messageDic error:nil];
    }
}

//第一次打开调用这个函数( 蓝牙控制)
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (_bluetoothManager.state == CBManagerStatePoweredOn) {
        NSLog(@"蓝牙开着");
        self.backSystemInfoModel.message.bluetoothEnabled = @"true";
    } else {
        NSLog(@"蓝牙关着");
        self.backSystemInfoModel.message.bluetoothEnabled = @"false";
    }
}


@end
