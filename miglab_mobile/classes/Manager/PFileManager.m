//
//  PFileManager.m
//  miglab_mobile
//
//  Created by pig on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PFileManager.h"

@implementation PFileManager

-(NSString *)getCacheHomeDirectory{
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cacheHomeDirectory = [cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]];
    return cacheHomeDirectory;
}

-(NSString *)createPath:(NSString *)tpath{
    
    NSString *temppath = tpath;
    
    if (tpath == nil) {
        temppath = [self getCacheHomeDirectory];
    }
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:temppath isDirectory:NULL]) {
        [fm createDirectoryAtPath:temppath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return temppath;
}

-(long long)getLocalFileSize:(NSString *)filepath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filepath isDirectory:NULL]) {
        return 0;
    }
    NSDictionary *fileAttributes = [fm attributesOfItemAtPath:filepath error:nil];
    return [fileAttributes fileSize];
}

@end
