//
//  PAMusicPlayer.h
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "PMusicPlayerDelegate.h"

@interface PAMusicPlayer : NSObject

/*
 播放手机里面的歌曲，网络歌曲
 */
@property (nonatomic, retain) AVPlayer *avPlayer;

/*
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
@property (nonatomic, retain) NSTimer *playerTimer;

@property (nonatomic, assign) id<PMusicPlayerDelegate> delegate;
@property (nonatomic, retain) Song *song;
@property (nonatomic, assign) BOOL playerDestoried;
@property (assign) BOOL isPlaying;

//初始化
-(BOOL)initPlayer;
-(void)playerDestory;

-(void)playAtTime:(NSTimeInterval)timeInterval;
//当前播放时间
-(NSTimeInterval)getCurrentTime;
//取得播放时间
-(NSTimeInterval)getDuration;

//播放
-(void)play;
//暂停
-(void)pause;
-(BOOL)isMusicPlaying;
-(void)playerPlayPause;

-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;

-(void)musicPlayDidEnd:(NSNotification *)notification;

@end
