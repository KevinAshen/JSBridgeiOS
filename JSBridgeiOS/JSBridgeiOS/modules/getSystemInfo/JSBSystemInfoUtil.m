//
//  JSBSystemInfoUtil.m
//  JSBridgeiOS
//
//  Created by 小哲的dell on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBSystemInfoUtil.h"
#import "sys/utsname.h"
#import "JSBBackSystemInfoModel.h"
#import "JSBRequestSystemInfoModel.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <mach/mach.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreLocation/CLLocationManager.h>
#import <UserNotifications/UserNotifications.h>

@interface JSBSystemInfoUtil()
@property (nonatomic, strong) JSBBackSystemInfoModel *backSystemInfoModel;
@end

@implementation JSBSystemInfoUtil

- (id)performModuleMethodWithDictionary:(NSDictionary *)messageDictionary {
    self.backSystemInfoModel = [[JSBBackSystemInfoModel alloc] init];
    self.backSystemInfoModel.message = [[JSBBackSystemInfoMessageModel alloc] init];
    JSBRequestSystemInfoModel *requestSystemInfoModel = [[JSBRequestSystemInfoModel alloc] initWithDictionary:messageDictionary error:nil];
    JSBSystemInfoUtil *utils = [JSBSystemInfoUtil new];
    self.backSystemInfoModel.style = @"1";
    self.backSystemInfoModel.callbackId = requestSystemInfoModel.callbackId;
    self.backSystemInfoModel.message.brand = @"iPhone";
    self.backSystemInfoModel.message.model = [JSBSystemInfoUtil getDeviceName];
    self.backSystemInfoModel.message.pixelRatio = [JSBSystemInfoUtil getPixelScale];
    self.backSystemInfoModel.message.screenWidth = [JSBSystemInfoUtil getDeviceScreenWidth];
    self.backSystemInfoModel.message.screenHeight = [JSBSystemInfoUtil getDeviceScreenHeight];
    //FIXME:这里设置默认值，在controller中修改
    self.backSystemInfoModel.message.windowWidth = 0;
    self.backSystemInfoModel.message.windowHeight = 0;
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
    
    return _backSystemInfoModel;
}

/// 获取iPhone名称
+ (NSString *)getiPhoneName {
    return [UIDevice currentDevice].name;
}

///获取设备版本号
+ (NSString *)getDeviceName {
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])    return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])    return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])    return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])    return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceString;
}

/// 当前系统版本号
+ (NSString *)getSystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

/// 屏幕宽度
+ (CGFloat)getDeviceScreenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

/// 屏幕高度
+ (CGFloat)getDeviceScreenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

/// 获取当前语言
+ (NSString *)getDeviceLanguage {
    NSArray *languageArray = [NSLocale preferredLanguages];
    return [languageArray objectAtIndex:0];
}

///获取Wi-Fi开关状态
+ (NSString *)getWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? @"true" : @"false";
}

///获取GPS开关状态
+ (NSString *)getGPSEnabled {
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] ==kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        return @"true";
    } else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        return @"false";
    } else {
        return @"false";
    }
}

