//
//  PPlayerManaerCenter.m
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PPlayerManaerCenter.h"
#import "PAMusicPlayer.h"
#import "PAAMusicPlayer.h"

@implementation PPlayerManaerCenter

@synthesize playerList = _playerList;

static PPlayerManaerCenter *instance;

+(PPlayerManaerCenter *)GetInstance
{
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[PPlayerManaerCenter alloc] init];
        }
    }
    return instance;
}

-(id)init{
    
    self = [super init];
    if (self) {
        _playerList = [[NSMutableArray alloc] init];
        _dicPlayer = [[NSMutableDictionary alloc] init];
    }
    return self;
}

//用于不同页面的多个实例保存
-(void)addObserverPalyer:(id)player{
    [_playerList addObject:player];
}

-(void)removeObserverPlayer:(id)player{
    [_playerList removeObject:player];
}

-(void)stopAllPlayer{
    
    for (id player in _playerList) {
        if (player != nil) {
            if ([player respondsToSelector:@selector(playStopNotification)]) {
                [player performSelector:@selector(playStopNotification)];
            }//if
        }//if
    }//for
    
}

-(void)updateAllPlayer{
    
    for (id player in _playerList) {
        if (player != nil) {
            if ([player respondsToSelector:@selector(playUpdateNotification)]) {
                [player performSelector:@selector(playUpdateNotification)];
            }//if
        }//if
    }//for
    
}

//用于单个实例控制
-(id)getPlayer:(WhichPlayer)whichPlayer{
    
    if (WhichPlayer_AVPlayer == whichPlayer) {
        
        id avPlayer = [_dicPlayer objectForKey:@"WhichPlayer_AVPlayer"];
        if (!avPlayer || ![avPlayer isKindOfClass:[PAMusicPlayer class]]) {
            avPlayer = [[PAMusicPlayer alloc] init];
            [_dicPlayer setValue:avPlayer forKey:@"WhichPlayer_AVPlayer"];
        }
        
        return avPlayer;
        
    } else if (WhichPlayer_AVAudioPlayer == whichPlayer) {
        
        id avAudioPlayer = [_dicPlayer objectForKey:@"WhichPlayer_AVAudioPlayer"];
        if (!avAudioPlayer || ![avAudioPlayer isKindOfClass:[PAAMusicPlayer class]]) {
            avAudioPlayer = [[PAAMusicPlayer alloc] init];
            [_dicPlayer setValue:avAudioPlayer forKey:@"WhichPlayer_AVAudioPlayer"];
        }
        
        return avAudioPlayer;
        
    }
    
    return nil;
}

-(void)removePlayer:(WhichPlayer)whichPlayer{
    
    if (WhichPlayer_AVPlayer == whichPlayer) {
        
        [_dicPlayer removeObjectForKey:@"WhichPlayer_AVPlayer"];
        
    } else if (WhichPlayer_AVAudioPlayer == whichPlayer) {
        
        [_dicPlayer removeObjectForKey:@"WhichPlayer_AVAudioPlayer"];
        
    }
    
}

@end
