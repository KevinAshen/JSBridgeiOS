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

@property (nonatomic, copy) NSString *typeStr;

@property (nonatomic, copy) NSString *callBackIDStr;

@end

NS_ASSUME_NONNULL_END
