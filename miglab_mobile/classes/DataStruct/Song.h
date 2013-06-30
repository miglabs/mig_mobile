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
@property (nonatomic, retain) NSString *duration;                       //歌曲时长
@property (nonatomic, retain) NSString *songurl;                        //歌曲网络地址
@property (nonatomic, retain) NSString *lrcurl;                         //歌词地址
@property (nonatomic, retain) NSString *coverurl;                       //专辑封面图片地址
@property (nonatomic, retain) NSString *like;

/*
 0-app中打包的歌曲
 1-手机库中的歌曲
 2-网络下载到手机缓存的歌曲
 3-网络歌曲
 */
@property (nonatomic, assign) WhereIsTheSong whereIsTheSong;

+(id)initWithNSDictionary:(NSDictionary *)dict;

@end
