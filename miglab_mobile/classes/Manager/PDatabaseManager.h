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
#import "Word.h"
#import "PUser.h"
#import "UserGene.h"

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

//记录QQ登陆账号信息
-(void)insertQQAccount:(NSString*)accessToken data:(NSDate*)expireDate appid:(NSString*)localAppid openid:(NSString*)openId url:(NSString*)redirectUrl permit:(NSString*)permission;
-(AccountOf3rdParty *)getQQAccount;

//更新当前账号生日信息
-(void)updateBirthday:(NSString*)birthday accountId:(NSString *)taccountid;
//更新当前账号性别
-(void)updateGender:(NSString*)gender accountId:(NSString *)taccountid;
//更新当前账号昵称
-(void)updateNickname:(NSString*)nickname accountId:(NSString *)taccountid;

//记录用户信息
-(void)insertUserInfo:(PUser *)tuser accountId:(NSString *)taccountid;
//根据第三方唯一taccountid获取用户信息
-(PUser *)getUserInfoByAccountId:(NSString *)taccountid;
//根据第三方唯一taccountid删除用户信息
-(void)deleteUserInfoByAccountId:(NSString *)taccountid;
//清空用户信息
-(void)deleteAllUserInfo;

//记录用户音乐基因
-(void)insertUserGene:(UserGene *)tusergene userId:(NSString *)tuserid;
//根据用户userid获取音乐基因信息
-(UserGene *)getUserGeneByUserId:(NSString *)tuserid;
-(void)deleteUserGeneByUserId:(NSString *)tuserid;
-(void)deleteUserGene;

// 记录用户是否已经退出登录
-(void)setLoginStatusInfo:(int)logstate; // 0:logout, 1:login
-(int)getLoginStatusInfo;

//记录社交的好友数,歌曲数,附近歌友数,消息数,
-(void)setFriendNumbers:(NSMutableArray*)numbers;
-(NSMutableArray*)getFriendNumbers;

/*
 记录请求歌曲返回数据结果
 1.用于有效期内缓存数据，2.确认返回歌曲url和歌名是否一致
 */
-(NSString *)getSongInfoJsonData:(long)tTimeoutInterval;
-(NSString *)getSongInfoJsonData;
-(void)insertSongInfoJson:(NSString *)tSongJson;
-(void)deleteSongInfoJson;

/*
 歌曲数据列表记录
 */
-(void)insertSongInfo:(Song *)tsong;
-(void)insertSongInfoList:(NSMutableArray *)tsonginfolist;
-(NSMutableArray *)getSongInfoList:(int)trowcount;
-(NSMutableArray *)getSongInfoListByUserGene:(UserGene *)tusergene rowCount:(int)trowcount;
-(NSMutableArray *)getLikeSongInfoList:(int)trowcount;
-(void)deleteSongInfo:(long long)tlocalkey;
-(void)deleteAllSongInfo;
-(void)updateSongInfoOfLike:(long long)tlocalkey like:(NSString *)tlike;

/*
 导入本地歌曲记录
 */
-(void)insertIPodSongInfo:(Song *)tsong;
-(NSMutableArray *)getIPodSongInfoList:(int)trowcount;
-(Song *)getIPodSongInfo:(NSString *)tsongname;
-(int)getIPodSongCount;
-(void)deleteIPodSongInfo:(long long)tlocalkey;
-(void)deleteAllIPodSongInfo;

/*
 描述词记录(心情，场景)
 */
-(void)insertWordInfo:(Word *)tword;
-(NSMutableArray *)getWordInfoList:(int)trowcount;
-(NSMutableArray *)getWordInfoListByMode:(NSString *)tmode;
-(void)deleteAllWordInfo;

//设置某个歌曲的总文件大小
-(void)setSongMaxSize:(long long)tlocalkey type:(NSString *)ttype fileMaxSize:(long long)tfilemaxsize;
//判断是否已经记录歌曲的总文件大小
-(BOOL)isExistsSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;
//获取某个歌曲的总文件大小
-(long long)getSongMaxSize:(long long)tlocalkey type:(NSString *)ttype;

@end
