//
//  Song.h
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, assign) long long songId;                         //歌曲id
@property (nonatomic, retain) NSString *songName;                       //歌曲名称
@property (nonatomic, retain) NSString *artist;                         //原唱
@property (nonatomic, retain) NSString *duration;                       //歌曲时长
@property (nonatomic, retain) NSString *songUrl;                        //歌曲网络地址
@property (nonatomic, retain) NSString *lrcUrl;                         //歌词地址
@property (nonatomic, retain) NSString *coverUrl;                       //专辑封面图片地址
@property (nonatomic, retain) NSString *like;

+(id)initWithNSDictionary:(NSDictionary *)dict;

@end
