//
//  PDatabaseManager.m
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PDatabaseManager.h"
#import "pinyin.h"

@implementation PDatabaseManager

@synthesize db = _db;

+(PDatabaseManager *)GetInstance{
    
    static PDatabaseManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[PDatabaseManager alloc] init];
            [instance initDataInfo];
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
        
        //user info
        [_db executeUpdate:@"create table if not exists USER_ACCOUNT (username text not null, password text, userid integer, accesstoken text, accounttype integer, logintime integer)"];
        
        [_db executeUpdate:@"create table if not exists USER_INFO (accountid text not null, userid text not null, username text, nickname text, gender integer, type integer, birthday text, location text, age integer, source integer, head text, token text)"];
        
        //song cache
        [_db executeUpdate:@"create table if not exists SONG_LOCAL_INFO (songid integer, songname text, pinyin text, artist text, pubtime text, album text, duration text, songurl text, hqurl text, lrcurl text, coverurl text, like text, type text, typeid integer, createtime integer, collectnum integer, commentnum integer, hot integer)"];
        [_db executeUpdate:@"create table if not exists SONG_DOWNLOAD_INFO (songid integer, type text, filemaxsize integer)"];
        
        //ipod song
        [_db executeUpdate:@"create table if not exists IPOD_SONG_INFO (songid integer, songname text, artist text, duration text, songurl text, hqurl text, lrcurl text, coverurl text, like text, cachepath text, createtime integer)"];
        
        [_db executeUpdate:@"create table if not exists WORD_INFO (index integer not null, typeid integer not null, name text, mode text)"];
        
        [_db executeUpdate:@"create table if not exists SONG_JSON_INFO (jsonid integer, songjsoninfo text, createtime integer)"];
        
        [_db close];
    }
    
    return self;
}

//重制部分数据记录
-(void)initDataInfo{
    
    PLog(@"initDataInfo begin...............................................");
    
    NSMutableArray *psonginfolist = [self getDefaultSongInfoList];
    [self insertSongInfoList:psonginfolist];
    
//    int songinfocount = [psonginfolist count];
//    for (int i=0; i<songinfocount; i++) {
//        
//        Song *psong = [psonginfolist objectAtIndex:i];
//        
//        [self insertSongInfo:psong];
//    }
    
    PLog(@"initDataInfo end...............................................");
}

//default song info list
-(NSMutableArray *)getDefaultSongInfoList{
    
    NSMutableArray *defaultSongInfoList = [[NSMutableArray alloc] init];
    
    Song *song0 = [[Song alloc] init];
    song0.songid = 346630;
    song0.songname = @"寂寞";
    song0.artist = @"谢容儿";
    song0.songurl = @"http://umusic.9158.com/2013/07/14/14/14/346630_3cd4dbc8abde417c83cd9261f50bdb4c.mp3";
    song0.coverurl = @"http://upic.9158.com/2013/07/12/12/31/20130712123159_img1008690313.jpg";
    song0.type = @"chl";
    song0.tid = 0;
    song0.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    [defaultSongInfoList addObject:song0];
    
    Song *song1 = [[Song alloc] init];
    song1.songid = 314001;
    song1.songname = @"黄梅戏";
    song1.artist = @"慕容晓晓";
    song1.songurl = @"http://umusic.9158.com/2013/07/06/09/21/314001_a2e7fbfef7bd448e9349a3becfdea19e.mp3";
    song1.coverurl = @"http://upic.9158.com/2013/07/07/05/49/20130707054950_img1008690313.jpg";
    song1.type = @"chl";
    song1.tid = 0;
    song1.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    [defaultSongInfoList addObject:song1];
    
    Song *song2 = [[Song alloc] init];
    song2.songid = 284711;
    song2.songname = @"青春纪念册";
    song2.artist = @"G_voice家族";
    song2.songurl = @"http://umusic.9158.com/2013/06/29/16/35/284711_abbf9d95fcbe42a486e86d4281881e0a.mp3";
    song2.coverurl = @"http://upic.9158.com/2013/07/05/07/16/20130705071624_img1008690313.jpg";
    song2.type = @"chl";
    song2.tid = 0;
    song2.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    [defaultSongInfoList addObject:song2];
    
    Song *song3 = [[Song alloc] init];
    song3.songid = 267654;
    song3.songname = @"你是我的眼";
    song3.artist = @"萧煌奇";
    song3.songurl = @"http://umusic.9158.com/2013/06/24/23/40/267654_c281b790308e41d2966b24cf56838c0e.mp3";
    song3.type = @"chl";
    song3.tid = 0;
    song3.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    [defaultSongInfoList addObject:song3];
    
    return defaultSongInfoList;
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
        account.accesstoken = (paccesstoken.length > 10) ? paccesstoken : nil;
        account.accounttype = paccounttype;
        [account log];
        
        break;
    }
    
    [_db close];
    
    return account;
}

