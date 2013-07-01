//
//  PHttpDownloader.h
//  miglab_mobile
//
//  Created by pig on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PFileManager.h"
#import "AFHTTPRequestOperation.h"

//下载失败
#define NotificationNameDownloadFailed                      @"NotificationNameDownloadFailed"
//下载进度
#define NotificationNameDownloadProcess                     @"NotificationNameDownloadProcess"
//下载成功
#define NotificationNameDownloadSuccess                     @"NotificationNameDownloadSuccess"

@interface PHttpDownloader : PFileManager

@property (nonatomic, retain) AFHTTPRequestOperation *operation;                //
@property (nonatomic, retain) NSString *requestUrl;                             //请求网址
@property (nonatomic, retain) NSString *localKey;                               //本地缓存key
@property (nonatomic, retain) NSString *cachePath;                              //缓存路径
@property (assign) BOOL isReadyToDownload;                                      //是否初始化

-(BOOL)initDownloader;
-(void)doStart;
-(void)doPause;
-(void)doResume;
-(void)doStop;

@end
