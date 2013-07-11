//
//  PAMusicPlayer.m
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PAMusicPlayer.h"

@implementation PAMusicPlayer

@synthesize avPlayer = _avPlayer;

@synthesize playerTimer = _playerTimer;

@synthesize delegate = _delegate;
@synthesize song = _song;
@synthesize playerDestoried = _playerDestoried;
@synthesize isPlaying = _isPlaying;

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
    
    if (!_song || !_song.songurl) {
        return NO;
    }
    
    @try {
        
        /*
         0-app中打包的歌曲
         1-手机库中的歌曲
         2-网络下载到手机缓存的歌曲
         3-网络歌曲
         */
        if (_song.whereIsTheSong == WhereIsTheSong_IN_IPOD || _song.whereIsTheSong == WhereIsTheSong_IN_NET) {
            
            NSURL *url = [NSURL URLWithString:_song.songurl];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
            _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            
            //添加播放完成的notifation
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            
            _playerDestoried = NO;
            
        }
        
    }
    @catch (NSException *exception) {
        PLog(@"PAMusicPlayer initPlayer failed...");
        _playerDestoried = YES;
    }
    
    return (!_playerDestoried);
}

-(void)playerDestory{
    
    PLog(@"playerDestory...");
    
    if (_avPlayer) {
        [self pause];
        _avPlayer = nil;
    }
    _playerDestoried = YES;
    
}

-(void)playAtTime:(NSTimeInterval)timeInterval{
    
    PLog(@"playAtTime: %f", timeInterval);
    
    //转换成CMTime才能给player来控制播放进度
    CMTime dragedCMTime = CMTimeMake(timeInterval, 1);
    [_avPlayer pause];
    [_avPlayer seekToTime:dragedCMTime completionHandler:^(BOOL finished) {
        [_avPlayer play];
    }];
    
}

//当前播放时间
-(NSTimeInterval)getCurrentTime{
    
    AVPlayerItem *item = _avPlayer.currentItem;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        return CMTimeGetSeconds(_avPlayer.currentItem.currentTime);
    } else {
        return CMTimeGetSeconds(kCMTimeInvalid);
    }
    
}

//取得播放时间
-(NSTimeInterval)getDuration{
    
    AVPlayerItem *item = _avPlayer.currentItem;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        return CMTimeGetSeconds(_avPlayer.currentItem.duration);
    } else {
        return CMTimeGetSeconds(kCMTimeInvalid);
    }
}

//播放
-(void)play{
    
    PLog(@"play...");
    
    if (_avPlayer) {
        [_avPlayer play];
        _isPlaying = YES;
        
        [self timerStart];
    }
    
}

//暂停
-(void)pause{
    
    PLog(@"pause...");
    
    _isPlaying = NO;
    
    [self playerTimerFunction];
    
    if (_avPlayer) {
        [_avPlayer pause];
    }
    [self timerStop];
    
}

-(BOOL)isMusicPlaying{
    
    if (_avPlayer == nil) {
        return NO;
    }
    return _isPlaying;
}

-(void)playerPlayPause{
    
    if (_isPlaying) {
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
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playerTimerFunction) userInfo:nil repeats:YES];
    
}

-(void)playerTimerFunction{
    
    PLog(@"playerTimerFunction...");
    if (_delegate && [_delegate respondsToSelector:@selector(aMusicPlayerTimerFunction)]) {
        [_delegate aMusicPlayerTimerFunction];
    }
    
}

#pragma AVPlayerItemDidPlayToEndTimeNotification

-(void)musicPlayDidEnd:(NSNotification *)notification{
    
    if (_delegate && [_delegate respondsToSelector:@selector(aMusicPlayerStoped)])
    {
        [_delegate aMusicPlayerStoped];
    }
    
}

@end