//根据userid删除制定账号
-(void)deleteUserAccountByUserName:(NSString *)tusername{
    
    NSString *sql = @"delete from USER_ACCOUNT where username = ? or userid = ? ";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql, tusername, tusername];
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

//记录用户信息
-(void)insertUserInfo:(PUser *)tuser accountId:(NSString *)taccountid{
    
    if (!tuser) {
        return;
    }
    
    NSDate *nowDate = [NSDate date];
    long loginTime = [nowDate timeIntervalSince1970];
    NSNumber *numLoginTime = [NSNumber numberWithLong:loginTime];
    NSNumber *numGender = [NSNumber numberWithInt:tuser.gender];
    NSNumber *numType = [NSNumber numberWithInt:tuser.type];
    NSNumber *numAge = [NSNumber numberWithInt:tuser.age];
    NSNumber *numAccountType = [NSNumber numberWithInt:tuser.source];
    
    
    NSString *sql = @"insert into USER_INFO (accountid, userid, username, nickname, gender, type, birthday, location, age, source, head, token, logintime) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    NSString *checksql = [NSString stringWithFormat:@"select username from USER_INFO where accountid = '%@' ", taccountid];
    PLog(@"checksql: %@", checksql);
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        sql = @"update USER_INFO set userid = ? , username = ? , nickname = ? , gender = ? , type = ? , birthday = ? , location = ? , age = ? , source = ? , head = ? , token = ? , logintime = ? where accountid = ? ";
        PLog(@"sql: %@", sql);
        break;
    }
    
    [_db executeUpdate:sql, tuser.userid, tuser.username, tuser.nickname, numGender, numType, tuser.birthday, tuser.location, numAge, numAccountType, tuser.head, tuser.token, numLoginTime, taccountid];
    [_db close];
    
}

//根据第三方唯一taccountid获取用户信息
-(PUser *)getUserInfoByAccountId:(NSString *)taccountid{
    
    PUser *tempuser = nil;
    
    NSString *sql = [NSString stringWithFormat:@"select userid, username, nickname, gender, type, birthday, location, age, source, head, token from USER_INFO where accountid = '%@' ", taccountid];
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        NSString *puserid = [rs stringForColumn:@"userid"];
        NSString *pusername = [rs stringForColumn:@"username"];
        NSString *pnickname = [rs stringForColumn:@"nickname"];
        int pgender = [rs intForColumn:@"gender"];
        int ptype = [rs intForColumn:@"type"];
        NSString *pbirthday = [rs stringForColumn:@"birthday"];
        NSString *plocation = [rs stringForColumn:@"location"];
        int page = [rs intForColumn:@"age"];
        int psource = [rs intForColumn:@"source"];
        NSString *phead = [rs stringForColumn:@"head"];
        NSString *ptoken = [rs stringForColumn:@"token"];
        
        tempuser = [[PUser alloc] init];
        tempuser.userid = puserid;
        tempuser.username = pusername;
        tempuser.nickname = pnickname;
        tempuser.gender = pgender;
        tempuser.type = ptype;
        tempuser.birthday = pbirthday;
        tempuser.location = plocation;
        tempuser.age = page;
        tempuser.source = psource;
        tempuser.head = phead;
        tempuser.token = ptoken;
        [tempuser log];
        
        break;
    }
    
    [_db close];
    
    return tempuser;
    
}

