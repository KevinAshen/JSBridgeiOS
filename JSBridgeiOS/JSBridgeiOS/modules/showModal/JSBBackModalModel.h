//
//  JSBBackModalModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/8/1.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBBackMessageModalModel : JSBBaseModel

@property (nonatomic, copy) NSString *confirm;
@property (nonatomic, copy) NSString *cancel;

@end

@interface JSBBackModalModel : JSBBaseModel

@property (nonatomic, strong) JSBBackMessageModalModel *message;

@end

NS_ASSUME_NONNULL_END
