//
//  PAudioStreamerPlayer.h
//  miglab_mobile
//
//  Created by Archer_LJ on 14-9-3.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioStreamer.h"
#import "Song.h"
#import "PMusicPlayerDelegate.h"

@interface PAudioStreamerPlayer : NSObject

@property (nonatomic, retain) AudioStreamer *streamerPlayer;

/*
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
@property (nonatomic, retain) NSTimer *playerTimer;

@property (nonatomic, assign) id<PMusicPlayerDelegate> delegate;
@property (nonatomic, retain) Song *song;
@property (nonatomic, assign) BOOL playerDestroied;

//初始化
-(BOOL)initPlayer;
-(void)playerDestroy;

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

//播放时间刷新
-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;


@end
