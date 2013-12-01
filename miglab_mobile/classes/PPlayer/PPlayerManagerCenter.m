//
//  PPlayerManaerCenter.m
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PPlayerManagerCenter.h"
#import "SongDownloadManager.h"
#import "PDatabaseManager.h"
#import "PAMusicPlayer.h"
#import "PAAMusicPlayer.h"
#import "SVProgressHUD.h"
#import "UserSessionManager.h"

#define SONG_INIT_SIZE 30000


@implementation PPlayerManagerCenter

@synthesize playerList = _playerList;
@synthesize dicPlayer = _dicPlayer;

//正在播放的歌曲信息
@synthesize songList = _songList;
@synthesize currentSongIndex = _currentSongIndex;
@synthesize currentSong = _currentSong;
@synthesize shouldStartPlayAfterDownloaded = _shouldStartPlayAfterDownloaded;

@synthesize hasAddMoodRecord = _hasAddMoodRecord;
@synthesize lastSongId = _lastSongId;

static PPlayerManagerCenter *instance;

+(PPlayerManagerCenter *)GetInstance
{
    @synchronized(self)
    {
        if(!instance)
        {
            instance = [[PPlayerManagerCenter alloc] init];
        }
    }
    return instance;
}

-(id)init{
    
    self = [super init];
    if (self) {
        _playerList = [[NSMutableArray alloc] init];
        _dicPlayer = [[NSMutableDictionary alloc] init];
        //song list
        _songList = [[NSMutableArray alloc] init];
        _currentSongIndex = 0;
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
    
    @synchronized(self) {
        
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

//---------------------logic
//播放控制
-(void)doPlayOrPause{
    
    PLog(@"doPlayOrPause...");
    
    [self playCurrentSong];
    
}

-(void)playCurrentSong{
    
    if ([_songList count] < 1) {
        return;
    }
    
    _currentSong = [_songList objectAtIndex:_currentSongIndex];
    [self stopDownload];
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if ([aaMusicPlayer isMusicPlaying]) {
        [aaMusicPlayer pause];
    } else if (aaMusicPlayer.playerDestoried) {
        [self initSongInfo];
    } else {
        [aaMusicPlayer play];
    }
    
}

-(void)doNext{
    
    PLog(@"doNext...");
    
    if (_songList && [_songList count] > 0) {
        
        if (_currentSongIndex + 1 >= [_songList count]) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameNeedUpdateList object:nil userInfo:nil];
        }
        else {
        
            _currentSongIndex = (_currentSongIndex + 1) % [_songList count];
            _currentSong = [_songList objectAtIndex:_currentSongIndex];
            
            [self stopDownload];
            
            PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
            if ([aaMusicPlayer isMusicPlaying]) {
                [aaMusicPlayer pause];
            }
            
            [self initSongInfo];
        }
    }
    
}

-(void)doInsertPlay:(Song *)tInsertSong{
    
    PLog(@"doInsertPlay...");
    [tInsertSong log];
    
    _currentSong = [_songList objectAtIndex:_currentSongIndex];
    
    if (_currentSong.songid == tInsertSong.songid) {
        
        [self playCurrentSong];
    
    } else {
        
        [_songList insertObject:tInsertSong atIndex:0];
        _currentSongIndex = 0;
        _currentSong = tInsertSong;
        
        [self stopDownload];
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        if ([aaMusicPlayer isMusicPlaying]) {
            [aaMusicPlayer pause];
        }
        
        [self initSongInfo];
        
    }
    
}

//更新播放列表
-(void)doUpdateSongList:(NSMutableArray *)tSongList{
    
    PLog(@"doUpdateSongList...%d", [tSongList count]);
    
    PPlayerManagerCenter *playerManagerCenter = [PPlayerManagerCenter GetInstance];
    if (playerManagerCenter.songList.count > 0) {
        playerManagerCenter.currentSongIndex = 0;
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tSongList.count)];
        [playerManagerCenter.songList insertObjects:tSongList atIndexes:indexs];
    } else {
        [playerManagerCenter.songList addObjectsFromArray:tSongList];
    }
    
}

-(void)stopDownload{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadPause];
    
    _shouldStartPlayAfterDownloaded = YES;
    
}

-(void)initSongInfo{
    
    [self downloadSong];
    
}

-(void)downloadSong{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    float rate = [songManager getSongProgress:_currentSong];
    if (rate >= 1) {
        
        [self initAndStartPlayer];
        
    } else {
        
        [songManager.downloader setDownloadCount:3];
        [songManager downloadStart:_currentSong delegate:self];
        
    }
    
}

-(void)initAndStartPlayer{
    
    PLog(@"initAndStartPlayer...");
    
    if (!_currentSong || !_currentSong.songCachePath) {
        PLog(@"_currentSong.songCachePath is nil...");
        return;
    }
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (aaMusicPlayer && [aaMusicPlayer isMusicPlaying]) {
        return;
    }
    
    //记录前一首歌id
    _lastSongId = [NSString stringWithFormat:@"%lld", aaMusicPlayer.song.songid];
    aaMusicPlayer.song = _currentSong;
    
    BOOL isPlayerInit = [aaMusicPlayer initPlayer];
    if (isPlayerInit) {
        aaMusicPlayer.delegate = self;
        [aaMusicPlayer play];
        _hasAddMoodRecord = NO;
        
        NSDictionary *dicPlayerInfo = [NSDictionary dictionaryWithObjectsAndKeys:_currentSong, @"PLAYER_INFO", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerStart object:nil userInfo:dicPlayerInfo];
        [SVProgressHUD showSuccessWithStatus:@"开始播放"];
        
    } else {
        
        [aaMusicPlayer playerDestory];
        _shouldStartPlayAfterDownloaded = YES;
        
        NSDictionary *dicPlayerInfo = [NSDictionary dictionaryWithObjectsAndKeys:_currentSong, @"PLAYER_INFO", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerStop object:nil userInfo:dicPlayerInfo];
        [SVProgressHUD showSuccessWithStatus:@"播放器初始化失败:("];
        
    }
    
}

