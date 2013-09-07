//
//  Song.h
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    WhereIsTheSong_IN_APP = 0,
    WhereIsTheSong_IN_IPOD = 1,
    WhereIsTheSong_IN_CACHE = 2,
    WhereIsTheSong_IN_NET = 3
    
} WhereIsTheSong;

@interface Song : NSObject

@property (nonatomic, assign) long long songid;                         //歌曲id
@property (nonatomic, retain) NSString *songname;                       //歌曲名称
@property (nonatomic, retain) NSString *artist;                         //原唱
@property (nonatomic, retain) NSString *pubtime;                        //发行时间
@property (nonatomic, retain) NSString *album;                          //专辑
@property (nonatomic, retain) NSString *duration;                       //歌曲时长
@property (nonatomic, retain) NSString *songurl;                        //歌曲网络地址
@property (nonatomic, retain) NSString *hqurl;                          //高质量音频url
@property (nonatomic, retain) NSString *lrcurl;                         //歌词地址
@property (nonatomic, retain) NSString *coverurl;                       //专辑封面图片地址
@property (nonatomic, retain) NSString *like;                           //红心
@property (nonatomic, retain) NSString *type;                           //类型
@property (nonatomic, assign) int tid;                                  //类型ID
@property (nonatomic, assign) int wordid;
@property (nonatomic, assign) int songtype;                             //歌曲类型，1-本地歌曲，2-网络歌曲
@property (nonatomic, assign) int collectnum;                           //收藏个数
@property (nonatomic, assign) int commentnum;                           //评论个数
@property (nonatomic, assign) long long hot;                            //收听次数


@property (nonatomic, retain) NSString *songCachePath;                  //本地缓存路径

/*
 0-app中打包的歌曲
 1-手机库中的歌曲
 2-网络下载到手机缓存的歌曲
 3-网络歌曲
 */
@property (nonatomic, assign) WhereIsTheSong whereIsTheSong;

+(id)initWithNSDictionary:(NSDictionary *)dict;
-(void)log;

@end
