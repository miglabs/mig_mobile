//
//  SongDownloadManager.m
//  miglab_mobile
//
//  Created by pig on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SongDownloadManager.h"
#import "PDatabaseManager.h"

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

-(NSString *)getIPodSongCacheDirectory{
    
    NSString *cacheHome = [self getCacheHomeDirectory];
    NSString *lrcCacheDirectory = [cacheHome stringByAppendingPathComponent:@"IPod"];
    
    return [super createPath:lrcCacheDirectory];
}

-(NSString *)getSongCachePath:(long long)tsongid songExt:(NSString *)tsongext{
    return [_songCacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@", tsongid, tsongext]];
}

-(NSString *)getSongCachePath:(Song *)tsong{
    
    // 如果没有url，则跳过
    if (tsong.songurl && ![tsong.songurl isEqualToString:@""]) {
        
        NSString *songext = [NSString stringWithFormat:@"%@", [tsong.songurl lastPathComponent]];
        NSRange range = [songext rangeOfString:@"."];
        
        // 如果location太大，认为非法，跳过
        if (range.location > 256)
        {
            return nil;
        }
        
        songext = [songext substringFromIndex:range.location];
        return [self getSongCachePath:tsong.songid songExt:songext];
    }
    
    return nil;
}

-(NSString *)getLrcCachePath:(long long)tsongid lrcExt:(NSString *)tlrcext{
    return [_lrcCacheDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@", tsongid, tlrcext]];
}

-(NSString *)getLrcCachePath:(Song *)tsong{
    
    NSString *lrcext = [NSString stringWithFormat:@"%@", [tsong.lrcurl lastPathComponent]];
    NSRange range = [lrcext rangeOfString:@"."];
    lrcext = [lrcext substringFromIndex:range.location];
    return [self getLrcCachePath:tsong.songid lrcExt:lrcext];
}

-(long long)getSongCacheFileSize{
    return [super getFileSizeForDir:_songCacheDirectory];
}

-(long long)getSongMaxSize:(Song *)tsong{
    
    if (tsong.songurl && ![tsong.songurl isEqualToString:@""]) {
        
        NSString *songext = [NSString stringWithFormat:@"%@", [tsong.songurl lastPathComponent]];
        NSRange range = [songext rangeOfString:@"."];
        if (range.location == NSNotFound || range.length <= 0) {
            return 0;
        }
        songext = [songext substringFromIndex:range.location + 1];
        
        PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
        return [databaseManager getSongMaxSize:tsong.songid type:songext];
    }
    
    return 0;
}

-(long long)getSongLocalSize:(Song *)tsong{
    
    NSString *cachepath = [self getSongCachePath:tsong];
    
    if (cachepath && !tsong.songCachePath) {
        
        tsong.songCachePath = cachepath;
    }
    
    return [super getLocalFileSize:cachepath];
    
}

-(float)getSongProgress:(Song *)tsong{
    
    long long maxsize = [self getSongMaxSize:tsong];
    if (maxsize == 0) {
        return 0;
    }
    long long localsize = [self getSongLocalSize:tsong];
    return (float)localsize / (float)maxsize;
}

-(void)downloadStart:(Song *)tsong delegate:(id)delegate{
    
    [_downloader doStop];
    
    if (tsong && tsong.songid > 0) {
        
        //歌曲下载
        if (tsong.songurl) {
            
            NSString *localkey = [NSString stringWithFormat:@"%lld", tsong.songid];
            NSString *cachepath = [self getSongCachePath:tsong];
            [self downloadFile:localkey requestUrl:tsong.songurl cachePath:cachepath delegate:delegate];
            
        }
        
        //歌词下载
        if (tsong.lrcurl) {
            //
        }
        
    }
    
}

-(void)downloadFile:(NSString *)tlocalkey requestUrl:(NSString *)trequesturl cachePath:(NSString *)tcachepath delegate:(id)delegate{
    
    [_downloader setRequestUrl:trequesturl];
    [_downloader setLocalKey:tlocalkey];
    [_downloader setCachePath:tcachepath];
    [_downloader setDelegate:delegate];
    
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
