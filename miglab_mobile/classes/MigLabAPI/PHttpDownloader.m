//
//  PHttpDownloader.m
//  miglab_mobile
//
//  Created by apple on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PHttpDownloader.h"

@implementation PHttpDownloader

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
