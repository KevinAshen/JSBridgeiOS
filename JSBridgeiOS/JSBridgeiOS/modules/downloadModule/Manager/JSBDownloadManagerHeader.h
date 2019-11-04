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
#define JSBFileName(songID, fileType) [NSString stringWithFormat:@"%@.%@", songID, fileType]

//根据音乐ID获取文件完整路径
#define JSBFilePath(songID, fileType) [JSBDownloadDirectory stringByAppendingPathComponent:JSBFileName(songID, fileType)]

//根据文件名获取文件完整路径
#define JSBFilePathOfFileName(fileName) [JSBDownloadDirectory stringByAppendingPathComponent:fileName]

//获取存储任务信息的plist文件
#define JSBDownloadTaskPlistPath [JSBDownloadDirectory stringByAppendingPathComponent:@"JSBDownloadTask.plist"]

#endif /* JSBDownloadManagerHeader_h */
