//
//  JSBDownloadManagerHeader.h
//  JSBridgeiOS
//
//  Created by Kevin.J on 2019/10/18.
//  Copyright © 2019 J&Z. All rights reserved.
//

#ifndef JSBDownloadManagerHeader_h
#define JSBDownloadManagerHeader_h

/**
JSBDownloadDirectory获取到APP的私有存储路径
*/
#define JSBDownloadDirectory self.downloadedFilesDirectory ?: [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"JSBridgeiOS"]

//用音乐ID作为文件名
#define JSBFileName(songID) [NSString stringWithFormat:@"%@", songID]

//根据音乐ID获取文件完整路径
#define JSBFilePath(songID) [KADownloadDirectory stringByAppendingPathComponent:KAFileName(songID)]

//获取下载中plist文件
#define JSBDownloadingTaskPlistPath [JSBDownloadDirectory stringByAppendingPathComponent:@"JSBDownloadingTask.plist"]
//获取已完成plist文件
#define JSBFinishedTaskPlistPath [JSBDownloadDirectory stringByAppendingPathComponent:@"JSBFinishedTask.plist"]

#endif /* JSBDownloadManagerHeader_h */
