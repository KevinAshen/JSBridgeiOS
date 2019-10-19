//
//  JSBDownloadManager.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBDownloadManager.h"

@implementation JSBDownloadManager

#pragma mark - 初始化

+ (instancetype)sharedManager {
    
    static JSBDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
//        downloadManager.maxConcurrentDownloadCount = -1;
//        downloadManager.waitingQueueMode = KAWaitingQueueFIFO;
    });
    return downloadManager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        NSString *downloadDirectory = JSBDownloadDirectory;
        
        DLog(@"%@", downloadDirectory);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDirectory = NO;
        BOOL isExists = [fileManager fileExistsAtPath:downloadDirectory isDirectory:&isDirectory];
        
        //首先plist文件是否存在
        //其次这个路径是不是文件夹
        if (!isExists || !isDirectory) {
            [fileManager createDirectoryAtPath:downloadDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    return self;
}

@end
