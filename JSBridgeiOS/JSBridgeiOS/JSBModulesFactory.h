//
//  JSBModulesFactory.h
//  JSBridgeiOS
//
//  Created by 小哲的dell on 2019/11/11.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSBBaseModule.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBModulesFactory : NSObject

+ (JSBBaseModule *)createConcreteModule:(NSString *)moduleName;

@end

NS_ASSUME_NONNULL_END
