//
//  SongDownloadManager.h
//  miglab_mobile
//
//  Created by pig on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PFileManager.h"
#import "PHttpDownloader.h"
#import "Song.h"

@interface SongDownloadManager : PFileManager

@property (nonatomic, retain) NSString *songCacheDirectory;
@property (nonatomic, retain) NSString *lrcCacheDirectory;
@property (nonatomic, retain) PHttpDownloader *downloader;

+(SongDownloadManager *)GetInstance;

-(NSString *)getSongCacheDirectory;
-(NSString *)getLrcCacheDirectory;

-(void)downloadFailed:(NSNotification *)tNotification;
-(void)downloadProcess:(NSNotification *)tNotification;
-(void)downloadSuccess:(NSNotification *)tNotification;

-(NSString *)getSongCachePath:(long long)tsongid songExt:(NSString *)tsongext;
-(NSString *)getLrcCachePath:(long long)tsongid lrcExt:(NSString *)tlrcext;

-(void)downloadStart:(Song *)tsong;
-(void)downloadFile:(NSString *)tlocalkey requestUrl:(NSString *)trequesturl cachePath:(NSString *)tcachepath;

-(void)downloadPause;
-(void)downloadStop;

@end