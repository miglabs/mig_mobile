//
//  SongDownloadManager.m
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SongDownloadManager.h"
#import "MigLabConfig.h"

@implementation SongDownloadManager

@synthesize httpRequestOperation = _httpRequestOperation;
@synthesize song = _song;
@synthesize isReady = _isReady;

+(NSString *)getCacheHomeDirectory{
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheHomeDirectory = [cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]];
    return cacheHomeDirectory;
}

+(NSString *)getSongCacheDirectory{
    
    NSString *cacheHome = [self getCacheHomeDirectory];
    NSString *songCacheDirectory = [cacheHome stringByAppendingPathComponent:@"Song"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:songCacheDirectory isDirectory:NULL]) {
        [fm createDirectoryAtPath:songCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return songCacheDirectory;
}

+(NSString *)getLrcCacheDirectory{
    
    NSString *cacheHome = [self getCacheHomeDirectory];
    NSString *lrcCacheDirectory = [cacheHome stringByAppendingPathComponent:@"Lrc"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:lrcCacheDirectory isDirectory:NULL]) {
        [fm createDirectoryAtPath:lrcCacheDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return lrcCacheDirectory;
}

+(long long)getLocalFileSize:(NSString *)filepath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath isDirectory:NULL]) {
        return 0;
    }
    NSDictionary *fileAttributes = [fm attributesOfItemAtPath:filepath error:nil];
    return [fileAttributes fileSize];
}

+(SongDownloadManager *)GetInstance{
    static SongDownloadManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[SongDownloadManager alloc] init];
        }
    }
    return instance;
}

-(NSString *)getSongCachePath:(long long)tsongid songExt:(NSString *)tsongext{
    return [[SongDownloadManager getSongCacheDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%lld%@", tsongid, tsongext]];
}

-(BOOL)initDownloadInfo{
    
    NSLog(@"initDownloadInfo...");
    
    if (_song && _song.songid > 0 && _song.songurl) {
        
        NSString *songpath = [self getSongCachePath:_song.songid songExt:@".mp3"];
        NSLog(@"songpath: %@", songpath);
        
        NSURL *url = [NSURL URLWithString:_song.songurl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        long long offset = [SongDownloadManager getLocalFileSize:songpath];//local file size
        NSLog(@"offset: %lld", offset);
        
        NSString *strRange = [NSString stringWithFormat:@"bytes=%lld-", offset];
        [request setValue:strRange forHTTPHeaderField:@"Range"];
        
        _httpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        _httpRequestOperation.outputStream = [[NSOutputStream alloc] initToFileAtPath:songpath append:YES];
        [_httpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"setCompletionBlockWithSuccess responseObject: %@", responseObject);
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDownloadSuccess object:nil userInfo:nil];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"failure: %@", error);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDownloadFailed object:nil userInfo:nil];
            
        }];
        
        [_httpRequestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            NSLog(@"bytesRead: %d, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
            
            float downloadProcess = (float)(offset + totalBytesRead) / (float)(offset + totalBytesExpectedToRead);
            NSDictionary *dicProcess = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:downloadProcess], @"DownloadProcess", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDownloadProcess object:nil userInfo:dicProcess];
            
        }];
        
        _isReady = YES;
        NSLog(@"SongDownloadManager is ready...");
        
    } else {
        
        _isReady = NO;
        NSLog(@"SongDownloadManager is unready...");
        
    }
    
    return _isReady;
}

-(void)doStart{
    
    NSLog(@"doStart...");
    
    if (_isReady) {
        [_httpRequestOperation start];
    }
    
}

-(void)doPause{
    
    NSLog(@"doPause...");
    [_httpRequestOperation pause];
    
}

-(void)doResume{
    
    NSLog(@"doResume...");
    [_httpRequestOperation resume];
    
}

@end
