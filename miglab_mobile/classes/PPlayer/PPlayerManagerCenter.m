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
#import "apidefine.h"
#import "GlobalDataManager.h"

#define SONG_INIT_SIZE 30000


@implementation PPlayerManagerCenter

#define PLAYER_HEADER()

#define PLAYER_FOOTER()

@synthesize playerList = _playerList;
@synthesize dicPlayer = _dicPlayer;

//正在播放的歌曲信息
@synthesize songList = _songList;
@synthesize currentSongIndex = _currentSongIndex;
@synthesize currentSong = _currentSong;
@synthesize shouldStartPlayAfterDownloaded = _shouldStartPlayAfterDownloaded;

@synthesize hasAddMoodRecord = _hasAddMoodRecord;
@synthesize hasGetBarrayComm = _hasGetBarrayComm;
@synthesize lastSongId = _lastSongId;
@synthesize delegate = _delegate;

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
#if USE_NEW_AUDIO_PLAY
        else if (WhichPlayer_AudioStreamerPlayer == whichPlayer) {
            
            id audioStreamerPlayer = [_dicPlayer objectForKey:@"WhichPlayer_AudioStreamerPlayer"];
            
            if (!audioStreamerPlayer || ![audioStreamerPlayer isKindOfClass:[PAudioStreamerPlayer class]]) {
                
                audioStreamerPlayer = [[PAudioStreamerPlayer alloc] init];
                [_dicPlayer setValue:audioStreamerPlayer forKey:@"WhichPlayer_AudioStreamerPlayer"];
            }
            
            return audioStreamerPlayer;
        }
#endif //USE_NEW_AUDIO_PLAY
        
    }
    
    return nil;
}

-(void)removePlayer:(WhichPlayer)whichPlayer{
    
    if (WhichPlayer_AVPlayer == whichPlayer) {
        
        [_dicPlayer removeObjectForKey:@"WhichPlayer_AVPlayer"];
        
    } else if (WhichPlayer_AVAudioPlayer == whichPlayer) {
        
        [_dicPlayer removeObjectForKey:@"WhichPlayer_AVAudioPlayer"];
        
    }
#if USE_NEW_AUDIO_PLAY
    else if (WhichPlayer_AudioStreamerPlayer == whichPlayer) {
        
        [_dicPlayer removeObjectForKey:@"WhichPlayer_AudioStreamerPlayer"];
    }
#endif //USE_NEW_AUDIO_PLAY
}

//---------------------logic
//播放控制
-(void)doPlayOrPause{
    
    PLAYER_HEADER();
    
    PLog(@"doPlayOrPause...");
    
    [self playCurrentSong];
    
    PLAYER_FOOTER();
}

-(void)playCurrentSong{
    
    PLAYER_HEADER();
    
    if ([_songList count] < 1) {
        return;
    }
    
    if (_currentSongIndex >= [_songList count] || _currentSongIndex < 0) {
        return;
    }
    _currentSong = [_songList objectAtIndex:_currentSongIndex];

#if USE_NEW_AUDIO_PLAY
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if ([asMusicPlayer isMusicPlaying]) {
        
        [asMusicPlayer pause];
    }
    else if (asMusicPlayer.playerDestroied) {
        
        [self initSongInfo];
    }
    else {
        
        [asMusicPlayer play];
    }
#else //USE_NEW_AUDIO_PLAY
    [self stopDownload];
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if ([aaMusicPlayer isMusicPlaying]) {
        [aaMusicPlayer pause];
    } else if (aaMusicPlayer.playerDestoried) {
        [self initSongInfo];
    } else {
        [aaMusicPlayer play];
    }
#endif //USE_NEW_AUDIO_PLAY
    
    PLAYER_FOOTER();
}

-(void)doNextWithoutPlaying {
    
    PLAYER_HEADER();
    
    if (_songList && [_songList count] > 0) {
        
        if (([_songList count] > 0) && (_currentSongIndex + 1 >= [_songList count])) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameNeedAddList object:nil userInfo:nil];
        }
        else {
            
            _currentSongIndex = (_currentSongIndex + 1) % [_songList count];
            _currentSong = [_songList objectAtIndex:_currentSongIndex];
            
        }
    }
    
    PLAYER_FOOTER();
}

-(void)doNext{
    
    PLAYER_HEADER();
    
    PLog(@"doNext...");
    
    if (_songList && [_songList count] > 0) {
        
        if (([_songList count] > 0) && (_currentSongIndex + 1 >= [_songList count])) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameNeedAddList object:nil userInfo:nil];
        }
        else {
        
            _currentSongIndex = (_currentSongIndex + 1) % [_songList count];
            _currentSong = [_songList objectAtIndex:_currentSongIndex];
            [GlobalDataManager GetInstance].curSongId = _currentSong.songid;
            
#if USE_NEW_AUDIO_PLAY
            
            PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
            
            if ([asMusicPlayer isMusicPlaying]) {
                
                [asMusicPlayer pause];
            }
#else //USE_NEW_AUDIO_PLAY
            [self stopDownload];
            
            PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
            if ([aaMusicPlayer isMusicPlaying]) {
                [aaMusicPlayer pause];
            }
#endif //USE_NEW_AUDIO_PLAY
            
            [self initSongInfo];
            
            // 更新音乐基因显示内容
            if (self.delegate != nil) {
                
                [self.delegate DidPlayNext:_currentSong];
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerNext object:nil userInfo:nil];
    
    PLAYER_FOOTER();
}

