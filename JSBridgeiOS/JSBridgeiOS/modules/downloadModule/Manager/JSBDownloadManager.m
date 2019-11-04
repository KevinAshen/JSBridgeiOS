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

@property (nonatomic, strong) NSMutableDictionary *tempDict;

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

- (void)downloadFileOfDataDic:(NSDictionary *)dataDic                                                                                                     stateUpdate:(StateUpdate)stateUpdate                                                                                                 progressUpdate:(ProgressUpdate)progressUpdate                                                                                           completionDone:(CompletionDone)completionDone {
    NSString *downloadURLStr = [dataDic valueForKey:@"url"];
    NSURL *downloadURL = [NSURL URLWithString:downloadURLStr];
    if (!downloadURL) {
        return;
    }

    NSString *downloadSongID = [dataDic valueForKey:@"songID"];
    NSString *fileTypeStr = [self filetypeOfURL:downloadURLStr];
    //如果URL已经被下载完
    if ([self isDownloadCompleteOfFileName:JSBFileName(downloadSongID, fileTypeStr)]) {
        NSError *error;

        if (stateUpdate) {
            stateUpdate(JSBDownloadStateCompleted);
        }
        if (completionDone) {
            completionDone(YES, [self fileFullPathOfSongID:downloadSongID fileType:fileTypeStr], error);
        }
        return;
    }
    
    
    JSBDownloadProcessModel *downloadProcessModel = self.downloadModelMutDic[JSBFileName(downloadSongID, fileTypeStr)];
    //如果这个downloadModel已经存在在Dic中，直接return
    if (downloadProcessModel) {
        return;
    }
    
    //设置Request
    //设置请求头，从目前已经下载到的地方开始继续下载到end
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:downloadURL];
    [downloadRequest setValue:[NSString stringWithFormat:@"bytes=%lld-", (long long int)[self hasDownloadedLength:JSBFileName(downloadSongID, fileTypeStr)]] forHTTPHeaderField:@"Range"];
    
    //设置DataTask
    //taskDescription:可给任务设置一个可读的描述，在如果需要界面展示时使用
    NSURLSessionDataTask *downloadDataTask = [self.urlSession dataTaskWithRequest:downloadRequest];
    downloadDataTask.taskDescription = JSBFileName(downloadSongID, fileTypeStr);
    
    //将任务信息写入plist文件，这种情况只会在第一次下载该任务时发生
    //暂停之后再次下载，不会将其复写
    //搜索不到在进行写入，但不影响下载任务，下载就是在下载队列里没有时进行下载
    if (![self downloadPlistModelWithFileName:JSBFileName(downloadSongID, fileTypeStr)]) {
        JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] init];
        downloadPlistModel.name = [dataDic valueForKey:@"name"];
        downloadPlistModel.album = [dataDic valueForKey:@"album"];
        downloadPlistModel.singer = [dataDic valueForKey:@"singer"];
        downloadPlistModel.songID = [dataDic valueForKey:@"songID"];
        downloadPlistModel.downloadURL = [dataDic valueForKey:@"url"];
        downloadPlistModel.fileType = [self filetypeOfURL:downloadPlistModel.downloadURL];
        NSDictionary *downloadPlistDictionary = [downloadPlistModel toDictionary];
        
//        NSMutableDictionary *allDownloadTaskMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
        NSMutableDictionary *allDownloadTaskMutDic = self.tempDict ?: [NSMutableDictionary dictionary];
        DLog(@"---%lu",(unsigned long)allDownloadTaskMutDic.count);
        //在上面的下载方法只是对于数组以及字典进行操作，给缓存中的plist文件进行操作是在这里进行操作
        //更新一下文件
        allDownloadTaskMutDic[JSBFileName(downloadSongID, fileTypeStr)] = downloadPlistDictionary;
        DLog(@"===%lu",(unsigned long)allDownloadTaskMutDic.count);
