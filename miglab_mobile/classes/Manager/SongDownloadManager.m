//
//  SongDownloadManager.m
//  miglab_mobile
//
//  Created by pig on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SongDownloadManager.h"

@implementation SongDownloadManager

@synthesize songCacheDirectory = _songCacheDirectory;
@synthesize lrcCacheDirectory = _lrcCacheDirectory;
@synthesize downloader = _downloader;

+(SongDownloadManager *)GetInstance{
    static SongDownloadManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[SongDownloadManager alloc] init];
        }
    }
    return instance;
}

-(id)init{
    
    self = [super init];
    if (self) {
        
        _songCacheDirectory = [self getSongCacheDirectory];
        _lrcCacheDirectory = [self getLrcCacheDirectory];
        _downloader = [[PHttpDownloader alloc] init];
        
    }
    
    return self;
}

-(NSString *)getSongCacheDirectory{
    
    NSString *cacheHome = [self getCacheHomeDirectory];
    NSString *songCacheDirectory = [cacheHome stringByAppendingPathComponent:@"Song"];
    
    return [super createPath:songCacheDirectory];
}

-(NSString *)getLrcCacheDirectory{
    
    NSString *cacheHome = [self getCacheHomeDirectory];
    NSString *lrcCacheDirectory = [cacheHome stringByAppendingPathComponent:@"Lrc"];
    
    return [super createPath:lrcCacheDirectory];
}

-(NSString *)getSongCachePath:(long long)tsongid songExt:(NSString *)tsongext{
    return [_songCacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@", tsongid, tsongext]];
}

-(NSString *)getLrcCachePath:(long long)tsongid lrcExt:(NSString *)tlrcext{
    return [_lrcCacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@", tsongid, tlrcext]];
}

-(void)downloadStart:(Song *)tsong{
    
    [_downloader doStop];
    
    if (tsong && tsong.songid > 0) {
        
        //歌曲下载
        if (tsong.songurl) {
            
            NSString *localkey = [NSString stringWithFormat:@"%lld", tsong.songid];
            NSString *songext = [NSString stringWithFormat:@".%@", [tsong.songurl lastPathComponent]];
            NSString *cachepath = [self getSongCachePath:tsong.songid songExt:songext];
            [self downloadFile:localkey requestUrl:tsong.songurl cachePath:cachepath];
            
        }
        
        //歌词下载
        if (tsong.lrcurl) {
            //
        }
        
    }
    
}

-(void)downloadFile:(NSString *)tlocalkey requestUrl:(NSString *)trequesturl cachePath:(NSString *)tcachepath{
    
    [_downloader setRequestUrl:trequesturl];
    [_downloader setLocalKey:tlocalkey];
    [_downloader setCachePath:tcachepath];
    
    BOOL isDownloaderInit = [_downloader initDownloader];
    if (isDownloaderInit) {
        [_downloader doStart];
    }
    
}

-(void)downloadPause{
    
    [_downloader doPause];
    
}

-(void)downloadResume{
    
    [_downloader doResume];
    
}

-(void)downloadStop{
    
    [_downloader doStop];
    
}

@end