-(void)doInsertPlay:(Song *)tInsertSong{
    
    PLAYER_HEADER();
    
    PLog(@"doInsertPlay...");
    [tInsertSong log];

    if (_currentSongIndex >= [_songList count]) {
        
        return;
    }
    
    _currentSong = [_songList objectAtIndex:_currentSongIndex];
    
    if (_currentSong.songid == tInsertSong.songid) {
        
        [self playCurrentSong];
    
    } else {
        
        //[_songList insertObject:tInsertSong atIndex:0];
        //_currentSongIndex = 0;
        
        [_songList insertObject:tInsertSong atIndex:_currentSongIndex];
        
        _currentSong = tInsertSong;
        
#if USE_NEW_AUDIO_PLAY
        
        PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
        
        if ([asMusicPlayer isMusicPlaying]) {
            
            [asMusicPlayer pause];
        }
#else //USE_NEW_AUDIO_PLAY
        [self stopDownload];
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        if ([aaMusicPlayer isMusicPlaying]) {
            [aaMusicPlayer pause];
        }
#endif //USE_NEW_AUDIO_PLAY
        
        [self initSongInfo];
        
    }
    
    PLAYER_FOOTER();
}

//更新播放列表
-(void)doUpdateSongList:(NSMutableArray *)tSongList{
    
    PLAYER_HEADER();
    
    PLog(@"doUpdateSongList...%d", [tSongList count]);
    
    PPlayerManagerCenter *playerManagerCenter = [PPlayerManagerCenter GetInstance];
    if (playerManagerCenter.songList.count > 0) {
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tSongList.count)];
        [playerManagerCenter.songList insertObjects:tSongList atIndexes:indexs];
    } else {
        [playerManagerCenter.songList addObjectsFromArray:tSongList];
    }
    
    //_currentSongIndex = (_currentSongIndex + 1 > playerManagerCenter.songList.count) ? 0 : (_currentSongIndex + 1);
    playerManagerCenter.currentSongIndex = _currentSongIndex;
    
    PLAYER_FOOTER();
}

-(void)doAddSongList:(NSMutableArray *)tSongList {
    
    PLAYER_HEADER();
    
    PLog(@"doAddSonglist");
    
    PPlayerManagerCenter* playerManagerCenter = [PPlayerManagerCenter GetInstance];
    
    if (playerManagerCenter.songList.count > 0) {
        
        _currentSongIndex += 1;
        playerManagerCenter.currentSongIndex = _currentSongIndex;
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tSongList.count)];
        [playerManagerCenter.songList insertObjects:tSongList atIndexes:indexs];
    } else {
        [playerManagerCenter.songList addObjectsFromArray:tSongList];
    }
    
    PLAYER_FOOTER();
}

-(void)doReplaceSongList:(NSMutableArray *)tSongList {
    
    PLAYER_HEADER();
    
    PLog(@"doReplaceSongList...");
    
    PPlayerManagerCenter* playerManagerCenter = [PPlayerManagerCenter GetInstance];
    
    if ([tSongList count] > 0) {
        
        _currentSongIndex = -1;
        playerManagerCenter.currentSongIndex = _currentSongIndex;
        
        [playerManagerCenter.songList removeAllObjects];
        [playerManagerCenter.songList addObjectsFromArray:tSongList];
    }
    
    PLAYER_FOOTER();
}

-(void)stopDownload{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadPause];
    
    _shouldStartPlayAfterDownloaded = YES;
    
}