//根据第三方唯一taccountid删除用户信息
-(void)deleteUserInfoByAccountId:(NSString *)taccountid{
    
    NSString *sql = @"delete from USER_INFO where accountid = ? ";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql, taccountid];
    [_db close];
    
}

//清空用户信息
-(void)deleteAllUserInfo{
    
    NSString *sql = @"delete from USER_INFO";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

/*
 记录请求歌曲返回数据结果
 1.用于有效期内缓存数据，2.确认返回歌曲url和歌名是否一致
 */
-(NSString *)getSongInfoJsonData:(long)tTimeoutInterval{
    
    NSString *sql = [NSString stringWithFormat:@"select * from SONG_JSON_INFO order by createtime desc limit 1 "];
    PLog(@"sql: %@", sql);
    
    NSDate *nowDate = [NSDate date];
    long lnowtime = [nowDate timeIntervalSince1970];
    
    NSString *psongjsoninfo = nil;
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        long pcreatetime = [rs longForColumn:@"createtime"];
        if (pcreatetime + tTimeoutInterval >= lnowtime) {
            psongjsoninfo = [rs stringForColumn:@"songjsoninfo"];
        }
        
        break;
    }
    
    [_db close];
    
    return psongjsoninfo;
}

-(NSString *)getSongInfoJsonData{
    return [self getSongInfoJsonData:24 * 3600];
}

-(void)insertSongInfoJson:(NSString *)tSongJson{
    
    NSDate *nowDate = [NSDate date];
    long lnowtime = [nowDate timeIntervalSince1970];
    NSNumber *numCreateTime = [NSNumber numberWithLong:lnowtime];
    
    NSString *sql = @"insert into SONG_JSON_INFO (jsonid, songjsoninfo, createtime) values (?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql, numCreateTime, tSongJson, numCreateTime];
    [_db close];
    
}

-(void)deleteSongInfoJson{
    
    NSString *sql = @"delete from SONG_JSON_INFO";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

/*
 歌曲数据列表记录
 */
-(void)insertSongInfo:(Song *)tsong{
    
    NSString *sql = @"insert into SONG_LOCAL_INFO (songid, songname, pinyin, artist, pubtime, album, duration, songurl, hqurl, lrcurl, coverurl, like, type, typeid, createtime, collectnum, commentnum, hot) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    NSString *pinYinResult = [[NSString alloc] init];
    
    [_db open];
    
    NSString *checksql = [NSString stringWithFormat:@"select * from SONG_LOCAL_INFO where songid = %lld ", tsong.songid];
    PLog(@"checksql: %@", checksql);
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        PLog(@"is exists...");
        return;
    }
    
    if (tsong.songname) {
        
        for (int i=0; i<tsong.songname.length; i++) {
            NSString *singlePinYinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([tsong.songname characterAtIndex:i])] uppercaseString];
            
            pinYinResult = [pinYinResult stringByAppendingString:singlePinYinLetter];
        }
        
        tsong.pinyin = pinYinResult;
        pinYinResult = @"";
    }
    
    NSNumber *numSongId = [NSNumber numberWithLongLong:tsong.songid];
    NSNumber *numTypeId = [NSNumber numberWithInt:tsong.tid];
    NSDate *nowDate = [NSDate date];
    NSNumber *numCreateTime = [NSNumber numberWithLong:[nowDate timeIntervalSince1970]];
    NSNumber *numCollectNum = [NSNumber numberWithInt:tsong.collectnum];
    NSNumber *numCommentNum = [NSNumber numberWithInt:tsong.commentnum];
    NSNumber *numHot = [NSNumber numberWithLongLong:tsong.hot];
    
    [_db executeUpdate:sql, numSongId, tsong.songname, tsong.artist, tsong.pubtime, tsong.album, tsong.duration, tsong.songurl, tsong.hqurl, tsong.lrcurl, tsong.coverurl, tsong.like, tsong.type, numTypeId, numCreateTime, numCollectNum, numCommentNum, numHot];
    [_db close];
    
}

