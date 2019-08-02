//
//  JSBBaseModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/7/24.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBBaseModel : JSONModel

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *callbackId;
@property (nonatomic, strong, nullable) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
