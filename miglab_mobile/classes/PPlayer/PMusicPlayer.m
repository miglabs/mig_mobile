//
//  PMusicPlayer.m
//  miglab_mobile
//
//  Created by apple on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PMusicPlayer.h"

@implementation PMusicPlayer

@synthesize avPlayer = _avPlayer;
@synthesize avPlayerItem = _avPlayerItem;
@synthesize audioMix = _audioMix;
@synthesize volumeMixInput = _volumeMixInput;

@synthesize songUrl = _songUrl;
@synthesize playBeginState = _playBeginState;

//初始化
-(BOOL)initPlayer{
    
    NSLog(@"initPlayer...");
    
    _playBeginState = NO;
    
    if (!_songUrl) {
        return NO;
    }
    
    NSURL *tempSongUrl = [NSURL URLWithString:_songUrl];
    AVURLAsset *songAsset = [[AVURLAsset alloc] initWithURL:tempSongUrl options:nil];
    _avPlayerItem = [AVPlayerItem playerItemWithAsset:songAsset];
    [_avPlayerItem addObserver:self forKeyPath:@"status" options:0 context:NULL];
    _avPlayer = [AVPlayer playerWithPlayerItem:_avPlayerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    
    [_avPlayer setAllowsExternalPlayback:YES];
    
    return YES;
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

//取得播放时间
-(NSTimeInterval)playableDuration{
    
    NSLog(@"playableDuration...");
    
    AVPlayerItem *item = _avPlayer.currentItem;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        return CMTimeGetSeconds(_avPlayer.currentItem.duration);
    } else {
        return (CMTimeGetSeconds(kCMTimeInvalid));
    }
    
    return 0;
}

//当前播放时间
-(NSTimeInterval)playableCurrentTime{
    
    NSLog(@"playableDuration...");
    
    AVPlayerItem *item = _avPlayer.currentItem;
    if (item.status == AVPlayerItemStatusReadyToPlay) {
        
        NSLog(@"_avPlayer.currentItem.currentTime: %f", CMTimeGetSeconds(_avPlayer.currentItem.currentTime));
        if (!_playBeginState && CMTimeGetSeconds(item.currentTime) == CMTimeGetSeconds(item.duration)) {
            [_avPlayer pause];
        }
        
        _playBeginState = NO;
        return CMTimeGetSeconds(item.currentTime);
        
    } else {
        return (CMTimeGetSeconds(kCMTimeInvalid));
    }
    
    return 0;
}

@end
