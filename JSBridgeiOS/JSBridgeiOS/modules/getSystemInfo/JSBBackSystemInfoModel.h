//
//  JSBBackSystemInfoModel.h
//  JSBridgeiOS
//
//  Created by 小哲的dell on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBBackSystemInfoMessageModel : JSONModel

@property (nonatomic, copy) NSString *brand;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *system;
@property (nonatomic, assign) float screenWidth;
@property (nonatomic, assign) float screenHeight;
@property (nonatomic, assign) float windowWidth;
@property (nonatomic, assign) float windowHeight;
@property (nonatomic, assign) float statusBarHeight;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *wifiEnabled;
@property (nonatomic, copy) NSString *locationEnabled;
@property (nonatomic, assign) int pixelRatio;
@property (nonatomic, copy) NSString *albumAuthorized;
@property (nonatomic, copy) NSString *cameraAuthorized;
@property (nonatomic, copy) NSString *locationAuthorized;
@property (nonatomic, copy) NSString *microphoneAuthorized;
@property (nonatomic, copy) NSString *notificationAuthorized;
@property (nonatomic, copy) NSString *bluetoothEnabled;

@end

@interface JSBBackSystemInfoModel : JSONModel

@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, strong) JSBBackSystemInfoMessageModel *message;

@end

NS_ASSUME_NONNULL_END
