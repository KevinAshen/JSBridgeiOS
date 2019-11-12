//
//  JSBSystemInfoUtil.h
//  JSBridgeiOS
//
//  Created by 小哲的dell on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JSBBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBSystemInfoUtil : JSBBaseModule

/// 获取iPhone名称
+ (NSString *)getiPhoneName;
///获取设备版本号
+ (NSString *)getDeviceName;
/// 当前系统版本号
+ (NSString *)getSystemVersion;
///获取屏幕宽度
+ (CGFloat)getDeviceScreenWidth;
///获取屏幕高度
+ (CGFloat)getDeviceScreenHeight;
///获取设备当前语言
+ (NSString *)getDeviceLanguage;
///获取当前Wi-Fi开关是否打开
+ (NSString *)getWiFiEnabled;
///获取当前GPS开关是否打开
+ (NSString *)getGPSEnabled;
///获取当前设备缩放因子
+ (int)getPixelScale;
///获取app配置文件中是否允许使用相册权限
+ (NSString *)getPhotoLibrary;
///获取app配置文件中是否允许使用摄像头权限
+ (NSString *)getCamera;
///获取app配置文件中是否允许使用定位权限
+ (NSString *)getLocation;
///获取app配置文件中是否允许使用麦克风权限
+ (NSString *)getMicrophone;
///检查通知权限
- (NSString *)checkCurrentNotificationStatus;
///申请通知权限
- (void)requestNotification;

@end

NS_ASSUME_NONNULL_END
