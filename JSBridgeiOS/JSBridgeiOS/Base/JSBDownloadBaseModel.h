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

@property (nonatomic, assign) float speed;

@property (nonatomic, assign) NSInteger currentNewBits;
@property (nonatomic, assign) NSInteger allBits;
@property (nonatomic, assign) NSInteger type;

- (void)initializeModel;

@end

NS_ASSUME_NONNULL_END
