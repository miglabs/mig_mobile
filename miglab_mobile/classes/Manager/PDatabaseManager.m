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
        
        [_db executeUpdate:@"create table if not exists USER_ACCOUNT (username text not null, password text not null, userid integer, accesstoken text, accounttype integer, logintime integer)"];
        [_db executeUpdate:@"create table if not exists USER_INFO (userid text not null, username text, nickname text, gender integer, type integer, birthday text, location text, age integer, source integer, head text)"];
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

//记录登录账号信息（aes加密）
-(void)insertUserAccout:(NSString *)tusername password:(NSString *)tpassword{
    
    //默认为本身数据
    [self insertUserAccout:tusername password:tpassword userid:@"" accessToken:@"" accountType:0];
    
}

-(void)insertUserAccout:(NSString *)tusername password:(NSString *)tpassword userid:(NSString *)tuserid accessToken:(NSString *)taccesstoken accountType:(int)taccounttype{
    
    NSString *encodeUsername = [PCommonUtil encodeAesAndBase64StrFromStr:tusername];
    NSString *encodePassword = [PCommonUtil encodeAesAndBase64StrFromStr:tpassword];
    NSDate *nowDate = [NSDate date];
    long loginTime = [nowDate timeIntervalSince1970];
    NSNumber *numAccountType = [NSNumber numberWithInt:taccounttype];
    NSNumber *numLoginTime = [NSNumber numberWithLong:loginTime];
    
    NSString *sql = @"insert into USER_ACCOUNT (username, password, userid, accesstoken, accounttype, logintime) values (?, ?, ?, ?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    NSString *checksql = [NSString stringWithFormat:@"select username from USER_ACCOUNT where username = '%@' ", encodeUsername];
    PLog(@"checksql: %@", checksql);
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        sql = @"update USER_ACCOUNT set username = ? , password = ? , userid = ? , accesstoken = ? , accounttype = ? , logintime = ? ";
        PLog(@"sql: %@", sql);
        break;
    }
    
    [_db executeUpdate:sql, encodeUsername, encodePassword, tuserid, taccesstoken, numAccountType, numLoginTime];
    [_db close];
    
}

//获取最近登录使用的账号
-(AccountOf3rdParty *)getLastLoginUserAccount{
    
    AccountOf3rdParty *account = nil;
    
    NSString *sql = @"select username, password, userid, accesstoken, accounttype from USER_ACCOUNT order by logintime desc";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        NSString *pusername = [rs stringForColumn:@"username"];
        NSString *ppassword = [rs stringForColumn:@"password"];
        NSString *puserid = [rs stringForColumn:@"userid"];
        NSString *paccesstoken = [rs stringForColumn:@"accesstoken"];
        int paccounttype = [rs intForColumn:@"accounttype"];
        
        account = [[AccountOf3rdParty alloc] init];
        account.username = [PCommonUtil decodeAesAndBase64StrFromStr:pusername];
        account.password = [PCommonUtil decodeAesAndBase64StrFromStr:ppassword];
        account.accountid = puserid;
        account.accesstoken = paccesstoken;
        account.accounttype = paccounttype;
        
        break;
    }
    
    [_db close];
    
    return account;
}

//根据userid删除制定账号
-(void)deleteUserAccountByUserName:(NSString *)tusername{
    
    NSString *sql = @"delete from USER_ACCOUNT where username = ? ";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql, tusername];
    [_db close];
    
}

//清空账号
-(void)deleteAllUserAccount{
    
    NSString *sql = @"delete from USER_ACCOUNT";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

//设置某个歌曲的总文件大小
-(void)setSongMaxSize:(long long)tlocalkey type:(NSString *)ttype fileMaxSize:(long long)tfilemaxsize{
    
    if ([self isExistsSongMaxSize:tlocalkey type:ttype]) {
        return;
    }
    
    NSNumber *numLocalKey = [NSNumber numberWithLongLong:tlocalkey];
    NSString *strType = (ttype == nil) ? @"type" : ttype;
    NSNumber *numFileMaxSize = [NSNumber numberWithLongLong:tfilemaxsize];
    
    NSString *sql = @"insert into SONG_DOWNLOAD_INFO (songid, type, filemaxsize) values (?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql, numLocalKey, strType, numFileMaxSize];
    [_db close];
    
}

//判断是否已经记录歌曲的总文件大小
-(BOOL)isExistsSongMaxSize:(long long)tlocalkey type:(NSString *)ttype{
    
    BOOL isExists = NO;
    
    NSString *sql = [NSString stringWithFormat:@"select * from SONG_DOWNLOAD_INFO where songid = %lld and type = '%@' ", tlocalkey, ttype];
    PLog(@"sql: %@", sql);
    
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
    
    long long tfilemaxsize = 0;
    
    NSString *sql = [NSString stringWithFormat:@"select filemaxsize from SONG_DOWNLOAD_INFO where songid = %lld and type = '%@' ", tlocalkey, ttype];
    PLog(@"sql: %@", sql);
    
    [_db open];
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        tfilemaxsize = [rs longLongIntForColumn:@"filemaxsize"];
        
    }
    
    [_db close];
    
    return tfilemaxsize;
    
}

@end
