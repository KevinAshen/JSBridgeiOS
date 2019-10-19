//
//  JSBDownloadBaseModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSBDownloadBaseModel : JSONModel

@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, copy) NSString *songID;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *currentNewBits;
@property (nonatomic, copy) NSString *allBits;

- (void)initializeModel;

@end

NS_ASSUME_NONNULL_END
