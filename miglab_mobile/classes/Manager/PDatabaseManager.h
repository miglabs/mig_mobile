//
//  PDatabaseManager.h
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PFileManager.h"
#import "FMDatabase.h"
#import "AccountOf3rdParty.h"
#import "PCommonUtil.h"
#import "Song.h"
#import "SongDownloadManager.h"
#import "Work.h"

@interface PDatabaseManager : PFileManager

@property (nonatomic, retain) FMDatabase *db;

+(PDatabaseManager *)GetInstance;

//重制部分数据记录
-(void)initDataInfo;

//default song info list
-(NSMutableArray *)getDefaultSongInfoList;

//记录登录账号信息（aes加密）
-(void)insertUserAccout:(NSString *)tusername password:(NSString *)tpassword;
-(void)insertUserAccout:(NSString *)tusername password:(NSString *)tpassword userid:(NSString *)tuserid accessToken:(NSString *)taccesstoken accountType:(int)taccounttype;
//获取最近登录使用的账号
-(AccountOf3rdParty *)getLastLoginUserAccount;
//根据userid删除制定账号
-(void)deleteUserAccountByUserName:(NSString *)tusername;
//清空账号
-(void)deleteAllUserAccount;

/*
 歌曲数据列表记录
 */
-(void)insertSongInfo:(Song *)tsong;
-(NSMutableArray *)getSongInfoList:(int)trowcount;
-(void)deleteSongInfo:(long long)tlocalkey;
-(void)deleteAllSongInfo;

/*
 描述词记录(心情，场景)
 */
-(void)insertWordInfo:(Work *)tword;
-(NSMutableArray *)getWordInfoList:(int)trowcount;
-(void)deleteAllWordInfo;

//设置某个歌曲的总文件大小
-(void)setSongMaxSize:(long long)tlocalkey type:(NSString *)ttype fileMaxSize:(long long)tfilemaxsize;
//判断是否已经记录歌曲的总文件大小
-(BOOL)isExistsSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;
//获取某个歌曲的总文件大小
-(long long)getSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;

@end
