//
//  JSBViewController.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#include "JSBViewControllerHeader.h"

const NSArray *___JSBModuleType;

@interface JSBViewController ()<WKNavigationDelegate, WKScriptMessageHandler, CBCentralManagerDelegate>

@property (nonatomic,strong) WKWebView *contentWebView;
//内容WebView【用户可见】
@property (nonatomic, strong) WKWebView *loadWebView;
//加载WebView【用户不可见】
@property (nonatomic, assign) NSInteger moduleType;  //调取模块函数类型
@property (nonatomic, copy) NSString *callBackIDStr;
//callBackID
@property (nonatomic, copy) NSString *jsCallBackStr;
//jsCallBack:返回给前端所有字符串，包括callbackId, style, message
@property (nonatomic, copy) NSString *jxBackStr;
//jx两个WebView通信用str

///systemInfo模块
@property (nonatomic, strong) CBCentralManager *bluetoothManager; //蓝牙控制器
@property (nonatomic, strong) JSBBackSystemInfoModel *backSystemInfoModel;

///modal模块
@property (nonatomic, strong) JSBModalView *modalView;
//modal弹窗View
@property (nonatomic, strong) UIView *bounceView;
//背景阴影bounceView

@property (nonatomic, assign) NSInteger time;
 
@end

@implementation JSBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给jsCallBackStr赋初值，方便KVO的调用
    self.jsCallBackStr = @"NEWjsCallBackStr";
    //给jxBackStr赋初值，方便KVO的调用
    self.jxBackStr = @"NEWjxBackStr";

    [self necessaryInitialize];
    [self setupWKWebView];

    [self clearCache];
}

- (void)necessaryInitialize {
    ///getSystemInfo模块
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.backSystemInfoModel = [[JSBBackSystemInfoModel alloc] init];
    self.backSystemInfoModel.message = [[JSBBackSystemInfoMessageModel alloc] init];
}

//初始化两个相关WKWebView
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
    
    self.contentWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.contentWebView.navigationDelegate = self;
    
    [self.view addSubview:self.contentWebView];
    
    NSURL *path = [NSURL URLWithString:testH5URL];
    [self.contentWebView loadRequest:[NSURLRequest requestWithURL:path]];
    
    //初始化解析WKWebView
    self.loadWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height / 2.0, self.view.bounds.size.width, self.view.bounds.size.height / 2.0) configuration:config];
    _loadWebView.navigationDelegate = self;
    
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:testH5IO ofType:@"html"];
    NSURL *testURL = [NSURL fileURLWithPath:bundleStr];
    [_loadWebView loadRequest:[NSURLRequest requestWithURL:testURL]];
}

///getSystemInfo模块
- (void)getSystemInfoWithDictionary:(NSDictionary *)messageDic{
    [self addObserver:self forKeyPath:@"jsCallBackStr" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    JSBRequestSystemInfoModel *requestSystemInfoModel = [[JSBRequestSystemInfoModel alloc] initWithDictionary:messageDic error:nil];
    JSBSystemInfoUtil *utils = [JSBSystemInfoUtil new];
    self.backSystemInfoModel.style = @"1";
    self.backSystemInfoModel.callbackId = requestSystemInfoModel.callbackId;
    self.backSystemInfoModel.message.brand = @"iPhone";
    self.backSystemInfoModel.message.model = [JSBSystemInfoUtil getDeviceName];
    self.backSystemInfoModel.message.pixelRatio = [JSBSystemInfoUtil getPixelScale];
    self.backSystemInfoModel.message.screenWidth = [JSBSystemInfoUtil getDeviceScreenWidth];
    self.backSystemInfoModel.message.screenHeight = [JSBSystemInfoUtil getDeviceScreenHeight];
    self.backSystemInfoModel.message.windowWidth = _contentWebView.frame.size.width;
    self.backSystemInfoModel.message.windowHeight = _contentWebView.frame.size.height;
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

    [self toJSCallBackStr:_backSystemInfoModel];
}

/// JSBridge核心方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    ///获取调用模块类型
    NSDictionary *messageDic = (NSDictionary *)message.body;
    NSString *typeStr = [messageDic objectForKey:@"type"];
    self.callBackIDStr = [messageDic objectForKey:@"callbackId"];
    if ([message.name isEqualToString:@"JSObject"]) {
        switch (cJSBModuleTypeEnum(typeStr)) {
            case getSystemInfo:
                [self getSystemInfoWithDictionary:messageDic];
                break;
            case showModal:
                [self showModal:messageDic];
                break;
            case webviewConnect:
                [self getWebviewConnect:messageDic];
                break;
            case webviewBack:
                [self postWebviewBack:messageDic];
                break;
            case downLoad:
                [self addDownloadTask:messageDic];
                break;
            case downLoadNow:
                [self downloadTaskSituation:1000];
                break;
        }
    }
}

