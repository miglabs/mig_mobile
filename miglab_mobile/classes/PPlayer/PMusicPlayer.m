//
//  PMusicPlayer.m
//  miglab_mobile
//
//  Created by apple on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PMusicPlayer.h"
#import "UIImage+PImageCategory.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation PMusicPlayer

@synthesize avPlayer = _avPlayer;
@synthesize avPlayerItem = _avPlayerItem;
@synthesize audioMix = _audioMix;
@synthesize volumeMixInput = _volumeMixInput;

@synthesize avAudioPlayer = _avAudioPlayer;

@synthesize playerTimer = _playerTimer;

@synthesize song = _song;
@synthesize playerState = _playerState;

/*
 先取消，后初始化
 */
-(BOOL)initPlayer{
    
    //先取消
    [self playerDestory];
    
    PLog(@"initPlayer...");
    
    if (!_song || !_song.songUrl) {
        return NO;
    }
    
    @try {
        
        /*
         0-app中打包的歌曲
         1-手机库中的歌曲
         2-网络下载到手机缓存的歌曲
         3-网络歌曲
         */
        if (_song.whereIsTheSong == 0 || _song.whereIsTheSong == 2) {
            
            NSURL *url = [NSURL URLWithString:_song.songUrl];
            _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            
        } else if (_song.whereIsTheSong == 1 || _song.whereIsTheSong == 3) {
            
            NSURL *url = [NSURL URLWithString:_song.songUrl];
            AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
            _avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
            
            //添加播放完成的notifation
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(musicPlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
            
        }
        
    }
    @catch (NSException *exception) {
        PLog(@"PMusicPlayer initPlayer failed...");
    }
    
    
    NSURL *tempSongUrl = [NSURL URLWithString:_song.songUrl];
    AVURLAsset *songAsset = [[AVURLAsset alloc] initWithURL:tempSongUrl options:nil];
    _avPlayerItem = [AVPlayerItem playerItemWithAsset:songAsset];
    [_avPlayerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
    _avPlayer = [AVPlayer playerWithPlayerItem:_avPlayerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    
    [_avPlayer setAllowsExternalPlayback:YES];
    
    return YES;
}

-(void)playerDestory{
    
    PLog(@"playerDestory...");
    if (_avPlayer) {
        [_avPlayer pause];
        _avPlayer = nil;
    }
    
    if (_avAudioPlayer) {
        [_avAudioPlayer stop];
        _avAudioPlayer = nil;
    }
    
    _playerState = NO;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        if (AVPlayerItemStatusReadyToPlay == _avPlayer.currentItem.status) {
            [_avPlayer play];
        }
    }
    
}

//播放
-(void)play{
    
    NSLog(@"play...");
    
}

//暂停
-(void)pause{
    
    NSLog(@"pause...");
    
    if (_avPlayer) {
        [_avPlayer pause];
    }
    
}

//停止
-(void)stop{
    
    NSLog(@"stop...");
    
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
    
}

//音量调整
-(void)setVolume:(float)volume{
    
    NSLog(@"setVolume: %f", volume);
    
    NSMutableArray *allAudioParams = [NSMutableArray array];
    
    AVMutableAudioMixInputParameters *audioInputParams = [AVMutableAudioMixInputParameters audioMixInputParameters];
    [audioInputParams setVolume:volume atTime:kCMTimeZero];
    [audioInputParams setTrackID:1];
    
    [allAudioParams addObject:audioInputParams];
    
    _audioMix = [AVMutableAudioMix audioMix];
    [_audioMix setInputParameters:allAudioParams];
    
    [_avPlayerItem setAudioMix:_audioMix];//mute the player item
    
//    [_avPlayer ]
}

//设置锁屏状态，显示的歌曲信息
-(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:@"name" forKey:MPMediaItemPropertyTitle];
        [dict setObject:@"singer" forKey:MPMediaItemPropertyArtist];
        [dict setObject:@"album" forKey:MPMediaItemPropertyAlbumTitle];
        
        UIImage *image = [UIImage imageWithName:@"fs00" type:@"png"];
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}

@end
