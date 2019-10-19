//
//  JSBDownloadBaseModel.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBDownloadBaseModel.h"

@implementation JSBDownloadBaseModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self initializeModel];
    }
    return self;
}

//初始化方法
- (void)initializeModel {
    
    self.album = @"Nevermind";
    self.name = @"Smells Like Teen Spirit";
    self.singer = @"Nirvana";
    self.songID = @"888888";
    self.type = @"FUCK";
    self.allBits = @"666";
    self.speed = @"250";
    self.currentNewBits = @"777";
    return;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