-(void)insertSongInfoList:(NSMutableArray *)tsonginfolist{
    
    NSString *sql = @"insert into SONG_LOCAL_INFO (songid, songname, pinyin, artist, pubtime, album, duration, songurl, hqurl, lrcurl, coverurl, like, type, typeid, createtime, collectnum, commentnum, hot) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    NSString *pinYinResult = [[NSString alloc] init];
    
    [_db open];
    
    int songCount = [tsonginfolist count];
    for (int i=0; i<songCount; i++) {
        
        Song *tsong = [tsonginfolist objectAtIndex:i];
        [tsong log];
        
        if (!tsong.songurl || tsong.songurl.length < 5) {
            continue;
        }
        
        NSString *checksql = [NSString stringWithFormat:@"select * from SONG_LOCAL_INFO where songid = %lld ", tsong.songid];
        PLog(@"checksql: %@", checksql);
        
        //
        BOOL isExists = NO;
        FMResultSet *rs = [_db executeQuery:checksql];
        while ([rs next]) {
            
            isExists = YES;
            break;
        }
        
        if (isExists) {
            PLog(@"is exists...");
            continue;
        }
        NSLog(@"i: %d", i);
        
        if (tsong.songname) {
            
            for (int i=0; i<tsong.songname.length; i++) {
                NSString *singlePinYinLetter = [[NSString stringWithFormat:@"%c", pinyinFirstLetter([tsong.songname characterAtIndex:i])] uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinYinLetter];
            }
            
            tsong.pinyin = pinYinResult;
            pinYinResult = @"";
        }
        
        NSNumber *numSongId = [NSNumber numberWithLongLong:tsong.songid];
        NSNumber *numTypeId = [NSNumber numberWithInt:tsong.tid];
        NSDate *nowDate = [NSDate date];
        NSNumber *numCreateTime = [NSNumber numberWithLong:[nowDate timeIntervalSince1970]];
        NSNumber *numCollectNum = [NSNumber numberWithInt:tsong.collectnum];
        NSNumber *numCommentNum = [NSNumber numberWithInt:tsong.commentnum];
        NSNumber *numHot = [NSNumber numberWithLongLong:tsong.hot];
        
        [_db executeUpdate:sql, numSongId, tsong.songname, tsong.pinyin, tsong.artist, tsong.pubtime, tsong.album, tsong.duration, tsong.songurl, tsong.hqurl, tsong.lrcurl, tsong.coverurl, tsong.like, tsong.type, numTypeId, numCreateTime, numCollectNum, numCommentNum, numHot];
        
    }
    
    [_db close];
    
}

-(NSMutableArray *)getSongInfoList:(int)trowcount{
    
    NSString *sql = [NSString stringWithFormat:@"select * from SONG_LOCAL_INFO order by createtime desc limit %d ", trowcount];
    PLog(@"sql: %@", sql);
    
    NSMutableArray *songInfoList = [[NSMutableArray alloc] init];
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        long long psongid = [rs longLongIntForColumn:@"songid"];
        NSString *psongname = [rs stringForColumn:@"songname"];
        NSString *ppinyin = [rs stringForColumn:@"pinyin"];
        NSString *partist = [rs stringForColumn:@"artist"];
        NSString *ppubtime = [rs stringForColumn:@"pubtime"];
        NSString *palbum = [rs stringForColumn:@"album"];
        NSString *pduration = [rs stringForColumn:@"duration"];
        NSString *psongurl = [rs stringForColumn:@"songurl"];
        NSString *phqurl = [rs stringForColumn:@"hqurl"];
        NSString *plrcurl = [rs stringForColumn:@"lrcurl"];
        NSString *pcoverurl = [rs stringForColumn:@"coverurl"];
        NSString *plike = [rs stringForColumn:@"like"];
        NSString *ptype = [rs stringForColumn:@"type"];
        int ptypeid = [rs intForColumn:@"typeid"];
        int pcollectnum = [rs intForColumn:@"collectnum"];
        int pcommentnum = [rs intForColumn:@"commentnum"];
        long long phot = [rs longLongIntForColumn:@"hot"];
        
        Song *psong = [[Song alloc] init];
        psong.songid = psongid;
        psong.songname = psongname;
        psong.pinyin = ppinyin;
        psong.artist = partist;
        psong.pubtime = ppubtime;
        psong.album = palbum;
        psong.duration = pduration;
        psong.songurl = psongurl;
        psong.hqurl = phqurl;
        psong.lrcurl = plrcurl;
        psong.coverurl = pcoverurl;
        psong.like = plike;
        psong.type = ptype;
        psong.tid = ptypeid;
        psong.collectnum = pcollectnum;
        psong.commentnum = pcommentnum;
        psong.hot = phot;
        psong.whereIsTheSong = WhereIsTheSong_IN_CACHE;
        psong.songCachePath = [songManager getSongCachePath:psong];
        [psong log];
        
        [songInfoList addObject:psong];
    }
    
    [_db close];
    
    return songInfoList;
}