-(void)addMoodRecordFailed:(NSNotification *)tNotification{
    [SVProgressHUD showErrorWithStatus:@"记录用户心情失败:("];
}

-(void)addMoodRecordSuccess:(NSNotification *)tNotification{
    [SVProgressHUD showSuccessWithStatus:@"记录用户心情成功:)"];
}

#pragma PHttpDownloaderDelegate

-(void)doDownloadFailed:(NSDictionary *)dicResult{
    
    PLog(@"doDownloadFailed...%@", dicResult);
    
    //检测歌曲下载次数
    NSNumber *downloadcount = [dicResult objectForKey:@"DownloadCount"];
    int nDownloadCount = [downloadcount intValue];
    if (nDownloadCount > 0) {
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"nDownloadCount: %d", nDownloadCount]];
        
        [self stopDownload];
        SongDownloadManager *songManager = [SongDownloadManager GetInstance];
        [songManager.downloader setDownloadCount:nDownloadCount-1];
        [songManager downloadStart:_currentSong delegate:self];
        
        return;
    }
    
    NSString *localkey = [dicResult objectForKey:@"LocalKey"];
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager deleteSongInfo:[localkey longLongValue]];
    
    [SVProgressHUD showErrorWithStatus:@"歌曲下载失败:("];
}

-(void)doDownloadProcess:(NSDictionary *)dicProcess{
    
//    PLog(@"downloadProcess: %@", dicProcess);
    
    if (_currentSong.songurl) {
        
        NSString *songext = [NSString stringWithFormat:@"%@", [_currentSong.songurl lastPathComponent]];
        NSRange range = [songext rangeOfString:@"."];
        songext = [songext substringFromIndex:range.location + 1];
        
        PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
        long long tempfilesize = [databaseManager getSongMaxSize:_currentSong.songid type:songext];
        if (tempfilesize <= 0) {
            
            long long totalBytesExpectedToRead = [[dicProcess objectForKey:@"TotalBytesExpectedToRead"] longLongValue];
            [databaseManager setSongMaxSize:_currentSong.songid type:songext fileMaxSize:totalBytesExpectedToRead];
            
        }
        
        //
        SongDownloadManager *songManager = [SongDownloadManager GetInstance];
        long long localsize = [songManager getSongLocalSize:_currentSong];
        if (localsize < SONG_INIT_SIZE) {
            //
            
        } else {
            
            PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
            if (![aaMusicPlayer isMusicPlaying] && _shouldStartPlayAfterDownloaded) {
                _shouldStartPlayAfterDownloaded = NO;
                [self initAndStartPlayer];
            }
            
            
        }
        
    }
    
}

-(void)doDownloadSuccess:(NSDictionary *)dicResult{
    
    PLog(@"doDownloadSuccess...%@", dicResult);
    [SVProgressHUD showErrorWithStatus:@"歌曲下载完成"];
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (![aaMusicPlayer isMusicPlaying] && _shouldStartPlayAfterDownloaded) {
        _shouldStartPlayAfterDownloaded = NO;
        [self initAndStartPlayer];
    }
    
}

#pragma PHttpDownloaderDelegate end

#pragma PMusicPlayerDelegate
//PAAMusicPlayer
-(void)aaMusicPlayerTimerFunction{
    
    //
//    PLog(@"aaMusicPlayerTimerFunction...");
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (!_hasAddMoodRecord && aaMusicPlayer.getCurrentTime > 10 && [UserSessionManager GetInstance].isLoggedIn) {
        
        _hasAddMoodRecord = YES;
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *templastsongid = (_lastSongId && _lastSongId.length > 0) ? _lastSongId : @"0";
        NSString *tempcurrentsongid = [NSString stringWithFormat:@"%lld", _currentSong.songid];
        NSString *mode  = [NSString stringWithFormat:@"%@", _currentSong.type];
        NSString *typeid = [NSString stringWithFormat:@"%d", _currentSong.tid];
        NSString *tempcurrentsongname = _currentSong.songname;
        NSString *tempcurrentartist = _currentSong.artist;
        NSString *networkstatus = [NSString stringWithFormat:@"%d", [UserSessionManager GetInstance].networkStatus];
        
        MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
        [miglabAPI doRecordCurrentSong:userid token:accesstoken lastsong:templastsongid cursong:tempcurrentsongid mode:mode typeid:typeid name:tempcurrentsongname singer:tempcurrentartist state:networkstatus];
        
    }
    
}

-(void)aaMusicPlayerStoped{
    
    PLog(@"aaMusicPlayerStoped...");
    [self doNext];
    
}

//PAMusicPlayer
-(void)aMusicPlayerTimerFunction{
    
    //
    PLog(@"aMusicPlayerTimerFunction...");
    
}

-(void)aMusicPlayerStoped{
    
    PLog(@"aMusicPlayerStoped...");
    [self doNext];
    
}

#pragma PMusicPlayerDelegate end

@end
