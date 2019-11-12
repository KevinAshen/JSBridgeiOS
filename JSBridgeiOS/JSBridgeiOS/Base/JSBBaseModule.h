//
//  JSBBaseModule.h
//  JSBridgeiOS
//
//  Created by 小哲的dell on 2019/11/11.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSBBaseModule : NSObject

- (id)performModuleMethodWithDictionary:(NSDictionary *)messageDictionary;

@end

NS_ASSUME_NONNULL_END
