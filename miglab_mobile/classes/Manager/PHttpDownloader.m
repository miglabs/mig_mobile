//
//  PHttpDownloader.m
//  miglab_mobile
//
//  Created by pig on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PHttpDownloader.h"

@implementation PHttpDownloader

@synthesize operation = _operation;
@synthesize requestUrl = _requestUrl;
@synthesize localKey = _localKey;
@synthesize cachePath = _cachePath;
@synthesize isReadyToDownload = _isReadyToDownload;
@synthesize delegate = _delegate;
@synthesize downloadCount = _downloadCount;

#define kCheckDownloadProcessCount 8

-(BOOL)initDownloader{
    
    PLog(@"initDownloader: requestUrl(%@), localKey(%@), cachePath(%@)", _requestUrl, _localKey, _cachePath);
    
    if (_requestUrl && _localKey && _cachePath) {
        
        NSString *tempLocalKey = _localKey;
        id<PHttpDownloaderDelegate> tempdelegate = _delegate;
        __block int checkDownloadProcessCount = kCheckDownloadProcessCount;
        NSNumber *tempDownloadCount = [NSNumber numberWithInt:_downloadCount];
        
        //local file size
        long long offset = [super getLocalFileSize:_cachePath];
        
        NSURL *url = [NSURL URLWithString:_requestUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        NSString *strRange = [NSString stringWithFormat:@"bytes=%lld-", offset];
        [request setValue:strRange forHTTPHeaderField:@"Range"];
        
        _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        _operation.outputStream = [[NSOutputStream alloc] initToFileAtPath:_cachePath append:YES];
        [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            PLog(@"setCompletionBlockWithSuccess responseObject: %@", responseObject);
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:tempLocalKey, @"LocalKey", nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDownloadSuccess object:nil userInfo:dicResult];
            if (tempdelegate && [tempdelegate respondsToSelector:@selector(doDownloadSuccess:)]) {
                [tempdelegate doDownloadSuccess:dicResult];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            PLog(@"failure: %@", error);
            NSDictionary *dicResult = [NSDictionary dictionaryWithObjectsAndKeys:tempLocalKey, @"LocalKey", tempDownloadCount, @"DownloadCount", nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDownloadFailed object:nil userInfo:dicResult];
            if (tempdelegate && [tempdelegate respondsToSelector:@selector(doDownloadFailed:)]) {
                [tempdelegate doDownloadFailed:dicResult];
            }
            
        }];
        
        [_operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            if (checkDownloadProcessCount < kCheckDownloadProcessCount) {
                checkDownloadProcessCount++;
                return;
            }
            
            checkDownloadProcessCount = 0;
            
            PLog(@"bytesRead: %d, totalBytesRead: %lld, totalBytesExpectedToRead: %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
            
            NSNumber *numBytesRead = [NSNumber numberWithUnsignedInteger:bytesRead];
            NSNumber *numTotalBytesRead = [NSNumber numberWithLongLong:totalBytesRead];
            NSNumber *numTotalBytesExpectedToRead = [NSNumber numberWithLongLong:totalBytesExpectedToRead];
            NSDictionary *dicProcess = [NSDictionary dictionaryWithObjectsAndKeys:tempLocalKey, @"LocalKey", numBytesRead, @"BytesRead", numTotalBytesRead, @"TotalBytesRead", numTotalBytesExpectedToRead, @"TotalBytesExpectedToRead", nil];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDownloadProcess object:nil userInfo:dicProcess];
            if (tempdelegate && [tempdelegate respondsToSelector:@selector(doDownloadProcess:)]) {
                [tempdelegate doDownloadProcess:dicProcess];
            }
            
        }];
        [_operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
            
            PLog(@"setShouldExecuteAsBackgroundTaskWithExpirationHandler...");
            
        }];
        
        _isReadyToDownload = YES;
        PLog(@"initDownloader is ready...");
        
    } else {
        
        _isReadyToDownload = NO;
        PLog(@"initDownloader is unready...");
        
    }
    
    return _isReadyToDownload;
}

-(void)doStart{
    
    PLog(@"doStart...");
    
    if (_isReadyToDownload) {
        [_operation start];
    }
    
}

-(void)doPause{
    
    PLog(@"doPause...");
    [_operation pause];
    
}

-(void)doResume{
    
    PLog(@"doResume...");
    [_operation resume];
    
}

-(void)doStop{
    
    PLog(@"doStop...");
    _operation = nil;
    _requestUrl = nil;
    _cachePath = nil;
    _localKey = nil;
    _isReadyToDownload = NO;
    
}

@end
