//
//  PPlayerManaerCenter.h
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    WhichPlayer_AVPlayer = 0,
    WhichPlayer_AVAudioPlayer = 1
    
} WhichPlayer;

@interface PPlayerManaerCenter : NSObject

@property (nonatomic, retain) NSMutableArray *playerList;
@property (nonatomic, retain) NSMutableDictionary *dicPlayer;

+(PPlayerManaerCenter *)GetInstance;

//用于不同页面的多个实例保存
-(void)addObserverPalyer:(id)player;
-(void)removeObserverPlayer:(id)player;
-(void)stopAllPlayer;
-(void)updateAllPlayer;

//用于单个实例控制
-(id)getPlayer:(WhichPlayer)whichPlayer;
-(void)removePlayer:(WhichPlayer)whichPlayer;

@end
