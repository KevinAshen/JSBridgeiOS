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

/**
 保存着下载文件的保存地址
 */
@property (nonatomic, copy) NSString *downloadedFilesDirectory;

//单例创建
+ (instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
