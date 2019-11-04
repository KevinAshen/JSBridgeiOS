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

@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *fileType;

@property (nonatomic, assign) NSInteger currentTimeStamp;

@end

NS_ASSUME_NONNULL_END