///获取当前设备像素比
+ (int)getPixelScale {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone3,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone3,3"])    return 2;
    if ([deviceString isEqualToString:@"iPhone4,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,3"])    return 2;
    if ([deviceString isEqualToString:@"iPhone5,4"])    return 2;
    if ([deviceString isEqualToString:@"iPhone6,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone6,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone7,1"])    return 3;
    if ([deviceString isEqualToString:@"iPhone7,2"])    return 2;
    if ([deviceString isEqualToString:@"iPhone8,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone8,2"])    return 3;
    if ([deviceString isEqualToString:@"iPhone8,4"])    return 2;
    if ([deviceString isEqualToString:@"iPhone9,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone9,2"])    return 3;
    if ([deviceString isEqualToString:@"iPhone9,3"])    return 2;
    if ([deviceString isEqualToString:@"iPhone9,4"])    return 3;
    if ([deviceString isEqualToString:@"iPhone10,1"])    return 2;
    if ([deviceString isEqualToString:@"iPhone10,2"])    return 3;
    if ([deviceString isEqualToString:@"iPhone10,3"])    return 3;
    if ([deviceString isEqualToString:@"iPhone10,4"])    return 2;
    if ([deviceString isEqualToString:@"iPhone10,5"])    return 3;
    if ([deviceString isEqualToString:@"iPhone10,6"])    return 2;
    if ([deviceString isEqualToString:@"iPhone11,2"])    return 3;
    if ([deviceString isEqualToString:@"iPhone11,4"])    return 3;
    if ([deviceString isEqualToString:@"iPhone11,6"])    return 3;
    if ([deviceString isEqualToString:@"iPhone11,8"])    return 2;
    if ([deviceString isEqualToString:@"iPod1,1"])      return 1;
    if ([deviceString isEqualToString:@"iPod2,1"])      return 1;
    if ([deviceString isEqualToString:@"iPod3,1"])      return 1;
    if ([deviceString isEqualToString:@"iPod4,1"])      return 2;
    if ([deviceString isEqualToString:@"iPod5,1"])      return 2;
    if ([deviceString isEqualToString:@"iPad1,1"])      return 1;
    if ([deviceString isEqualToString:@"iPad1,2"])      return 2;
    if ([deviceString isEqualToString:@"iPad2,1"])      return 1;
    if ([deviceString isEqualToString:@"iPad2,2"])      return 1;
    if ([deviceString isEqualToString:@"iPad2,3"])      return 1;
    if ([deviceString isEqualToString:@"iPad2,4"])      return 1;
    if ([deviceString isEqualToString:@"iPad2,5"])      return 1;
    if ([deviceString isEqualToString:@"iPad2,6"])      return 1;
    if ([deviceString isEqualToString:@"iPad2,7"])      return 1;
    if ([deviceString isEqualToString:@"iPad3,1"])      return 2;
    if ([deviceString isEqualToString:@"iPad3,2"])      return 2;
    if ([deviceString isEqualToString:@"iPad3,3"])      return 2;
    if ([deviceString isEqualToString:@"iPad3,4"])      return 2;
    if ([deviceString isEqualToString:@"iPad3,5"])      return 2;
    if ([deviceString isEqualToString:@"iPad3,6"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,1"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,2"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,4"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,5"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,6"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,7"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,8"])      return 2;
    if ([deviceString isEqualToString:@"iPad4,9"])      return 2;
    if ([deviceString isEqualToString:@"iPad5,1"])      return 2;
    if ([deviceString isEqualToString:@"iPad5,2"])      return 2;
    if ([deviceString isEqualToString:@"iPad5,3"])      return 2;
    if ([deviceString isEqualToString:@"iPad5,4"])      return 2;
    if ([deviceString isEqualToString:@"iPad6,3"])      return 3;
    if ([deviceString isEqualToString:@"iPad6,4"])      return 3;
    if ([deviceString isEqualToString:@"iPad6,7"])      return 3;
    if ([deviceString isEqualToString:@"iPad6,8"])      return 3;
    return 0;
}

//获取app配置文件中是否允许使用相册权限
+ (NSString *)getPhotoLibrary {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    //NSLog(@"%@", dic);
    if ([dic objectForKey:@"NSPhotoLibraryUsageDescription"]) {
        return @"true";
    } else {
        return @"false";
    }
}
//获取app配置文件中是否允许使用摄像头权限
+ (NSString *)getCamera {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    //NSLog(@"%@", dic);
    if ([dic objectForKey:@"NSCameraUsageDescription"]) {
        return @"true";
    } else {
        return @"false";
    }
}
//获取app配置文件中是否允许使用定位权限
+ (NSString *)getLocation {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    //NSLog(@"%@", dic);
    if ([dic objectForKey:@"NSLocationWhenInUseUsageDescription"]) {
        return @"true";
    } else {
        return @"false";
    }
}
//获取app配置文件中是否允许使用麦克风权限
+ (NSString *)getMicrophone {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    //NSLog(@"%@", dic);
    if ([dic objectForKey:@"NSMicrophoneUsageDescription"]) {
        return @"true";
    } else {
        return @"false";
    }
}

//申请通知权限
- (void)requestNotification
{
    if (@available(iOS 10, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                // 允许推送
                NSLog(@"允许打开通知权限");
            }else{
                //不允许
                NSLog(@"不允许打开通知权限");
            }
            
        }];
    } else if(@available(iOS 8 , *)) {
        UIApplication * application = [UIApplication sharedApplication];
        
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil]];
        [application registerForRemoteNotifications];
    } else {
        UIApplication * application = [UIApplication sharedApplication];
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
        [application registerForRemoteNotifications];
    }
}

//查看当前通知权限
- (NSString *)checkCurrentNotificationStatus {
    __block BOOL flag = NO;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    if (@available(iOS 10 , *)) {
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            NSLog(@"%@", [NSThread currentThread]);
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                // 没权限
                flag = YES;
            } else {
                flag = NO;
            }
            dispatch_semaphore_signal(semaphore);
        }];
    }
    else if (@available(iOS 8 , *)) {
        UIUserNotificationSettings * setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == UIUserNotificationTypeNone) {
            // 没权限
            flag = NO;
        } else {
            flag = YES;
        }
        dispatch_semaphore_signal(semaphore);
    } else {
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == UIUserNotificationTypeNone) {
            // 没权限
            flag = NO;
        } else {
            flag = YES;
        }
        dispatch_semaphore_signal(semaphore);
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (flag == YES) {
        return @"true";
    } else {
        return @"false";
    }
}

@end
