//
//  PDatabaseManager.h
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PFileManager.h"
#import "FMDatabase.h"
#import "User.h"
#import "PCommonUtil.h"

@interface PDatabaseManager : PFileManager

@property (nonatomic, retain) FMDatabase *db;

+(PDatabaseManager *)GetInstance;

//重制部分数据记录
-(void)initDataInfo;

//记录登录账号信息（aes加密）
-(void)insertUserAccout:(NSString *)tusername password:(NSString *)tpassword userid:(NSString *)tuserid;
//获取最近登录使用的账号
-(User *)getLastLoginUser;
//根据userid删除制定账号
-(void)deleteUserAccountByUserId:(NSString *)tuserid;
//清空账号
-(void)deleteAllUserAccount;

//设置某个歌曲的总文件大小
-(void)setSongMaxSize:(long long)tlocalkey type:(NSString *)ttype fileMaxSize:(long long)tfilemaxsize;
//判断是否已经记录歌曲的总文件大小
-(BOOL)isExistsSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;
//获取某个歌曲的总文件大小
-(long long)getSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;

@end
