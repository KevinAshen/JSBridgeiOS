//
//  JSBRequestModalModel.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/30.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBRequestModalModel.h"

@implementation JSBRequestModalModel

- (void)initializeModel {
    self.showCancel = true;
    self.cancelText = @"取消";
    self.cancelColor = @"#000000";
    self.confirmText = @"确定";
    self.confirmColor = @"#578B95";
}

@end
