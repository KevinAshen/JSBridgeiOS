//
//  JSBDownloadPlistModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBDownloadBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBDownloadPlistModel : JSBDownloadBaseModel

@property (nonatomic, copy) NSString *refreshTimeStamp;
@property (nonatomic, copy) NSString *currentTimeStamp;
@property (nonatomic, copy) NSString *refreshNewBits;
@property (nonatomic, copy) NSString *downloadURL;

@end

NS_ASSUME_NONNULL_END