-(NSMutableArray *)getLikeSongInfoList:(int)trowcount{
    
    NSString *sql = [NSString stringWithFormat:@"select * from SONG_LOCAL_INFO where like = '1' order by createtime desc limit %d ", trowcount];
    PLog(@"sql: %@", sql);
    
    NSMutableArray *songInfoList = [[NSMutableArray alloc] init];
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        long long psongid = [rs longLongIntForColumn:@"songid"];
        NSString *psongname = [rs stringForColumn:@"songname"];
        NSString *ppinyin = [rs stringForColumn:@"pinyin"];
        NSString *partist = [rs stringForColumn:@"artist"];
        NSString *ppubtime = [rs stringForColumn:@"pubtime"];
        NSString *palbum = [rs stringForColumn:@"album"];
        NSString *pduration = [rs stringForColumn:@"duration"];
        NSString *psongurl = [rs stringForColumn:@"songurl"];
        NSString *phqurl = [rs stringForColumn:@"hqurl"];
        NSString *plrcurl = [rs stringForColumn:@"lrcurl"];
        NSString *pcoverurl = [rs stringForColumn:@"coverurl"];
        NSString *plike = [rs stringForColumn:@"like"];
        NSString *ptype = [rs stringForColumn:@"type"];
        int ptypeid = [rs intForColumn:@"typeid"];
        int pcollectnum = [rs intForColumn:@"collectnum"];
        int pcommentnum = [rs intForColumn:@"commentnum"];
        long long phot = [rs longLongIntForColumn:@"hot"];
        
        Song *psong = [[Song alloc] init];
        psong.songid = psongid;
        psong.songname = psongname;
        psong.pinyin = ppinyin;
        psong.artist = partist;
        psong.pubtime = ppubtime;
        psong.album = palbum;
        psong.duration = pduration;
        psong.songurl = psongurl;
        psong.hqurl = phqurl;
        psong.lrcurl = plrcurl;
        psong.coverurl = pcoverurl;
        psong.like = plike;
        psong.type = ptype;
        psong.tid = ptypeid;
        psong.collectnum = pcollectnum;
        psong.commentnum = pcommentnum;
        psong.hot = phot;
        psong.whereIsTheSong = WhereIsTheSong_IN_CACHE;
        psong.songCachePath = [songManager getSongCachePath:psong];
        [psong log];
        
        [songInfoList addObject:psong];
    }
    
    [_db close];
    
    return songInfoList;
}

