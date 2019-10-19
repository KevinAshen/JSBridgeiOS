//
//  JSBDownloadManager.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "JSBDownloadManagerHeader.h"
#include "JSBDownloadProcessModel.h"
#include "JSBDownloadPlistModel.h"

/**
Manager类
用于管理整个下载过程，低耦合性
*/

/**
等待队列的清出顺序

- JSBWaitingQueueFIFO: 先进先出【队列】
- JSBWaitingQueueFILO: 最先进最晚出【栈】
*/
typedef NS_ENUM(NSInteger, JSBWaitingQueueMode) {
    JSBWaitingQueueFIFO,
    JSBWaitingQueueFILO
};

NS_ASSUME_NONNULL_BEGIN

@interface JSBDownloadManager : NSObject

// 保存着下载文件的保存地址
@property (nonatomic, copy) NSString *downloadedFilesDirectory;

//当前最大下载数，确定了能同时下载几个文件
@property (nonatomic, assign) NSInteger maxConcurrentDownloadCount;

//等待下载任务的模式，默认FIFO
@property (nonatomic, assign) JSBWaitingQueueMode waitingQueueMode;

//单例创建
+ (instancetype)sharedManager;

#pragma mark - 下载

/**
 根据URL下载，核心方法

 @param dataDic 下载的URL
 @param stateUpdate 状态改变时调用的block
 @param progressUpdate 过程中调用的block
 @param completionDone 下载完成后调用的block
 */
- (void)downloadFileOfDataDic:(NSDictionary *)dataDic
              stateUpdate:(StateUpdate)stateUpdate
           progressUpdate:(ProgressUpdate)progressUpdate
           completionDone:(CompletionDone)completionDone;

//判断下载是否完成
- (BOOL)isDownloadCompleteOfSongID:(NSString *)songID;

//FIXME:其余操作还未上线
////下载暂停
//- (void)suspendDownloadOfSongID:(NSString *)songID;
//- (void)suspendAllDownloads;
//
////继续下载
//- (void)resumeDownloadOfSongID:(NSString *)songID;
//- (void)resumeAllDownloads;
//
////取消下载
//- (void)cancelDownloadOfSongID:(NSString *)songID;
//- (void)cancelAllDownloads;

#pragma mark - Files

//根据songID获取文件存储全路径
- (NSString *)fileFullPathOfSongID:(NSString *)songID;

//FIXME:删除功能还未上线
//根据URL删除本地文件
//- (void)deleteFileOfSongID:(NSString *)songID;

@end

NS_ASSUME_NONNULL_END