-(void)initSongInfo{
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if (asMusicPlayer && [asMusicPlayer isMusicPlaying]) {
        
        return;
    }
    
    // 记录前一首歌的id
    _lastSongId = [NSString stringWithFormat:@"%lld", asMusicPlayer.song.songid];
    asMusicPlayer.song = _currentSong;
    
    BOOL isPlayerInit = [asMusicPlayer initPlayer];
    
    if (isPlayerInit) {
        
        asMusicPlayer.delegate = self;
        [asMusicPlayer play];
        _hasAddMoodRecord = NO;
        
        _hasGetBarrayComm = NO;
        
        NSDictionary *dicPlayerInfo = [NSDictionary dictionaryWithObjectsAndKeys:_currentSong, @"PLAYER_INFO", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerStart object:nil userInfo:dicPlayerInfo];
    }
    else {
        
        [asMusicPlayer playerDestroy];
        _shouldStartPlayAfterDownloaded = YES;
        
        NSDictionary *dicPlayerInfo = [NSDictionary dictionaryWithObjectsAndKeys:_currentSong, @"PLAYER_INFO", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerStop object:nil userInfo:dicPlayerInfo];
    }
    
#else //USE_NEW_AUDIO_PLAY
    [self downloadSong];
#endif //USE_NEW_AUDIO_PLAY
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
        
        _hasGetBarrayComm = NO;
        
        NSDictionary *dicPlayerInfo = [NSDictionary dictionaryWithObjectsAndKeys:_currentSong, @"PLAYER_INFO", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerStart object:nil userInfo:dicPlayerInfo];
        //[SVProgressHUD showSuccessWithStatus:@"开始播放"];
        
    } else {
        
        [aaMusicPlayer playerDestory];
        _shouldStartPlayAfterDownloaded = YES;
        
        NSDictionary *dicPlayerInfo = [NSDictionary dictionaryWithObjectsAndKeys:_currentSong, @"PLAYER_INFO", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNamePlayerStop object:nil userInfo:dicPlayerInfo];
        //[SVProgressHUD showSuccessWithStatus:@"播放器初始化失败:("];
        
    }
    
}

-(void)addMoodRecordFailed:(NSNotification *)tNotification{
    //[SVProgressHUD showErrorWithStatus:@"记录用户心情失败:("];
}

-(void)addMoodRecordSuccess:(NSNotification *)tNotification{
    //[SVProgressHUD showSuccessWithStatus:@"记录用户心情成功:)"];
}

#pragma PHttpDownloaderDelegate

-(void)doDownloadFailed:(NSDictionary *)dicResult{
    
    PLog(@"doDownloadFailed...%@", dicResult);
    
    //检测歌曲下载次数
    NSNumber *downloadcount = [dicResult objectForKey:@"DownloadCount"];
    int nDownloadCount = [downloadcount intValue];
    if (nDownloadCount > 0) {
        
        //[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"nDownloadCount: %d", nDownloadCount]];
        
        [self stopDownload];
        SongDownloadManager *songManager = [SongDownloadManager GetInstance];
        [songManager.downloader setDownloadCount:nDownloadCount-1];
        [songManager downloadStart:_currentSong delegate:self];
        
        return;
    }
    
    NSString *localkey = [dicResult objectForKey:@"LocalKey"];
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager deleteSongInfo:[localkey longLongValue]];
    
    PLog(@"歌曲下载失败:(");
}

-(void)doDownloadProcess:(NSDictionary *)dicProcess{
    
//    PLog(@"downloadProcess: %@", dicProcess);
    
    if (_currentSong.songurl && ![_currentSong.songurl isEqualToString:@""]) {
        
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
    //[SVProgressHUD showErrorWithStatus:@"歌曲下载完成"];
    
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
    
    //PLog(@"aaMusicPlayerTimerFunction...");
     MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if (!_hasAddMoodRecord && asMusicPlayer.getCurrentTime > 10 && [UserSessionManager GetInstance].isLoggedIn) {//大于10s 表明用户对这首歌至少感兴趣
    
#else //USE_NEW_AUDIO_PLAY
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (!_hasAddMoodRecord && aaMusicPlayer.getCurrentTime > 10 && [UserSessionManager GetInstance].isLoggedIn) {
#endif //USE_NEW_AUDIO_PLAY
        
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
        
        [miglabAPI doRecordCurrentSong:userid token:accesstoken lastsong:templastsongid cursong:tempcurrentsongid mode:mode typeid:typeid name:tempcurrentsongname singer:tempcurrentartist state:networkstatus];
        
    }
    //大于5s 表明用户对这首歌不讨厌 可以获取此歌的弹幕
#if USE_NEW_AUDIO_PLAY
    if(!_hasGetBarrayComm && asMusicPlayer.getCurrentTime > BARRAYCOMM_TIME && [UserSessionManager GetInstance].isLoggedIn)
    {
#else //USE_NEW_AUDIO_PLAY
    if (!_hasGetBarrayComm && aaMusicPlayer.getCurrentTime > BARRAYCOMM_TIME && [UserSessionManager GetInstance].isLoggedIn)
    {
#endif //USE_NEW_AUDIO_PLAY
        _hasGetBarrayComm = YES;
        //提交弹幕
        NSString* uid = [UserSessionManager GetInstance].userid;
        NSString* token = [UserSessionManager GetInstance].accesstoken;
        NSString* ttype = [NSString stringWithFormat:@"%@", _currentSong.type];;
        NSString* ttid = [NSString stringWithFormat:@"%d", _currentSong.tid];
        NSString* tmsgid = @"0";//因此版本不需要滚动获取所以暂时不提交MSGID
        NSString* tsongid = (_lastSongId && _lastSongId.length > 0) ? _lastSongId : @"0";;
        [miglabAPI doGetBarrayComm:uid ttoken:token ttype:ttype ttid:ttid tmsgid:tmsgid tsongid:tsongid];
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