-(void)deleteSongInfo:(long long)tlocalkey{
    
    NSString *sql = [NSString stringWithFormat:@"delete from SONG_LOCAL_INFO where songid = %lld ", tlocalkey];
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

-(void)deleteAllSongInfo{
    
    NSString *sql = @"delete from SONG_LOCAL_INFO";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

-(void)updateSongInfoOfLike:(long long)tlocalkey like:(NSString *)tlike{
    
    NSString *sql = @"update SONG_LOCAL_INFO set like = ? where songid = ?";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    NSNumber *numSongId = [NSNumber numberWithLongLong:tlocalkey];
    
    [_db executeUpdate:sql, tlike, numSongId];
    [_db close];
    
}

/*
 导入本地歌曲记录
 */
-(void)insertIPodSongInfo:(Song *)tsong{
    
    NSString *sql = @"insert into IPOD_SONG_INFO (songid, songname, artist, duration, songurl, hqurl, lrcurl, coverurl, like, cachepath, createtime) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    NSString *checksql = [NSString stringWithFormat:@"select * from IPOD_SONG_INFO where songname ＝ '%@' ", tsong.songname];
    PLog(@"checksql: %@", checksql);
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        PLog(@"is exists...");
        return;
    }
    
    NSNumber *numSongId = [NSNumber numberWithLongLong:tsong.songid];
    NSDate *nowDate = [NSDate date];
    NSNumber *numCreateTime = [NSNumber numberWithLong:[nowDate timeIntervalSince1970]];
    
    [_db executeUpdate:sql, numSongId, tsong.songname, tsong.artist, tsong.duration, tsong.songurl, tsong.hqurl, tsong.lrcurl, tsong.coverurl, tsong.like, tsong.songCachePath, numCreateTime];
    [_db close];
    
}

-(NSMutableArray *)getIPodSongInfoList:(int)trowcount{
    
    NSString *sql = [NSString stringWithFormat:@"select * from IPOD_SONG_INFO order by createtime desc limit %d ", trowcount];
    PLog(@"sql: %@", sql);
    
    NSMutableArray *songInfoList = [[NSMutableArray alloc] init];
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        long long psongid = [rs longLongIntForColumn:@"songid"];
        NSString *psongname = [rs stringForColumn:@"songname"];
        NSString *partist = [rs stringForColumn:@"artist"];
        NSString *pduration = [rs stringForColumn:@"duration"];
        NSString *psongurl = [rs stringForColumn:@"songurl"];
        NSString *phqurl = [rs stringForColumn:@"hqurl"];
        NSString *plrcurl = [rs stringForColumn:@"lrcurl"];
        NSString *pcoverurl = [rs stringForColumn:@"coverurl"];
        NSString *plike = [rs stringForColumn:@"like"];
        NSString *pcachepath = [rs stringForColumn:@"cachepath"];
        
        Song *psong = [[Song alloc] init];
        psong.songid = psongid;
        psong.songname = psongname;
        psong.artist = partist;
        psong.duration = pduration;
        psong.songurl = psongurl;
        psong.hqurl = phqurl;
        psong.lrcurl = plrcurl;
        psong.coverurl = pcoverurl;
        psong.like = plike;
        psong.whereIsTheSong = WhereIsTheSong_IN_CACHE;
        psong.songCachePath = pcachepath;
        psong.songtype = 1;//1-ipod歌曲
        [psong log];
        
        [songInfoList addObject:psong];
    }
    
    [_db close];
    
    return songInfoList;
    
}

-(Song *)getIPodSongInfo:(NSString *)tsongname{
    
    Song *psong = nil;
    
    NSString *sql = [NSString stringWithFormat:@"select * from IPOD_SONG_INFO where songname ＝ '%@' ", tsongname];
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        long long psongid = [rs longLongIntForColumn:@"songid"];
        NSString *psongname = [rs stringForColumn:@"songname"];
        NSString *partist = [rs stringForColumn:@"artist"];
        NSString *pduration = [rs stringForColumn:@"duration"];
        NSString *psongurl = [rs stringForColumn:@"songurl"];
        NSString *phqurl = [rs stringForColumn:@"hqurl"];
        NSString *plrcurl = [rs stringForColumn:@"lrcurl"];
        NSString *pcoverurl = [rs stringForColumn:@"coverurl"];
        NSString *plike = [rs stringForColumn:@"like"];
        NSString *pcachepath = [rs stringForColumn:@"cachepath"];
        
        psong = [[Song alloc] init];
        psong.songid = psongid;
        psong.songname = psongname;
        psong.artist = partist;
        psong.duration = pduration;
        psong.songurl = psongurl;
        psong.hqurl = phqurl;
        psong.lrcurl = plrcurl;
        psong.coverurl = pcoverurl;
        psong.like = plike;
        psong.whereIsTheSong = WhereIsTheSong_IN_CACHE;
        psong.songCachePath = pcachepath;
        psong.songtype = 1;//1-ipod歌曲
        [psong log];
        
    }
    
    [_db close];
    
    return psong;
}

