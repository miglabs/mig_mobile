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
#import "PAudioStreamerPlayer.h"

typedef enum{
    
    WhichPlayer_AVPlayer = 0,
    WhichPlayer_AVAudioPlayer = 1
    
} WhichPlayer;

@protocol PPlayerManagerCenterDelegate <NSObject>

-(void)DidPlayNext:(Song*)song;
-(void)DidPlayorPause:(Song*)song;

@end

@interface PPlayerManagerCenter : NSObject<PHttpDownloaderDelegate, PMusicPlayerDelegate>

@property (retain) NSMutableArray *playerList;
@property (retain) NSMutableDictionary *dicPlayer;

//正在播放的歌曲信息
@property (retain) NSMutableArray *songList;
@property (assign) int currentSongIndex;
@property (retain) Song *currentSong;
@property BOOL shouldStartPlayAfterDownloaded;

@property BOOL hasAddMoodRecord;
@property (retain) NSString *lastSongId;

@property (retain) id<PPlayerManagerCenterDelegate> delegate;

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
-(void)doUpdateSongList:(NSMutableArray *)tSongList;
-(void)doAddSongList:(NSMutableArray*)tSongList;
-(void)doReplaceSongList:(NSMutableArray*)tSongList;

-(void)addMoodRecordFailed:(NSNotification *)tNotification;
-(void)addMoodRecordSuccess:(NSNotification *)tNotification;

@end
