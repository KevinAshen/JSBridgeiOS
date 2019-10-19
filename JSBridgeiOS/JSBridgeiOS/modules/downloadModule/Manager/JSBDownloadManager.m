//
//  JSBDownloadManager.m
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import "JSBDownloadManager.h"

@interface JSBDownloadManager ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *urlSession;

//包括下载中以及等待下载的model
@property (nonatomic, strong) NSMutableDictionary *downloadModelMutDic;
//包括现在在下载的model
@property (nonatomic, strong) NSMutableArray *downloadingModelMutArr;
//包括等待下载的model
@property (nonatomic, strong) NSMutableArray *waitingModelMutArr;

@end

@implementation JSBDownloadManager
#pragma mark - 初始化

+ (instancetype)sharedManager {
    
    static JSBDownloadManager *downloadManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        downloadManager = [[self alloc] init];
        downloadManager.maxConcurrentDownloadCount = -1;
        downloadManager.waitingQueueMode = JSBWaitingQueueFIFO;
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

#pragma mark - 懒加载

- (NSURLSession *)urlSession {
    
    if (!_urlSession) {
        _urlSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]                                                     delegate:self
                                               delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _urlSession;
}

- (NSMutableDictionary *)downloadModelMutDic {
    
    if (!_downloadModelMutDic) {
        _downloadModelMutDic = [NSMutableDictionary dictionary];
    }
    return _downloadModelMutDic;
}

- (NSMutableArray *)downloadingModelMutArr {
    
    if (_downloadingModelMutArr) {
        _downloadingModelMutArr = [NSMutableArray array];
    }
    return _downloadingModelMutArr;
}

- (NSMutableArray *)waitingModelMutArr {
    
    if (_waitingModelMutArr) {
        _waitingModelMutArr = [NSMutableArray array];
    }
    return _waitingModelMutArr;
}

#pragma mark - Download

- (void)downloadFileOfDataDic:(NSDictionary *)dataDic stateUpdate:(StateUpdate)stateUpdate progressUpdate:(ProgressUpdate)progressUpdate completionDone:(CompletionDone)completionDone {
    
    //FIXME:10/20
    NSString *downloadURLStr = [dataDic valueForKey:@"url"];
    if (!downloadURLStr) {
        return;
    }

    NSString *downloadSongID = [dataDic valueForKey:@"songID"];
    //如果URL已经被下载完
//    if ([self isDownloadCompleteOfSongID:downloadSongID]) {
//        NSError *error;
//
//        if (stateUpdate) {
//            stateUpdate(JSBDownloadStateCompleted);
//        }
//        if (completionDone) {
//            completionDone(YES, [self fileFullPathOfSongID:downloadSongID], error);
//        }
//        return;
//    }
    
    JSBDownloadProcessModel *downloadProcessModel = self.downloadModelMutDic[JSBFileName(downloadSongID)];
    //如果这个downloadModel已经存在在Dic中，直接return
    if (downloadProcessModel) {
        return;
    }
    
    JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] init];
    downloadPlistModel.name = [dataDic valueForKey:@"name"];
    downloadPlistModel.album = [dataDic valueForKey:@"album"];
    downloadPlistModel.singer = [dataDic valueForKey:@"singer"];
    downloadPlistModel.songID = [dataDic valueForKey:@"songID"];
    downloadPlistModel.downloadURL = [dataDic valueForKey:@"downloadURL"];
    NSDictionary *downloadPlistDictionary = [downloadPlistModel toDictionary];
    
    //FIXME:test写入plist文件
    NSMutableDictionary *allDownloadTaskMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
    //在上面的下载方法只是对于数组以及字典进行操作，给缓存中的plist文件进行操作是在这里进行操作
    //更新一下文件
    allDownloadTaskMutDic[JSBFileName(downloadSongID)] = downloadPlistDictionary;
    [allDownloadTaskMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
}
//根据当前下载数以及最大下载数判断是否可以继续下载
- (BOOL)canResumeDownload {
    
    if (self.maxConcurrentDownloadCount == -1) {
        return YES;
    }
    if (self.downloadingModelMutArr.count >= self.maxConcurrentDownloadCount) {
        return NO;
    }
    return YES;
}

#pragma mark - NSURLSessionDataDelegate

#pragma mark - Assist Methods

#pragma mark - Public Methods
#pragma mark - Files

//- (BOOL)isDownloadCompleteOfSongID:(NSString *)songID {
//
//
//}


@end
