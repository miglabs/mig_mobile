//
//  PAAMusicPlayer.m
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PAAMusicPlayer.h"

@implementation PAAMusicPlayer

@synthesize avAudioPlayer = _avAudioPlayer;

@synthesize playerTimer = _playerTimer;

@synthesize delegate = _delegate;
@synthesize song = _song;
@synthesize playerDestoried = _playerDestoried;

-(id)init{
    
    self = [super init];
    if (self) {
        _playerDestoried = YES;
    }
    return self;
    
}

/*
 先取消，后初始化
 */
-(BOOL)initPlayer{
    
    //先取消
    [self playerDestory];
    
    PLog(@"initPlayer...");
    
    if (!_song || !_song.songCachePath) {
        return NO;
    }
    
    @try {
        
        /*
         0-app中打包的歌曲
         1-手机库中的歌曲
         2-网络下载到手机缓存的歌曲
         3-网络歌曲
         */
        if (_song.whereIsTheSong == WhereIsTheSong_IN_APP || _song.whereIsTheSong == WhereIsTheSong_IN_CACHE) {
            
            NSURL *url = [NSURL URLWithString:_song.songCachePath];
            _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            _avAudioPlayer.delegate = self;
            
            _playerDestoried = NO;
            
        } else {
            _playerDestoried = YES;
        }
        
    }
    @catch (NSException *exception) {
        PLog(@"PAAMusicPlayer initPlayer failed...");
        _playerDestoried = YES;
    }
    
    return (!_playerDestoried);
}

-(void)playerDestory{
    
    PLog(@"playerDestory...");
    
    if (_avAudioPlayer.isPlaying) {
        [self stop];
    }
    _playerDestoried = YES;
    
}

-(void)playAtTime:(NSTimeInterval)timeInterval{
    
    if (_avAudioPlayer) {
        _avAudioPlayer.currentTime = timeInterval;
    }
    
}

-(void)setSingleLoop{
    _avAudioPlayer.numberOfLoops = 100000;
}

-(void)setSinglePlay{
    _avAudioPlayer.numberOfLoops = 0;
}

//音量调整
-(void)setVolume:(float)volume{
    _avAudioPlayer.volume = volume;
}

//当前播放时间
-(NSTimeInterval)getCurrentTime{
    
    if (_avAudioPlayer == nil) {
        return 0;
    }
    return _avAudioPlayer.currentTime;
}

//取得播放时间
-(NSTimeInterval)getDuration{
    
    if (_avAudioPlayer == nil) {
        return 0;
    }
    return _avAudioPlayer.duration;
}

//播放
-(BOOL)play{
    
    PLog(@"play...");
    
    if (_avAudioPlayer == nil) {
        return NO;
    }
    
    BOOL isplayed = [_avAudioPlayer play];
    if (isplayed) {
        PLog(@"play start...");
        [self timerStart];
    }
    
    return isplayed;
}

//暂停
-(void)pause{
    
    PLog(@"pause...");
    
    [self playerTimerFunction];
    
    if (_avAudioPlayer) {
        [_avAudioPlayer pause];
    }
    [self timerStop];
    
}

//停止
-(void)stop{
    
    PLog(@"stop...");
    
    [self playerTimerFunction];
    
    if (_avAudioPlayer) {
        [_avAudioPlayer stop];
        _avAudioPlayer = nil;
    }
    [self timerStop];
    
}

-(BOOL)isMusicPlaying{
    
    if (_avAudioPlayer == nil) {
        return NO;
    }
    return _avAudioPlayer.playing;
}

-(void)playerPlayPause{
    
    if ([self isMusicPlaying]) {
        [self pause];
    } else {
        [self play];
    }
    
}

-(void)timerStop{
    
    @synchronized(self){
        if (_playerTimer) {
            if ([_playerTimer isValid]) {
                [_playerTimer invalidate];
            }
            _playerTimer = nil;
        }
    }
    
}

-(void)timerStart{
    
    [self timerStop];
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:PlayerTimerFunctionInterval target:self selector:@selector(playerTimerFunction) userInfo:nil repeats:YES];
    
}

-(void)playerTimerFunction{
    
    PLog(@"playerTimerFunction...");
    if (_delegate && [_delegate respondsToSelector:@selector(aaMusicPlayerTimerFunction)]) {
        [_delegate aaMusicPlayerTimerFunction];
    }
    
}

#pragma AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self timerStop];
    
    if (_delegate && [_delegate respondsToSelector:@selector(aaMusicPlayerStoped)])
    {
        [_delegate aaMusicPlayerStoped];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //change ui
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (player) [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if (player) [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (player) [player play];
}

@end
