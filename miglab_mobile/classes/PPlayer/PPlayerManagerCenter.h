//
//  PPlayerManaerCenter.h
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PHttpDownloader.h"
#import "PAAMusicPlayer.h"

typedef enum{
    
    WhichPlayer_AVPlayer = 0,
    WhichPlayer_AVAudioPlayer = 1
    
} WhichPlayer;

@interface PPlayerManagerCenter : NSObject<PHttpDownloaderDelegate, PMusicPlayerDelegate>

@property (nonatomic, retain) NSMutableArray *playerList;
@property (nonatomic, retain) NSMutableDictionary *dicPlayer;

//正在播放的歌曲信息
@property (nonatomic, retain) NSMutableArray *songList;
@property (nonatomic, assign) int currentSongIndex;
@property (nonatomic, retain) Song *currentSong;
@property BOOL shouldStartPlayAfterDownloaded;

@property BOOL hasAddMoodRecord;
@property (nonatomic, retain) NSString *lastSongId;

+(PPlayerManagerCenter *)GetInstance;

//用于不同页面的多个实例保存
-(void)addObserverPalyer:(id)player;
-(void)removeObserverPlayer:(id)player;
-(void)stopAllPlayer;
-(void)updateAllPlayer;

//用于单个实例控制
-(id)getPlayer:(WhichPlayer)whichPlayer;
-(void)removePlayer:(WhichPlayer)whichPlayer;

//播放控制
-(void)doPlayOrPause;
-(void)playCurrentSong;
-(void)doNext;
-(void)doInsertPlay:(Song *)tInsertSong;

-(void)addMoodRecordFailed:(NSNotification *)tNotification;
-(void)addMoodRecordSuccess:(NSNotification *)tNotification;

@end
