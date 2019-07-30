//
//  JSBRequestModalModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBRequestModalModel : JSBBaseModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *cancelText;
@property (nonatomic, assign) bool showCancel;
@property (nonatomic, copy) NSString *cancelColor;

@property (nonatomic, copy) NSString *confirmText;
@property (nonatomic, copy) NSString *confirmColor;

@end

NS_ASSUME_NONNULL_END