-(int)getIPodSongCount{
    
    int songCount = 0;
    
    NSString *sql = @"select count(1) as songcount from IPOD_SONG_INFO";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        songCount = [rs intForColumn:@"songcount"];
        PLog(@"songcount: %d", songCount);
        
        break;
    }
    
    [_db close];
    
    return songCount;
}

-(void)deleteIPodSongInfo:(long long)tlocalkey{
    
    NSString *sql = [NSString stringWithFormat:@"delete from IPOD_SONG_INFO where songid = %lld ", tlocalkey];
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

-(void)deleteAllIPodSongInfo{
    
    NSString *sql = @"delete from IPOD_SONG_INFO";
    PLog(@"sql: %@", sql);
    
    [_db open];
    [_db executeUpdate:sql];
    [_db close];
    
}

/*
 描述词记录(心情，场景)
 */
-(void)insertWordInfo:(Word *)tword{
    
    NSString *sql = @"insert into WORK_INFO (index, typeid, name, mode) values (?, ?, ?, ?)";
    PLog(@"sql: %@", sql);
    
    [_db open];
    
    NSString *checksql = [NSString stringWithFormat:@"select * from WORK_INFO where typeid = %d , mode = '%@' ", tword.typeid, tword.mode];
    PLog(@"checksql: %@", checksql);
    
    FMResultSet *rs = [_db executeQuery:checksql];
    while ([rs next]) {
        
        PLog(@"is exists...");
        return;
    }
    
    NSNumber *numIndex = [NSNumber numberWithInt:tword.index];
    NSNumber *numTypeId = [NSNumber numberWithLongLong:tword.typeid];
    
    [_db executeUpdate:sql, numIndex, numTypeId, tword.name, tword.mode];
    [_db close];
    
}

-(NSMutableArray *)getWordInfoList:(int)trowcount{
    
    NSString *sql = [NSString stringWithFormat:@"select * from WORD_INFO limit %d ", trowcount];
    PLog(@"sql: %@", sql);
    
    NSMutableArray *wordInfoList = [[NSMutableArray alloc] init];
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        int pindex = [rs intForColumn:@"index"];
        int ptypeid = [rs intForColumn:@"typeid"];
        NSString *pname = [rs stringForColumn:@"name"];
        NSString *pmode = [rs stringForColumn:@"mode"];
        
        
        Word *pword = [[Word alloc] init];
        pword.index = pindex;
        pword.typeid = ptypeid;
        pword.name = pname;
        pword.mode = pmode;
        
        [wordInfoList addObject:pword];
    }
    
    [_db close];
    
    return wordInfoList;
}

-(NSMutableArray *)getWordInfoListByMode:(NSString *)tmode{
    
    NSString *sql = [NSString stringWithFormat:@"select * from WORD_INFO where mode = '%@' ", tmode];
    PLog(@"sql: %@", sql);
    
    NSMutableArray *wordInfoList = [[NSMutableArray alloc] init];
    
    [_db open];
    
    FMResultSet *rs = [_db executeQuery:sql];
    while ([rs next]) {
        
        int pindex = [rs intForColumn:@"index"];
        int ptypeid = [rs intForColumn:@"typeid"];
        NSString *pname = [rs stringForColumn:@"name"];
        NSString *pmode = [rs stringForColumn:@"mode"];
        
        
        Word *pword = [[Word alloc] init];
        pword.index = pindex;
        pword.typeid = ptypeid;
        pword.name = pname;
        pword.mode = pmode;
        
        [wordInfoList addObject:pword];
    }
    
    [_db close];
    
    return wordInfoList;
    
}

-(void)deleteAllWordInfo{
    
    NSString *sql = @"delete from WORK_INFO";
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
