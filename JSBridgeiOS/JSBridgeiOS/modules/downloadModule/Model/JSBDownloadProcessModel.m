//
//  JSBDownloadProcessModel.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBDownloadProcessModel.h"

@implementation JSBDownloadProcessModel

- (void)openOutputStream {
    
    if (_outputStream) {
        [_outputStream open];
    }
}

//if判断在NotOpen与Closed之间，说明确实是开着的，需要关闭
- (void)closeOutputStream {
    
    if (_outputStream) {
        if (_outputStream.streamStatus > NSStreamStatusNotOpen && _outputStream.streamStatus < NSStreamStatusClosed) {
            [_outputStream close];
        }
        _outputStream = nil;
    }
}

@end
