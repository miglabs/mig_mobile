//
//  PMusicPlayer.h
//  miglab_mobile
//
//  Created by apple on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Song.h"
#import "PMusicPlayerDelegate.h"

@interface PMusicPlayer : NSObject<PMusicPlayerDelegate>

/*
 播放手机里面的歌曲，网络歌曲
 */
@property (nonatomic, retain) AVPlayer *avPlayer;
@property (nonatomic, retain) AVPlayerItem *avPlayerItem;
@property (nonatomic, retain) id audioMix;
@property (nonatomic, retain) id volumeMixInput;

/*
 播放app中歌曲，下载到缓存的歌曲
 */
@property (nonatomic, retain) AVAudioPlayer *avAudioPlayer;

/*
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
@property (nonatomic, retain) NSTimer *playerTimer;

@property (nonatomic, retain) Song *song;
@property (nonatomic, assign) BOOL playerState;

//初始化
-(BOOL)initPlayer;
-(void)playerDestory;

//播放
-(void)play;
//暂停
-(void)pause;
//停止
-(void)stop;
//
-(void)playAtTime:(NSTimeInterval)timeInterval;
-(BOOL)isPlaying;
-(void)setSingleLoop;
-(void)setSinglePlay;

//当前播放时间
-(NSTimeInterval)getCurrentTime;
//取得播放时间
-(NSTimeInterval)getDuration;
-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;

-(void)musicPlayDidEnd:(NSNotification *)notification;

//音量调整
-(void)setVolume:(float)volume;

//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter;

@end
