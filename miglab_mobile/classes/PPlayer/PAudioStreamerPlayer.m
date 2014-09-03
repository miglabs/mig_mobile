//
//  PAudioStreamerPlayer.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-9-3.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "PAudioStreamerPlayer.h"

@implementation PAudioStreamerPlayer

@synthesize streamerPlayer = _streamerPlayer;
@synthesize playerTimer = _playerTimer;
@synthesize delegate = _delegate;
@synthesize song = _song;
@synthesize playerDestroied = _playerDestroied;

-(id)init {
    
    self = [super init];
    if (self) {
        
        _playerDestroied = YES;
    }
    
    return self;
}

-(BOOL)initPlayer {
    
    [self playerDestroied];
    
    PLog(@"Init Streamer Player.");
    
    if (!_song || !MIG_NOT_EMPTY_STR(_song.songurl)) {
        
        return NO;
    }
    
    @try {
        
        /*
         0-app中打包的歌曲
         1-手机库中的歌曲
         2-网络下载到手机缓存的歌曲
         3-网络歌曲
         */
        // 目前音乐都是网络音乐，
        // TODO:其他来源音乐，如本地音乐
        if (1) {
            
            NSString *escapedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil, (CFStringRef)_song.songurl, NULL, NULL, kCFStringEncodingUTF8));
            ;
            
            NSURL *url = [NSURL URLWithString:escapedValue];
            
            _streamerPlayer = [[AudioStreamer alloc] initWithURL:url];
            
            if (_streamerPlayer) {
                
                _playerDestroied = NO;
                
            } else {
                
                _playerDestroied = YES;
            }
            
        } else {
            
            _playerDestroied = YES;
        }
    }
    @catch (NSException *exception) {
        
        PLog(@"Streamer Player init failed.");
        _playerDestroied = YES;
    }
    
    return !_playerDestroied;
}

-(void)playerDestroy {
    
    PLog(@"Streamer player destroy.");
    
    if (_streamerPlayer.isPlaying) {
        
        [_streamerPlayer stop];
        _streamerPlayer = nil;
    }
    
    _playerDestroied = YES;
}

-(void)playAtTime:(NSTimeInterval)timeInterval {
    
    if (_streamerPlayer) {
        
        [_streamerPlayer seekToTime:timeInterval];
    }
}

-(void)setSingleLoop {
    
    PLog(@"Set single loop not supported now.");
}

-(void)setSinglePlay {
    
    PLog(@"Set single play not supported now.");
}

-(void)setVolume:(float)volume {
    
    PLog(@"Set volumn not supported now.");
}

-(NSTimeInterval)getCurrentTime {
    
    if (_streamerPlayer) {
        
        return _streamerPlayer.progress;
    }
    
    return 0;
}

-(NSTimeInterval)getDuration {
    
    if (_streamerPlayer) {
        
        return _streamerPlayer.duration;
    }
    
    return 0;
}

-(BOOL)play {
    
    PLog(@"Streamer play.");
    
    if (_streamerPlayer == nil) {
        
        return NO;
    }
    
    [_streamerPlayer start];
    [self timerStart];
    
    return YES;
}

-(void)pause {
    
    PLog(@"Streamer pause.");
    
    [self playerTimerFunction];
    
    if (_streamerPlayer) {
        
        [_streamerPlayer pause];
    }
    
    [self timerStop];
}

-(void)stop {
    
    PLog(@"Streamer stop.");
    
    [self playerTimerFunction];
    
    if (_streamerPlayer) {
        
        [_streamerPlayer stop];
    }
    
    [self timerStop];
}

-(BOOL)isMusicPlaying {
    
    if (_streamerPlayer) {
        
        return _streamerPlayer.isPlaying;
    }
    
    if (_streamerPlayer == nil) {
        
        PLog(@"Streamer is nil.");
    }
    
    return NO;
}

-(void)playerPlayPause {
    
    if (_streamerPlayer) {
        
        if (_streamerPlayer.isPlaying) {
            
            [_streamerPlayer pause];
        }
        else {
            
            [_streamerPlayer start];
        }
    }
}

-(void)timerStop {
    
    @synchronized(self) {
        
        if (_playerTimer) {
            
            if ([_playerTimer isValid]) {
                
                [_playerTimer invalidate];
            }
            
            _playerTimer = nil;
        }
    }
}

-(void)timerStart {
    
    [self timerStop];
    
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:PlayerTimerFunctionInterval target:self selector:@selector(playerTimerFunction) userInfo:nil repeats:YES];
}

-(void)playerTimerFunction {

    // TODO：测试Streamer Player的状态
}

@end
