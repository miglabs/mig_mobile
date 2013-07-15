//
//  PDatabaseManager.m
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PDatabaseManager.h"

@implementation PDatabaseManager

@synthesize db = _db;

+(PDatabaseManager *)GetInstance{
    
    static PDatabaseManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[PDatabaseManager alloc] init];
        }
    }
    return instance;
    
}

-(id)init{
    
    self = [super init];
    if (self) {
        
        NSString *cacheHomeDir = [self getCacheHomeDirectory];
        NSString *dbpath = [cacheHomeDir stringByAppendingPathComponent:@"user.sqlite"];
        NSLog(@"dbpath: %@", dbpath);
        
        _db = [FMDatabase databaseWithPath:dbpath];
        [_db open];
        
        [_db executeUpdate:@"create table if not exists SONG_LOCAL_INFO (songid integer, songname text, artist text, duration text, songurl text, lrcurl text, coverurl text, like text, createtime integer)"];
        [_db executeUpdate:@"create table if not exists SONG_DOWNLOAD_INFO (songid integer, type text, filemaxsize integer)"];
        
        [_db close];
    }
    
    return self;
}

//重制部分数据记录
-(void)initDataInfo{
    
    PLog(@"initDataInfo...");
    
}

//设置某个歌曲的总文件大小
-(void)setSongMaxSize:(long long)tlocalkey type:(NSString *)ttype fileMaxSize:(long long)tfilemaxsize{
    
    PLog(@"tlocalkey: %lld, ttype: %@, tfilemaxsize: %lld", tlocalkey, ttype, tfilemaxsize);
    
    if ([self isExistsSongMaxSize:tlocalkey type:ttype]) {
        return;
    }
    
    NSNumber *numLocalKey = [NSNumber numberWithLongLong:tlocalkey];
    NSString *strType = (ttype == nil) ? @"type" : ttype;
    NSNumber *numFileMaxSize = [NSNumber numberWithLongLong:tfilemaxsize];
    
    NSString *sql = @"insert into SONG_DOWNLOAD_INFO (songid, type, filemaxsize) values (?, ?, ?)";
    
    [_db open];
    [_db executeUpdate:sql, numLocalKey, strType, numFileMaxSize];
    [_db close];
    
}

//判断是否已经记录歌曲的总文件大小
-(BOOL)isExistsSongMaxSize:(long long)tlocalkey type:(NSString *)ttype{
    
    PLog(@"tlocalkey: %lld, ttype: %@", tlocalkey, ttype);
    
    BOOL isExists = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from SONG_DOWNLOAD_INFO where songid = %lld and type = '%@' ", tlocalkey, ttype];
    
    [_db open];
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        isExists = YES;
    }
    
    [_db close];
    
    return isExists;
}

//获取某个歌曲的总文件大小
-(long long)getSongMaxSize:(long long)tlocalkey type:(NSString *)ttype{
    
    PLog(@"tlocalkey: %lld, ttype: %@", tlocalkey, ttype);
    
    long long tfilemaxsize = 0;
    
    NSString *sql = [NSString stringWithFormat:@"select filemaxsize from SONG_DOWNLOAD_INFO where songid = %lld and type = '%@' ", tlocalkey, ttype];
    
    [_db open];
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        tfilemaxsize = [rs longLongIntForColumn:@"filemaxsize"];
        
    }
    
    [_db close];
    
    return tfilemaxsize;
    
}

@end
