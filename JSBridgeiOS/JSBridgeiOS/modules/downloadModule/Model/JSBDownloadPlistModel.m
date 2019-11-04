//
//  JSBDownloadPlistModel.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBDownloadPlistModel.h"

@implementation JSBDownloadPlistModel

//赋初值
- (void)initializeModel {
    
    [super initializeModel];
    self.currentTimeStamp = 0;
    self.fileType = @"mp3";
    self.downloadURL = @"www.yyf.yyf.com";
}

@end