//        DLog(@"---JSBFileName:%@---", JSBFileName(downloadSongID, fileTypeStr));
//        [allDownloadTaskMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
        [allDownloadTaskMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
        self.tempDict = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
    }
    
    //新的管理model
    downloadProcessModel = [[JSBDownloadProcessModel alloc] init];
    downloadProcessModel.downloadDataTask = downloadDataTask;
    downloadProcessModel.outputStream = [NSOutputStream outputStreamToFileAtPath:JSBFilePathOfFileName(downloadDataTask.taskDescription) append:YES];
    downloadProcessModel.downloadURL = downloadURL;
    downloadProcessModel.songID = downloadSongID;
    downloadProcessModel.stateUpdate = stateUpdate;
    downloadProcessModel.progressUpdate = progressUpdate;
    downloadProcessModel.completionDone = completionDone;
    //Objective-C中也有类似于重载的概念，对于字典可以直接通过中括号来赋值
    self.downloadModelMutDic[downloadDataTask.taskDescription] = downloadProcessModel;
    
    JSBDownloadState downloadState;
    
    //如果可以下载的话逻辑为：先在下载数组中添加该model，然后继续下载任务，状态设置为running
    //不可以下载的逻辑为：先将状态标注为waiting，在等待数组中添加该model
    if ([self canResumeDownload]) {
        [self.downloadingModelMutArr addObject:downloadProcessModel];
        //FIXME:更新download状态
        [self updatePlistFileState:JSBFileName(downloadSongID, fileTypeStr) newState:1000];
        [downloadDataTask resume];
        downloadState = JSBDownloadStateRunning;
    } else {
        [self.waitingModelMutArr addObject:downloadProcessModel];
        downloadState = JSBDownloadStateWaiting;
    }
    
    //FIXME:这里应该怎么处理暂时还没思路
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if (downloadModel.stateUpdate) {
//            //???
//            //model的state什么时候修改
//            downloadModel.stateUpdate(downloadState);
//        }
//    });
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

- (BOOL)vipSong:(NSString *)urlStr {
    
    if ([urlStr isEqualToString:@""]) {
        return true;
    }
    
    return false;
}

#pragma mark - NSURLSessionDataDelegate

/**
该方法只会在开始下载的时候调用，后面挂起再启动不会走这个方法
*/
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(nonnull NSURLResponse *)response
 completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    JSBDownloadProcessModel *downloadProcessModel = self.downloadModelMutDic[dataTask.taskDescription];
    
    if (!downloadProcessModel) {
        return;
    }
    
    [downloadProcessModel openOutputStream];
    
    //获取本次下载的预期长度
    NSInteger exceptedTotalLength = response.expectedContentLength;
    //FIXME:猜想这里的totalLength为什么是已下载的进度+预期总量【按照道理已下载进度就是0】，可能是因为分段下载的问题，但是这里考虑到后期有网易云URL变动，我们这里就低调一点吧
    downloadProcessModel.totalLength = exceptedTotalLength;
    //对plist中的allbits进行修改
    
    NSMutableDictionary *allFilesTotalLengthMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
    NSDictionary *tmpDic = allFilesTotalLengthMutDic[dataTask.taskDescription];
    JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] initWithDictionary:tmpDic error:nil];
    downloadPlistModel.allBits = exceptedTotalLength;
    NSDictionary *resDic = [downloadPlistModel toDictionary];
    allFilesTotalLengthMutDic[dataTask.taskDescription] = resDic;
    [allFilesTotalLengthMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
    
    //需要通过调用completionHandler告诉系统应该如何处理服务器返回的数据
    //NSURLSessionResponseAllow表示接收返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 该方法会不停得被调用，只要在接受数据过程中
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    
    JSBDownloadProcessModel *downloadProcessModel = self.downloadModelMutDic[dataTask.taskDescription];
    if (!downloadProcessModel) {
        return;
    }
    
    //outputStream的初始设置是在初始化model的时候
    [downloadProcessModel.outputStream write:data.bytes maxLength:data.length];
    
    NSMutableDictionary *allFilesTotalLengthMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
    NSDictionary *tmpDic = allFilesTotalLengthMutDic[dataTask.taskDescription];
    JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] initWithDictionary:tmpDic error:nil];
    // FIXME:速度计算有待商榷
    
    [self updateDownloadSpeed:downloadPlistModel];
    NSDictionary *resDic = [downloadPlistModel toDictionary];
    allFilesTotalLengthMutDic[dataTask.taskDescription] = resDic;
    [allFilesTotalLengthMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
    
    //FIXME:块的部分还没有进行操作，暂放
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if (downloadModel.progressUpdate) {
//            NSUInteger receivedSize = [self hasDownloadedLength:downloadModel.downloadURL];
//            NSUInteger expectedSize = downloadModel.totalLength;
//            CGFloat progress = 1.0 * receivedSize / expectedSize;
//
//            downloadModel.progressUpdate(receivedSize, expectedSize, progress);
//        }
//    });
}

/**
 任务完成时调用的方法
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    //Canceled!
    if (error && error.code == -999) {
        return;
    }
    [self refreshFileState:task.taskDescription];
    [self updatePlistFileState:task.taskDescription newState:1005];
    
    JSBDownloadProcessModel *downloadProcessModel = self.downloadModelMutDic[task.taskDescription];
    if (!downloadProcessModel) {
        return;
    }
    
    [downloadProcessModel closeOutputStream];
    
    [self.downloadModelMutDic removeObjectForKey:task.taskDescription];
    [self.downloadingModelMutArr removeObject:downloadProcessModel];
    
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if ([self isDownloadCompleteOfURL:downloadModel.downloadURL]) {
//            if (downloadModel.stateUpdate) {
//                downloadModel.stateUpdate(KADownloadStateCompleted);
//            }
//
//            if (downloadModel.completionDone) {
//                downloadModel.completionDone(YES, [self fileFullPathOfURL:downloadModel.downloadURL], error);
//            }
//        } else {
//            if (downloadModel.stateUpdate) {
//                downloadModel.stateUpdate(KADownloadStateFailed);
//            }
//            if (downloadModel.completionDone) {
//                downloadModel.completionDone(NO, nil, error);
//            }
//        }
//    });
    
    [self resumeNextDownloadModel];
}

#pragma mark - Assist Methods

- (JSBDownloadPlistModel *)downloadPlistModelWithFileName:(NSString *)fileName {

    NSDictionary *downloadTaskPlistDic = [NSDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath];

    if (!downloadTaskPlistDic) {
        return nil;
    }
    
    NSMutableDictionary *allFilesTotalLengthMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
    
    NSDictionary *tmpDic = allFilesTotalLengthMutDic[fileName];
    JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] initWithDictionary:tmpDic error:nil];
    
    return downloadPlistModel;
}

- (NSInteger)totalLengthWithFileName:(NSString *)fileName {

    JSBDownloadPlistModel *downloadPlistModel = [self downloadPlistModelWithFileName:fileName];
    
    return downloadPlistModel.allBits;
}

- (NSInteger)hasDownloadedLength:(NSString *)fileName {
    
    //文件信息
    NSDictionary *fileAttributeDic = [[NSFileManager defaultManager] attributesOfItemAtPath:JSBFilePathOfFileName(fileName) error:nil];
    
    if (!fileAttributeDic) {
        return 0;
    }
    
    //返回目前下载的大小
    return [fileAttributeDic[NSFileSize] integerValue];
}

- (void)resumeNextDownloadModel {
    
    //如果最大下载数还是-1，说明还没有初始化
    //如果没有等待下载的任务，直接返回
    if (self.maxConcurrentDownloadCount == -1) {
        return;
    }
    if (self.waitingModelMutArr.count == 0) {
        return;
    }
    
    //先在数组中进行处理
    JSBDownloadProcessModel *downloadProcessModel;
    switch (self.waitingQueueMode) {
        case JSBWaitingQueueFIFO:
            downloadProcessModel = self.waitingModelMutArr.firstObject;
            break;
        case JSBWaitingQueueFILO:
            downloadProcessModel = self.waitingModelMutArr.lastObject;
            break;
        default:
            break;
    }
    [self.waitingModelMutArr removeObject:downloadProcessModel];
    
    //上面先取出对应的model
    //下面要跟新model的state
    //如果不能继续下载，不做任何改变
    //FIXME：去掉else的判断
    JSBDownloadState downloadState;
    if ([self canResumeDownload]) {
        [self.downloadingModelMutArr addObject:downloadProcessModel];
        [downloadProcessModel.downloadDataTask resume];
        downloadState = JSBDownloadStateRunning;
    } else {
        [self.waitingModelMutArr addObject:downloadProcessModel];
        downloadState = JSBDownloadStateWaiting;
    }
    
    //FIXME:block
//    dispatch_async(dispatch_get_main_queue(), ^{
//
//        if (downloadModel.stateUpdate) {
//            downloadModel.stateUpdate(downloadState);
//        }
//    });
}

- (NSInteger)getCurrentTimestamp {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0]; // 获取当前时间0秒后的时间
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;// *1000 是精确到毫秒(13位),不乘就是精确到秒(10位)
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return [timeString integerValue];
}

- (void)updateDownloadSpeed:(JSBDownloadPlistModel *)downloadPlistModel {
    
    float tmpTime = (float)([self getCurrentTimestamp] - downloadPlistModel.currentTimeStamp);
    float tmpBits = (float)([self hasDownloadedLength:JSBFileName(downloadPlistModel.songID, downloadPlistModel.fileType)] - downloadPlistModel.currentNewBits);
    
    if (tmpTime >= 1000) {
        float speed = tmpBits / 1024.0 / tmpTime * 1000;
        downloadPlistModel.speed = speed;
        downloadPlistModel.currentTimeStamp = [self getCurrentTimestamp];
        downloadPlistModel.currentNewBits = [self hasDownloadedLength:JSBFileName(downloadPlistModel.songID, downloadPlistModel.fileType)];
    }
}

#pragma mark - Public Methods
#pragma mark - Files

- (NSString *)filetypeOfURL:(NSString *)downloadURL {
    
    NSInteger count = (NSInteger)[downloadURL length] - 1;
    for (; count > -1; count--) {
        NSString *tmpStr = [downloadURL substringWithRange:NSMakeRange(count, 1)];
        if ([tmpStr isEqualToString:@"."]) {
            break;
        }
    }
    NSString *resStr = [downloadURL substringFromIndex:++count];
    return resStr;
}

- (NSString *)fileFullPathOfSongID:(NSString *)songID
                          fileType:(NSString *)fileType {
    
    return JSBFilePath(songID, fileType);
}

- (BOOL)isDownloadCompleteOfFileName:(NSString *)fileName {

    JSBDownloadPlistModel *downloadPlistModel = [self downloadPlistModelWithFileName:fileName];
    NSInteger totalLength = downloadPlistModel.allBits;
    
    if (totalLength != 0) {
        if (totalLength == [self hasDownloadedLength:JSBFileName(downloadPlistModel.songID, downloadPlistModel.fileType)]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)refreshFileState:(NSString *)fileName {
    
    NSMutableDictionary *allFilesTotalLengthMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];
    
    NSDictionary *tmpDic = allFilesTotalLengthMutDic[fileName];
    JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] initWithDictionary:tmpDic error:nil];
    
    downloadPlistModel.currentTimeStamp = [self getCurrentTimestamp];
    downloadPlistModel.currentNewBits = [self hasDownloadedLength:fileName];
    
    NSDictionary *resDic = [downloadPlistModel toDictionary];
    allFilesTotalLengthMutDic[fileName] = resDic;
    [allFilesTotalLengthMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
}

- (void)updatePlistFileState:(NSString *)fileName                                                                          newState:(NSInteger)state {
    
    NSMutableDictionary *allFilesTotalLengthMutDic = [NSMutableDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSMutableDictionary dictionary];

    NSDictionary *tmpDic = allFilesTotalLengthMutDic[fileName];
    JSBDownloadPlistModel *downloadPlistModel = [[JSBDownloadPlistModel alloc] initWithDictionary:tmpDic error:nil];

    downloadPlistModel.type = state;

    NSDictionary *resDic = [downloadPlistModel toDictionary];
    allFilesTotalLengthMutDic[fileName] = resDic;
    [allFilesTotalLengthMutDic writeToFile:JSBDownloadTaskPlistPath atomically:YES];
}

- (NSMutableArray *)downloadTaskBack:(NSInteger)typeInt {
    
    NSDictionary *allFilesTotalLengthDic = [NSDictionary dictionaryWithContentsOfFile:JSBDownloadTaskPlistPath] ?: [NSDictionary dictionary];
    NSMutableArray *resMutArr = [NSMutableArray array];
    
    for (NSString *tmpFileName in allFilesTotalLengthDic) {
        JSBDownloadPlistModel *downloadPlistModel = [self downloadPlistModelWithFileName:tmpFileName];
        if (downloadPlistModel.type == typeInt) {
            NSDictionary *tmpDic = [downloadPlistModel toDictionary];
            JSBDownloadBackModel *downloadBackModel = [[JSBDownloadBackModel alloc]  initWithDictionary:tmpDic error:nil];
            NSDictionary *resTmpDic = [downloadBackModel toDictionary];
            [resMutArr addObject:resTmpDic];
        }
    }
    
    return resMutArr;
}

@end
