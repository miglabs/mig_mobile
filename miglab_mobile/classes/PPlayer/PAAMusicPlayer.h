//
//  PAAMusicPlayer.h
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "PMusicPlayerDelegate.h"

@interface PAAMusicPlayer : NSObject<AVAudioPlayerDelegate>

/*
 播放app中歌曲，下载到缓存的歌曲
 */
@property (nonatomic, retain) AVAudioPlayer *avAudioPlayer;

/*
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
@property (nonatomic, retain) NSTimer *playerTimer;

@property (nonatomic, assign) id<PMusicPlayerDelegate> delegate;
@property (nonatomic, retain) Song *song;
@property (nonatomic, assign) BOOL playerDestoried;


//初始化
-(BOOL)initPlayer;
-(void)playerDestory;
//
-(void)playAtTime:(NSTimeInterval)timeInterval;
-(void)setSingleLoop;
-(void)setSinglePlay;
//音量调整
-(void)setVolume:(float)volume;
//当前播放时间
-(NSTimeInterval)getCurrentTime;
//取得播放时间
-(NSTimeInterval)getDuration;

//播放
-(BOOL)play;
//暂停
-(void)pause;
//停止
-(void)stop;
-(BOOL)isMusicPlaying;
-(void)playerPlayPause;

-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;




@end
