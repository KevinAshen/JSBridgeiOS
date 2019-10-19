//
//  JSBDownloadProcessModel.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 model类
 用于存储每个下载任务的相关信息
 */

/**
 下载状态枚举

 - JSBDownloadStateWaiting: 等待中
 - JSBDownloadStateRunning: 正在运行
 - JSBDownloadStateSuspended: 暂停
 - JSBDownloadStateCanceled: 取消
 - JSBDownloadStateCompleted: 完成
 - JSBDownloadStateFailed: 失败
 */
typedef NS_ENUM(NSInteger, JSBDownloadState) {
    JSBDownloadStateWaiting,
    JSBDownloadStateRunning,
    JSBDownloadStateSuspended,
    JSBDownloadStateCanceled,
    JSBDownloadStateCompleted,
    JSBDownloadStateFailed
};

NS_ASSUME_NONNULL_BEGIN

@interface JSBDownloadProcessModel : NSObject

@property (nonatomic, strong) NSURL *downloadURL;
@property (nonatomic, strong) NSURLSessionDataTask *downloadDataTask;

//将数据写入文件
@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, assign) NSInteger totalLength;

/**
 状态改变时调用的block

 @param state 下载状态枚举值
 */
typedef void(^StateUpdate)(JSBDownloadState state);

/**
 过程更新是调用的block，与session的代理相关，目前来看只要更新文件中的一下载进度即可

 @param receivedSize 已经下载的文件大小
 */
typedef void(^ProgressUpdate)(NSInteger receivedSize);

/**
 下载完成后调用的block

 @param isSuccess 下载是否成功
 @param filePath 下载的文件路径
 @param error 下载错误
 */
typedef void(^CompletionDone)(BOOL isSuccess, NSString *filePath, NSError *error);

@property (nonatomic, copy) StateUpdate stateUpdate;
@property (nonatomic, copy) ProgressUpdate progressUpdate;
@property (nonatomic, copy) CompletionDone completionDone;

- (void)openOutputStream;
- (void)closeOutputStream;

@end

NS_ASSUME_NONNULL_END
