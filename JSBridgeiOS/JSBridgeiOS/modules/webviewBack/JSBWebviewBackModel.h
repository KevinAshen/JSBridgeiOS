//
//  JSBWebviewBackModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/17.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBWebviewBackMessageModel : JSONModel

@property (nonatomic, copy) NSString *data;

@end

@interface JSBWebviewBackModel : JSBBaseModel

@property (nonatomic, strong) JSBWebviewBackMessageModel *message;

@end

NS_ASSUME_NONNULL_END
