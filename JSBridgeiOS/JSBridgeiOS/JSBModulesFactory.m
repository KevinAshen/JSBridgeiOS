//
//  JSBModulesFactory.m
//  JSBridgeiOS
//
//  Created by 小哲的dell on 2019/11/11.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBModulesFactory.h"
#import "JSBViewControllerHeader.h"

@implementation JSBModulesFactory

+ (JSBBaseModule *)createConcreteModule:(NSString *)moduleName {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ModuleName" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *value = [dic valueForKey:moduleName];
    
    SEL createModule = NSSelectorFromString(value);
    JSBBaseModule *module;
    if ([self respondsToSelector:createModule]) {
        module = [self performSelector:createModule];
    }
    return module;
}

+ (JSBSystemInfoUtil *)createGetSystemInfoModule {
    JSBSystemInfoUtil *getSystemInfoModule = [[JSBSystemInfoUtil alloc] init];
    return getSystemInfoModule;
}

@end
