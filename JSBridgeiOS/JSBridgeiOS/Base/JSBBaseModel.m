//
//  JSBBaseModel.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/24.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBBaseModel.h"
#import <objc/message.h>

@implementation JSBBaseModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initializeModel];
    }
    return self;
}

//初始化方法
- (void)initializeModel {
    return;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