//第一次打开调用这个函数(蓝牙控制)
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    if (_bluetoothManager.state == CBManagerStatePoweredOn) {
        NSLog(@"蓝牙开着");
        self.backSystemInfoModel.message.bluetoothEnabled = @"true";
    } else {
        NSLog(@"蓝牙关着");
        self.backSystemInfoModel.message.bluetoothEnabled = @"false";
    }
}

- (void)showModal:(NSDictionary *)modalDic {
    
    [self addObserver:self forKeyPath:@"jsCallBackStr" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    NSDictionary *dataDic = [modalDic objectForKey:@"data"];
    JSBRequestModalModel *requestModalModel = [[JSBRequestModalModel alloc] initWithDictionary:dataDic error:nil];
    
    self.bounceView = [[UIView alloc] initWithFrame:self.view.frame];
    [_contentWebView addSubview:_bounceView];
    
    _bounceView.backgroundColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
    modalViewStyle style;
    if (requestModalModel.showCancel == 1) {
        style = viewWithCancel;
    } else {
        style = viewWithoutCancel;
    }
    
    self.modalView = [[JSBModalView alloc] initWithStyle:style];
    [_bounceView addSubview:_modalView];
    
    [_modalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bounceView.mas_left).offset(50);
        make.centerX.mas_equalTo(self.bounceView.mas_centerX);
        make.top.equalTo(self.bounceView.mas_top).offset(335);
        make.centerY.mas_equalTo(self.bounceView.mas_centerY);
    }];
    
    [_modalView reloadViewWithData:requestModalModel];
    @WeakObj(self);
    _modalView.buttonAction = ^(NSInteger tag) {
        NSString *tagStr = @"JKWWSWSWWS";
        if (tag == 0) {
            tagStr = @"false";
        } else {
            tagStr = @"true";
        }
        [selfWeak.modalView removeFromSuperview];
        [selfWeak.bounceView removeFromSuperview];
        
        JSBBackModalModel *backModalModel = [[JSBBackModalModel alloc] init];
        backModalModel.message = [[JSBBackMessageModalModel alloc] init];
        backModalModel.callbackId = selfWeak.callBackIDStr;
        backModalModel.style = @"1";
        backModalModel.message.confirm = tagStr;
        backModalModel.message.cancel = @"false";

        [selfWeak toJSCallBackStr:backModalModel];
    };
}

#pragma mark - 下载相关
// FIXME:执行完还未传值
- (void)addDownloadTask:(NSDictionary *)messageDic {
    
    NSDictionary *dataDic = [messageDic valueForKey:@"data"];
    [[JSBDownloadManager sharedManager] downloadFileOfDataDic:dataDic stateUpdate:^(JSBDownloadState state) {
        NSLog(@"stateUpdate");
    } progressUpdate:^(NSInteger receivedSize) {
        NSLog(@"progressUpdate");
    } completionDone:^(BOOL isSuccess, NSString * _Nonnull filePath, NSError * _Nonnull error) {
        NSLog(@"completionDone");
    }];
}

