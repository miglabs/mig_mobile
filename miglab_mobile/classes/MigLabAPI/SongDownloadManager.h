//
//  SongDownloadManager.h
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "Song.h"

@interface SongDownloadManager : NSObject

@property (nonatomic, retain) AFHTTPRequestOperation *httpRequestOperation;
@property (nonatomic, retain) Song *song;
@property (assign) BOOL isReady;

+(NSString *)getCacheHomeDirectory;
+(NSString *)getSongCacheDirectory;
+(NSString *)getLrcCacheDirectory;
+(long long)getLocalFileSize:(NSString *)filepath;

+(SongDownloadManager *)GetInstance;

-(NSString *)getSongCachePath:(long long)tsongid songExt:(NSString *)tsongext;
-(BOOL)initDownloadInfo;
-(void)doStart;
-(void)doPause;
-(void)doResume;

@end