- (void)downloadTaskSituation:(NSInteger)type {
    
    [self addObserver:self forKeyPath:@"jsCallBackStr" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    NSMutableArray *tmpMutArr = [[JSBDownloadManager sharedManager] downloadTaskBack:type];
    NSString *tmpMutArrStr = [tmpMutArr componentsJoinedByString:@","];
    NSString *resTmpMutArrStr = [tmpMutArrStr stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    NSString *newResTmpMutArrStr = [resTmpMutArrStr stringByReplacingOccurrencesOfString:@";" withString:@","];
    
    
    self.jsCallBackStr = [NSString stringWithFormat:@"jsCallBack({style:1,callbackId:%@,message:[%@]})", self.callBackIDStr, newResTmpMutArrStr];
}

//FIXME:这一块还没通
#pragma mark - IO相关

/// webviewConnect相关方法
- (void)getWebviewConnect:(NSDictionary *)messageDic {
    
    [self addObserver:self forKeyPath:@"jxBackStr" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    NSDictionary *dataDic = [messageDic objectForKey:@"data"];
    NSString *jxBackStr = [dataDic objectForKey:@"msg"];
    [self toJXBackStr:jxBackStr];
}

/// webviewBack相关方法
- (void)postWebviewBack:(NSDictionary *)messageDic {
    
    [self addObserver:self forKeyPath:@"jsCallBackStr" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    NSDictionary *dataDic = [messageDic objectForKey:@"data"];
    JSBWebviewBackModel *webviewBackModel = [[JSBWebviewBackModel alloc] init];
    webviewBackModel.style = @"1";
    webviewBackModel.message = [[JSBWebviewBackMessageModel alloc] init];
    webviewBackModel.message.data = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"data"]];
    webviewBackModel.callbackId = self.callBackIDStr;
    
    //FIXME:这一块没有封装！！！
    NSString *resStr = [NSString stringWithFormat:@"jsCallBack({style:1,callbackId:%@,message:'{\"data\":\"%@\"}\'})", self.callBackIDStr, webviewBackModel.message.data];
    self.jsCallBackStr = resStr;
}

#pragma mark - KVO相关

- (void)toJXBackStr:(NSString *)jxStr {
    
    self.jxBackStr = jxStr;
}

- (void)toJSCallBackStr:(id)model {
    NSString *tmpStr = [(JSBBaseModel *)model toJSONString];
    self.jsCallBackStr = [NSString stringWithFormat:@"jsCallBack(%@)", tmpStr];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"jsCallBackStr"]) {
        NSLog(@"jsCallBackStr old price: %@",[change objectForKey:@"old"]);
        NSLog(@"jsCallBackStr new price: %@",[change objectForKey:@"new"]);
        [self removeObserver:self forKeyPath:@"jsCallBackStr"];
        [self.contentWebView evaluateJavaScript:self->_jsCallBackStr completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            //DLog(@"JSBridge--SUCCESS--jsCallBackStr");
        }];
    }
    if ([keyPath isEqual:@"jxBackStr"]) {
        NSLog(@"jxBackStr old price: %@",[change objectForKey:@"old"]);
        NSLog(@"jxBackStr new price: %@",[change objectForKey:@"new"]);
        [self removeObserver:self forKeyPath:@"jxBackStr"];
        [self.loadWebView evaluateJavaScript:self->_jxBackStr completionHandler:^(id _Nullable item, NSError * _Nullable error) {
            //DLog(@"JSBridge--SUCCESS--jxBackStr");
        }];
    }
}

#pragma mark - test相关
// 清理clearWKWebViewCache缓存
- (void)clearCache {
    if ([[[UIDevice currentDevice]systemVersion]intValue ] >= 9.0) {
        NSArray * types =@[WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache]; // 9.0之后才有的
        NSSet *websiteDataTypes = [NSSet setWithArray:types];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }else{
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSLog(@"%@", cookiesFolderPath);
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

@end
