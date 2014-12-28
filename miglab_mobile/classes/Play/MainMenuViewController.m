//
//  MainMenuViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PCommonUtil.h"
#import "SongDownloadManager.h"
#import "PDatabaseManager.h"
#import "UserSessionManager.h"
#import "SVProgressHUD.h"
#import "Channel.h"

#import "PPlayerManagerCenter.h"
#import <MediaPlayer/MediaPlayer.h>


#define SONG_INIT_SIZE 30000
#define ROTATE_ANGLE 0.01//0.026526

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

//播放页面
@synthesize playView = _playView;
@synthesize backgroundEGOImageView = _backgroundEGOImageView;
@synthesize topPlayerInfoView = _topPlayerInfoView;
@synthesize lblSongInfo = _lblSongInfo;
@synthesize showInfoPageControl = _showInfoPageControl;
@synthesize songInfoScrollView = _songInfoScrollView;
@synthesize cdOfSongView = _cdOfSongView;
@synthesize bottomPlayerMenuView = _bottomPlayerMenuView;

@synthesize cdEGOImageView = _cdEGOImageView;

@synthesize playerTimer = _playerTimer;
@synthesize checkUpdatePlayProcess = _checkUpdatePlayProcess;

//歌曲场景切换页面
@synthesize playerBoradView = _playerBoradView;

@synthesize isPlayViewShowing = _isPlayViewShowing;

@synthesize songList = _songList;
@synthesize currentSongIndex = _currentSongIndex;
@synthesize currentSong = _currentSong;
@synthesize shouldStartPlayAfterDownloaded = _shouldStartPlayAfterDownloaded;
@synthesize hasAddMoodRecord = _hasAddMoodRecord;

@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPlayViewShowing = NO;
        _checkUpdatePlayProcess = 0;
        
        //doGetGuestInfo
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuestInfoFailed:) name:NotificationNameGetGuestFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuestInfoSuccess:) name:NotificationNameGetGuestSuccess object:nil];
        
        //login
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
        
        //user
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
        
        //getChannel
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelFailed:) name:NotificationNameGetChannelFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getChannelSuccess:) name:NotificationNameGetChannelSuccess object:nil];
        
        //getMusicFromChannel
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMusicFromChannelFailed:) name:NotificationNameGetChannelMusicFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMusicFromChannelSuccess:) name:NotificationNameGetChannelMusicSuccess object:nil];
        
        //getModeMusic
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getModeMusicFailed:) name:NotificationNameModeMusicFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getModeMusicSuccess:) name:NotificationNameModeMusicSuccess object:nil];
        
        //doAddBlacklist
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBlacklistFailed:) name:NotificationNameHateSongFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBlacklistSuccess:) name:NotificationNameHateSongSuccess object:nil];
        
        //doCollectSong
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongFailed:) name:NotificationNameCollectSongFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongSuccess:) name:NotificationNameCollectSongSuccess object:nil];
        
        //doAddMoodRecord
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMoodRecordFailed:) name:NotificationNameAddMoodRecordFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addMoodRecordSuccess:) name:NotificationNameAddMoodRecordSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    //doGetGuestInfo
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetGuestFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetGuestSuccess object:nil];
    
    //login
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameLoginSuccess object:nil];
    
    //user
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetUserInfoSuccess object:nil];
    
    //getChannel
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetChannelFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetChannelSuccess object:nil];
    
    //getMusicFromChannel
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetChannelMusicFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetChannelMusicSuccess object:nil];
    
    //getModeMusic
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameModeMusicFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameModeMusicSuccess object:nil];
    
    //doAddBlacklist
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongSuccess object:nil];
    
    //doAddMoodRecord
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameAddMoodRecordFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameAddMoodRecordSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FRAMELOG(self.view);
    
    //screen height
    PLog(@"kMainScreenHeight: %f", kMainScreenHeight);
    
    
    //构造场景选择页面
    [self initMenuView];
    
    //end 场景
    
    //构造播放页面
    [self initPlayView];
    
    //end 播放
    
    UIImage *defaultCover = [UIImage imageWithName:@"song_cover" type:@"png"];
    defaultCover = [UIImage createRoundedRectImage:defaultCover size:CGSizeMake(200, 200) radius:100];
    _cdEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultCover];
//    _cdEGOImageView.frame = CGRectMake(9, kMainScreenHeight - 50, 44, 44);
    _cdEGOImageView.frame = CGRectMake(62, 119, 196, 196);
    _cdEGOImageView.layer.cornerRadius = 98;
    _cdEGOImageView.layer.masksToBounds = YES;
    _cdEGOImageView.hidden = YES;
    [self.view addSubview:_cdEGOImageView];
    
    //download
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:NotificationNameDownloadFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProcess:) name:NotificationNameDownloadProcess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:NotificationNameDownloadSuccess object:nil];
    
    //song list
    _songList = [[NSMutableArray alloc] init];
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
    //登录，获取用户资料
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
        
        //根据描述词获取歌曲 test
        //随机心情词id
        int rnd = (rand() % 6) + 1;
        NSString *tempwordid = [NSString stringWithFormat:@"%d", rnd];
        [_miglabAPI doGetModeMusic:userid token:accesstoken wordid:tempwordid mood:@"mm"];
        
    } else {
        
        [self initUserData];
        
    }
    
    
    
    //test data
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
    [_songList addObjectsFromArray:tempSongInfoList];
    
    PLog(@"rand(): %d, random(): %ld", rand(), random());
    int songListCount = [_songList count];
    int rnd = rand() % songListCount;
    _currentSongIndex = rnd;
    _currentSong = (_songList.count > 0) ? [_songList objectAtIndex:_currentSongIndex] : nil;
    
}

#pragma for player remote control 
//add by zhuruhong 20130728
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause...");
                
                //[[PPlayerManagerCenter GetInstance] doPlayOrPause];
                break;
            }
            case UIEventSubtypeRemoteControlPlay:
            {
                NSLog(@"UIEventSubtypeRemoteControlPlay...");
                //[[PPlayerManagerCenter GetInstance]doPlayOrPause];
                [self doPlayOrPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlPause...");
                //[[PPlayerManagerCenter GetInstance] doPlayOrPause];
                [self doPlayOrPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlStop:
            {
                NSLog(@"UIEventSubtypeRemoteControlStop...");
                break;
            }
            case UIEventSubtypeRemoteControlNextTrack:
            {
                NSLog(@"UIEventSubtypeRemoteControlNextTrack...");
                //[[PPlayerManagerCenter GetInstance] doNext];
                [self doNextAction:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPreviousTrack:
            {
                NSLog(@"UIEventSubtypeRemoteControlPreviousTrack...");
                break;
            }
            default:
                break;
        }
    }
    
}

//Make sure we can recieve remote control events
- (BOOL)canBecomeFirstResponder{
    return YES;
}

//摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
    if (motion == UIEventSubtypeMotionShake) {
        PLog(@"Shake...");
        
        //摇一摇，下一首
        [self doNextAction:nil];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //摇一摇
    [self becomeFirstResponder];
    
#if USE_NEW_AUDIO_PLAY
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if ([asMusicPlayer isMusicPlaying]) {
        
        _currentSong = asMusicPlayer.song;
        
#else //USE_NEW_AUDIO_PLAY
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if ([aaMusicPlayer isMusicPlaying]) {
        
        _currentSong = aaMusicPlayer.song;
        
#endif //USE_NEW_AUDIO_PLAY
        
        [self timerStart];
    } else {
        [self timerStop];
    }
    
    //现在当前歌曲信息
    if (_currentSong) {
        
        _lblSongInfo.text = [NSString stringWithFormat:@"%@ - %@", _currentSong.songname, _currentSong.artist];
        _playerBoradView.lblSongName.text = _currentSong.songname;
        _playerBoradView.lblArtist.text = _currentSong.artist;
        NSURL *tempCoverUrl = [NSURL URLWithString:_currentSong.coverurl];
        _cdOfSongView.coverOfSongEGOImageView.imageURL = tempCoverUrl;
        _cdEGOImageView.imageURL = tempCoverUrl;
        _playerBoradView.btnAvatar.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_MUSIC_IMAGE];
        _playerBoradView.btnAvatar.imageURL = tempCoverUrl;
        
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    //摇一摇
    [self resignFirstResponder];
    
    [super viewWillDisappear:animated];
    
    [self timerStop];
    
}

/*
 把播放器的定时器移动页面来
 
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
-(void)timerStop{
    
    @synchronized(self){
        if (_playerTimer) {
            if ([_playerTimer isValid]) {
                [_playerTimer invalidate];
            }
            _playerTimer = nil;
        }
    }
    
    UIImage *playNorImage = [UIImage imageWithName:@"borad_menu_play_nor" type:@"png"];
    UIImage *playSelImage = [UIImage imageWithName:@"borad_menu_play_sel" type:@"png"];
    [_playerBoradView.btnPlayOrPause setImage:playNorImage forState:UIControlStateNormal];
    [_playerBoradView.btnPlayOrPause setImage:playSelImage forState:UIControlStateHighlighted];
    
}

-(void)timerStart{
    
    [self timerStop];
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(playerTimerFunction) userInfo:nil repeats:YES];
    
    UIImage *pauseNorImage = [UIImage imageWithName:@"borad_menu_stop_nor" type:@"png"];
    UIImage *pauseSelImage = [UIImage imageWithName:@"borad_menu_stop_sel" type:@"png"];
    [_playerBoradView.btnPlayOrPause setImage:pauseNorImage forState:UIControlStateNormal];
    [_playerBoradView.btnPlayOrPause setImage:pauseSelImage forState:UIControlStateHighlighted];
    //设置锁屏显示
    [self configNowPlayingInfoCenter];
    
}

-(void)playerTimerFunction{
    
    PLog(@"playerTimerFunction...");
    [self performSelectorOnMainThread:@selector(doUpdateForPlaying) withObject:nil waitUntilDone:NO];
    
}

#pragma AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //播放下一首
    [self doNextAction:nil];
    
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    //change ui
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    if (player) [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    if (player) [player play];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (player) [player play];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma AVAudioPlayerDelegate end

-(void)initMenuView{
    
    //bottom
    _playerBoradView = [[PCustomPlayerBoradView alloc] initPlayerBoradView:CGRectMake(0, kMainScreenHeight - 60, kMainScreenWidth, 60)];
    [_playerBoradView.btnAvatar addTarget:self action:@selector(doAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerBoradView];
    
    
}

-(IBAction)doAvatarAction:(id)sender{
    
    //逆时针旋转
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnim.fromValue = [NSNumber numberWithFloat:0];
    transformAnim.toValue = [NSNumber numberWithFloat:2 * M_PI];
    transformAnim.duration = 0.3;
    transformAnim.autoreverses = NO;
    transformAnim.repeatCount = 2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:transformAnim, nil];
    animGroup.duration = 6;
    _cdEGOImageView.hidden = NO;
    [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
    
    //移动位置
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        _cdEGOImageView.frame = CGRectMake(62, 119, 196, 196);
        
    } completion:^(BOOL finished) {
        
        _cdEGOImageView.hidden = YES;
        _cdOfSongView.coverOfSongEGOImageView.hidden = NO;
        
    }];
    
}

-(IBAction)doRemoveAction:(id)sender{
    
    PLog(@"doRemoveAction...");
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    [_miglabAPI doHateSong:userid token:accesstoken sid:_currentSong.songid];
    
}

-(IBAction)doLikeAction:(id)sender{
    
    PLog(@"doLikeAction...");
    
//    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
//   NSString *userid = [UserSessionManager GetInstance].userid;
//    [_miglabAPI doCollectSong:accesstoken uid:userid songid:_currentSong.songid];
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    [self playCurrentSong];
    
}

-(void)playCurrentSong{
    
    _currentSong = [_songList objectAtIndex:_currentSongIndex];
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if ([asMusicPlayer isMusicPlaying]) {
        
        [asMusicPlayer pause];
        [self timerStop];
    }
    else if (asMusicPlayer.playerDestroied) {
        
        [self initSongInfo];
    }
    else {
        
        [asMusicPlayer play];
        [self timerStart];
    }
    
#else //USE_NEW_AUDIO_PLAY
    
    [self stopDownload];
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if ([aaMusicPlayer isMusicPlaying]) {
        [aaMusicPlayer pause];
        [self timerStop];
    } else if (aaMusicPlayer.playerDestoried) {
        [self initSongInfo];
    } else {
        [aaMusicPlayer play];
        [self timerStart];
    }
    
#endif //USE_NEW_AUDIO_PLAY
}

-(IBAction)doNextAction:(id)sender{
    
    PLog(@"doNextAction...");
    
    if (_songList && [_songList count] > 0) {
        
        _currentSongIndex = (_currentSongIndex + 1) % [_songList count];
        _currentSong = [_songList objectAtIndex:_currentSongIndex];
        
        [self stopDownload];
        
#if USE_NEW_AUDIO_PLAY
        
        PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
        
        if ([asMusicPlayer isMusicPlaying]) {
            
            [asMusicPlayer pause];
        }
        
#else //USE_NEW_AUDIO_PLAY
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        if ([aaMusicPlayer isMusicPlaying]) {
            [aaMusicPlayer pause];
        }
        
#endif //USE_NEW_AUDIO_PLAY
        
        [self timerStop];
        
        [self initSongInfo];
        
    }
    
}

-(void)playLocationSong{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"qhc" ofType:@"caf"];
    BOOL fileexit = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileexit) {
        
        Song *tempSong = [[Song alloc] init];
        tempSong.songurl = filepath;
        tempSong.whereIsTheSong = WhereIsTheSong_IN_APP;
        
#if USE_NEW_AUDIO_PLAY
        
        // TODO: 此处是播放本地音乐，可能不能使用AudioStreamerPlayer，但是目前不需要播放本地音乐
        PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
        
        if (asMusicPlayer.playerDestroied) {
            
            asMusicPlayer.song = tempSong;
            
            BOOL isPlayerInit = [asMusicPlayer initPlayer];
            
            if (isPlayerInit) {
                
                asMusicPlayer.delegate = self;
                [asMusicPlayer play];
            }
        }
        else {
            
            [asMusicPlayer playerPlayPause];
        }
        
#else //USE_NEW_AUDIO_PLAY
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        
        if (aaMusicPlayer.playerDestoried) {
            
            aaMusicPlayer.song = tempSong;
            
            BOOL isPlayerInit = [aaMusicPlayer initPlayer];
            if (isPlayerInit) {
                aaMusicPlayer.delegate = self;
                [aaMusicPlayer play];
            }
            
        } else {
            
            [aaMusicPlayer playerPlayPause];
            
        }
#endif //USE_NEW_AUDIO_PLAY
    }
    
}

//构造播放页面
-(void)initPlayView{
    
    //screen height
    PLog(@"kMainScreenHeight: %f", kMainScreenHeight);
    
    //构造播放页面
    _playView = [[UIView alloc] init];
    _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    
    //background view
    UIImage *defaultBackgroundImage = [UIImage imageWithName:@"bg_mask_2" type:@"png"];
    _backgroundEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultBackgroundImage];
    _backgroundEGOImageView.frame = CGRectMake(0, -20, kMainScreenWidth, kMainScreenHeight + 20);
    [_playView addSubview:_backgroundEGOImageView];
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, -20, kMainScreenWidth, 44)];
    [_topPlayerInfoView.btnMenu addTarget:self action:@selector(doShowMenuViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPlayerInfoView.btnShare addTarget:self action:@selector(doShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_topPlayerInfoView];
    
    //song info label
    _lblSongInfo = [[UILabel alloc] init];
    _lblSongInfo.frame = CGRectMake(0, 60, kMainScreenWidth, 21);
    _lblSongInfo.backgroundColor = [UIColor clearColor];
    _lblSongInfo.textAlignment = kTextAlignmentCenter;
    _lblSongInfo.textColor = [UIColor whiteColor];
    _lblSongInfo.shadowOffset = CGSizeMake(0, 1);
    _lblSongInfo.text = @"咪哟努力加载";
    [_playView addSubview:_lblSongInfo];
    
    //song of page
    _showInfoPageControl = [[PCustomPageControl alloc] init];
    _showInfoPageControl.backgroundColor = [UIColor clearColor];
    _showInfoPageControl.frame = CGRectMake(0, 90, kMainScreenWidth, 15);
    _showInfoPageControl.numberOfPages = 2;
    _showInfoPageControl.currentPage = 0;
    _showInfoPageControl.imagePageStateNormal = [UIImage imageWithName:@"page_nor" type:@"png"];
    _showInfoPageControl.imagePageStateHighlighted = [UIImage imageWithName:@"page_sel" type:@"png"];
    [_playView addSubview:_showInfoPageControl];
    
    //song info
    _songInfoScrollView = [[UIScrollView alloc] init];
    _songInfoScrollView.backgroundColor = [UIColor clearColor];
    _songInfoScrollView.frame = CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight - 100 - 90);
    _songInfoScrollView.scrollEnabled = YES;
    _songInfoScrollView.showsHorizontalScrollIndicator = NO;
    _songInfoScrollView.pagingEnabled = YES;
    _songInfoScrollView.delegate = self;
    _songInfoScrollView.contentSize = CGSizeMake(kMainScreenWidth * 2, kMainScreenHeight - 100 - 90);
    
    //song of cd view
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayBodyView" owner:self options:nil];
    for (id oneObject in nib){
        if ([oneObject isKindOfClass:[PlayBodyView class]]){
            _cdOfSongView = (PlayBodyView *)oneObject;
        }//if
    }//for
    _cdOfSongView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 100 - 90);
    
    _cdOfSongView.coverOfSongEGOImageView.tag = 2000;
    _cdOfSongView.coverOfSongEGOImageView.delegate = self;
    _cdOfSongView.coverOfSongEGOImageView.layer.cornerRadius = 98;
    _cdOfSongView.coverOfSongEGOImageView.layer.masksToBounds = YES;
    
    _cdOfSongView.btnCdOfSong.layer.cornerRadius = 98;
    _cdOfSongView.btnCdOfSong.layer.masksToBounds = YES;
    _cdOfSongView.btnCdOfSong.adjustsImageWhenHighlighted = NO;
    [_cdOfSongView.btnCdOfSong addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化进度指示
    [_cdOfSongView updateProcess:0.01];
    
    [_songInfoScrollView addSubview:_cdOfSongView];
    
    [_playView addSubview:_songInfoScrollView];
    
    //bottom
    _bottomPlayerMenuView = [[PCustomPlayerMenuView alloc] initPlayerMenuView:CGRectMake(0, kMainScreenHeight - 90, kMainScreenWidth, 90)];
    [_bottomPlayerMenuView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_bottomPlayerMenuView];
    
    //add view
    [self.view addSubview:_playView];
    
    //end 构造播放页面
    
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//    [_playView addGestureRecognizer:panGestureRecognizer];
    
    
}

-(IBAction)doShowMenuViewAction:(id)sender{
    
    PLog(@"doShowMenuViewAction...");
    
    //逆时针旋转
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnim.fromValue = [NSNumber numberWithFloat:2 * M_PI];
    transformAnim.toValue = [NSNumber numberWithFloat:0];
    transformAnim.duration = 0.3;
    transformAnim.autoreverses = NO;
    transformAnim.repeatCount = 2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:transformAnim, nil];
    animGroup.duration = 6;
    _cdEGOImageView.hidden = NO;
    _cdOfSongView.coverOfSongEGOImageView.hidden = YES;
    [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
    
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _playView.frame = CGRectMake(320, 0, kMainScreenWidth, kMainScreenHeight);
        _cdEGOImageView.frame = CGRectMake(9, kMainScreenHeight - 50, 44, 44);
        
    } completion:^(BOOL finished) {
        
        _cdEGOImageView.hidden = YES;
        
    }];
    
}

-(IBAction)doShareAction:(id)sender{
    
    PLog(@"doShareAction...");
    
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_playView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
    
    NSLog(@"recognizer.view.center.x: %f, recognizer.view.center.y: %f", recognizer.view.center.x, recognizer.view.center.y);
    
    [recognizer setTranslation:CGPointZero inView:_playView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            
            if (recognizer.view.frame.origin.x > 50) {
                
                [self doShowMenuViewAction:nil];
                //                _playView.frame = CGRectMake(320, 0, kMainScreenWidth, kMainScreenHeight);
                
            } else {
                
                _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
                
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //
        
    }
    
}

-(IBAction)doShowPlayViewAction:(id)sender{
    
//    float height = [UIScreen mainScreen].bounds.size.height;
    
    /*
     CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
     CGMutablePathRef aPath = CGPathCreateMutable();
     CGPathMoveToPoint(aPath, nil, 9, height - 20 - 50);
     CGPathAddQuadCurveToPoint(aPath, nil, 30, 100, 62, 119);
     animation.path = aPath;
     animation.duration = 0.7;
     */
    
    //    //路径曲线
    //    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    CGMutablePathRef aPath = CGPathCreateMutable();
    //    CGPathMoveToPoint(aPath, nil, 9, height - 20 - 50);
    //    CGPathAddQuadCurveToPoint(aPath, nil, 60, 100, 62, 119);
    //    moveAnim.path = aPath;
    //    moveAnim.duration = 0.6;
    //    moveAnim.removedOnCompletion = YES;
    
    //    [_cdEGOImageView.layer addAnimation:moveAnim forKey:@"position"];
    
    /*
     CGPoint fromPoint = _cdEGOImageView.center;
     
     //路径曲线
     UIBezierPath *movePath = [UIBezierPath bezierPath];
     [movePath moveToPoint:fromPoint];
     CGPoint toPoint = CGPointMake(62, 119);
     [movePath addQuadCurveToPoint:toPoint
     controlPoint:CGPointMake(100, 0)];
     //关键帧
     CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     moveAnim.path = movePath.CGPath;
     moveAnim.duration = 0.6;
     moveAnim.removedOnCompletion = YES;
     
     //旋转变化
     CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     //沿Z轴旋转
     transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
     transformAnim.cumulative = YES;
     transformAnim.duration = 0.3;
     //旋转2遍，360度
     transformAnim.repeatCount = 2;
     transformAnim.removedOnCompletion = YES;
     
     //缩放
     CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"scale"];
     scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
     scaleAnim.duration = 0.6;
     scaleAnim.removedOnCompletion = YES;
     
     CAAnimationGroup *animGroup = [CAAnimationGroup animation];
     animGroup.animations = [NSArray arrayWithObjects:transformAnim, scaleAnim, nil];
     animGroup.duration = 6;
     [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
     */
    
    /*
     CGPoint fromPoint = _cdEGOImageView.center;
     
     //路径曲线
     UIBezierPath *movePath = [UIBezierPath bezierPath];
     [movePath moveToPoint:fromPoint];
     CGPoint toPoint = CGPointMake(62, 119);
     [movePath addQuadCurveToPoint:toPoint
     controlPoint:CGPointMake(62, 119)];
     //关键帧
     CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     moveAnim.path = movePath.CGPath;
     //    moveAnim.removedOnCompletion = YES;
     
     //旋转变化
     CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     //x，y轴缩小到0.1,Z 轴不变
     scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1.0)];
     //    scaleAnim.removedOnCompletion = YES;
     
     //透明度变化
     CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
     opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
     opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
     //    opacityAnim.removedOnCompletion = YES;
     
     //关键帧，旋转，透明度组合起来执行
     CAAnimationGroup *animGroup = [CAAnimationGroup animation];
     animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim,opacityAnim, nil];
     animGroup.duration = 1;
     [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
     */
    /*
     CGPoint fromPoint = _cdEGOImageView.center;
     UIBezierPath *movePath = [UIBezierPath bezierPath];
     [movePath moveToPoint:fromPoint];
     CGPoint toPoint = CGPointMake(fromPoint.x +100 , fromPoint.y ) ;
     [movePath addLineToPoint:toPoint];
     
     CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     moveAnim.path = movePath.CGPath;
     
     CABasicAnimation *TransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     TransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     
     //沿Z轴旋转
     TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,0,1)];
     
     //沿Y轴旋转
     //   scaleAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,1.0,0)];
     
     //沿X轴旋转
     //     TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,1.0,0,0)];
     TransformAnim.cumulative = YES;
     TransformAnim.duration = 0.6;
     //旋转2遍，360度
     TransformAnim.repeatCount =2;
     _cdEGOImageView.center = toPoint;
     TransformAnim.removedOnCompletion = YES;
     CAAnimationGroup *animGroup = [CAAnimationGroup animation];
     animGroup.animations = [NSArray arrayWithObjects:moveAnim, TransformAnim, nil];
     animGroup.duration = 0.6;
     */
    
    //    [_cdEGOImageView.layer addAnimation:animGroup forKey:nil];
    
    /*
     //用例3 scale+rotate+position
     CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
     CATransform3D rotateTransform = CATransform3DMakeRotation(1.57, 0, 0, -1);
     CATransform3D scaleTransform = CATransform3DMakeScale(5, 5, 5);
     CATransform3D positionTransform = CATransform3DMakeTranslation(0, 0, 0); //位置移动
     CATransform3D combinedTransform = CATransform3DConcat(rotateTransform, scaleTransform); //Concat就是combine的意思
     combinedTransform = CATransform3DConcat(combinedTransform, positionTransform); //再combine一次把三个动作连起来
     
     [anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]]; //放在3D坐标系中最正的位置
     [anim setToValue:[NSValue valueWithCATransform3D:combinedTransform]];
     [anim setDuration:5.0f];
     
     [_cdEGOImageView.layer addAnimation:anim forKey:nil];
     
     [_cdEGOImageView.layer setTransform:combinedTransform];  //如果没有这句，layer执行完动画又会返回最初的state
     */
    
    /*
     //旋转变化
     CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     //沿Z轴旋转
     transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
     transformAnim.cumulative = YES;
     transformAnim.duration = 0.3;
     //旋转2遍，360度
     transformAnim.repeatCount = 2;
     transformAnim.removedOnCompletion = YES;
     */
    
    
    
    //逆时针旋转
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.duration = 0.3;
    shake.autoreverses = NO;
    shake.repeatCount = 2;
    
    if (_isPlayViewShowing) {
        //逆时针旋转
        shake.fromValue = [NSNumber numberWithFloat:2 * M_PI];
        shake.toValue = [NSNumber numberWithFloat:0];
        
    } else {
        //顺时针旋转
        shake.fromValue = [NSNumber numberWithFloat:0];
        shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
        
    }
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:shake, nil];
    animGroup.duration = 6;
    _cdEGOImageView.hidden = NO;
    [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
    
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (_isPlayViewShowing) {
            
            _isPlayViewShowing = NO;
            
            _playView.frame = CGRectMake(320, 0, kMainScreenWidth, kMainScreenHeight);
            _cdEGOImageView.frame = CGRectMake(9, kMainScreenHeight - 50, 44, 44);
            
        } else {
            
            _isPlayViewShowing = YES;
            
            _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
            _cdEGOImageView.frame = CGRectMake(62, 119, 196, 196);
            
        }
        
    } completion:^(BOOL finished) {
        
        _cdEGOImageView.hidden = YES;
        
    }];
    
}

//登录，获取用户资料
-(void)initUserData{
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    AccountOf3rdParty *lastUserAccount = [databaseManager getLastLoginUserAccount];
    if (lastUserAccount && lastUserAccount.username && lastUserAccount.password) {
        
        [UserSessionManager GetInstance].currentUser.username = lastUserAccount.username;
        [UserSessionManager GetInstance].currentUser.password = lastUserAccount.password;
        
        [_miglabAPI doAuthLogin:lastUserAccount.username password:lastUserAccount.password];
        
    } else {
        
        [_miglabAPI doGetGuestInfo];
        
    }
    
}

//getGuestInfo notification
-(void)getGuestInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getGuestInfoFailed: %@", result);
    
    [SVProgressHUD showErrorWithStatus:@""];
    
}

-(void)getGuestInfoSuccess:(NSNotification *)tNotification{
    
    NSLog(@"getGuestInfoSuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    PUser *guest = [result objectForKey:@"result"];
    [guest log];
    
    [UserSessionManager GetInstance].currentUser = guest;
    
    [_miglabAPI doAuthLogin:guest.username password:guest.password];
    
}

//login notification
-(void)loginFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"loginFailed: %@", result);
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager deleteUserAccountByUserName:[UserSessionManager GetInstance].currentUser.username];
    
    [SVProgressHUD showErrorWithStatus:@"登录失败"];
    
}

-(void)loginSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"loginSuccess: %@", result);
    
    NSString *accesstoken = [result objectForKey:@"AccessToken"];
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    
    [UserSessionManager GetInstance].accesstoken = accesstoken;
    
    [_miglabAPI doGetUserInfo:username accessToken:accesstoken];
}

//getUserInfo notification
-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getUserInfoFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"重新登陆试试哦~"];
    
}

-(void)getUserInfoSuccess:(NSNotification *)tNotification{
    
    NSDictionary* result = [tNotification userInfo];
    NSLog(@"getUserInfoSuccess...%@", result);
    
    PUser* user = [result objectForKey:@"result"];
    [user log];
    
    user.password = [UserSessionManager GetInstance].currentUser.password;
    [UserSessionManager GetInstance].currentUser = user;
    [UserSessionManager GetInstance].isLoggedIn = YES;
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:0];
    
    //[SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
    //根据描述词获取歌曲 test
    //随机心情词id
    int rnd = (rand() % 6) + 1;
    NSString *tempwordid = [NSString stringWithFormat:@"%d", rnd];
    [_miglabAPI doGetModeMusic:userid token:accesstoken wordid:tempwordid mood:@"mm"];
    
}

-(void)getChannelFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getChannelFailed...%@", result);
   // [SVProgressHUD showErrorWithStatus:@"获取频道信息失败"];
    
}

-(void)getChannelSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getChannelSuccess...");
    
    NSMutableArray* channelList = [result objectForKey:@"result"];
    int channelCount = [channelList count];
    if (channelCount > 0) {
        
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
        
        Channel *channel = [channelList objectAtIndex:0];
        [channel log];
        
        [_miglabAPI doGetMusicFromChannel:userid token:accesstoken channel:[channel.channelId intValue]];
        
    }
    
}

-(void)getMusicFromChannelFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getMusicFromChannelFailed...%@", result);
   // [SVProgressHUD showErrorWithStatus:@"根据频道获取歌曲信息失败"];
    
}

-(void)getMusicFromChannelSuccess:(NSNotification *)tNotification{
    
    //NSDictionary *result = [tNotification userInfo];
    PLog(@"getMusicFromChannelSuccess...");
    
}

-(void)getModeMusicFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getModeMusicFailed...%@", result);
    //[SVProgressHUD showErrorWithStatus:@"根据描述词获取歌曲失败:("];
    
}

-(void)getModeMusicSuccess:(NSNotification *)tNotification{
    
    PLog(@"getModeMusicSuccess...");
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *songInfoList = [result objectForKey:@"result"];
    [[PDatabaseManager GetInstance] insertSongInfoList:songInfoList];
    
    NSMutableArray *tempsonglist = [[PDatabaseManager GetInstance] getSongInfoList:20];
    [_songList addObjectsFromArray:tempsonglist];
    
    //[SVProgressHUD showErrorWithStatus:@"根据描述词获取歌曲成功:)"];
    
}

-(void)addBlacklistFailed:(NSNotification *)tNotification{
    //[SVProgressHUD showErrorWithStatus:@"歌曲拉黑失败:("];
}

-(void)addBlacklistSuccess:(NSNotification *)tNotification{
    //[SVProgressHUD showSuccessWithStatus:@"歌曲拉黑成功:)"];
}

-(void)collectSongFailed:(NSNotification *)tNotification{
    //[SVProgressHUD showErrorWithStatus:@"歌曲收藏失败:("];
}

-(void)collectSongSuccess:(NSNotification *)tNotification{
    //[SVProgressHUD showSuccessWithStatus:@"歌曲收藏成功:)"];
}

-(void)addMoodRecordFailed:(NSNotification *)tNotification{
    //[SVProgressHUD showErrorWithStatus:@"记录用户心情失败:("];
}

-(void)addMoodRecordSuccess:(NSNotification *)tNotification{
    //[SVProgressHUD showSuccessWithStatus:@"记录用户心情成功:)"];
}

// end 登录，获取用户资料

-(void)downloadFailed:(NSNotification *)tNotification{
    PLog(@"downloadFailed...");
    
    //[SVProgressHUD showErrorWithStatus:@"下载歌曲失败"];
    
    //播放下一首
//    [self doNextAction:nil];
    
}

-(void)downloadProcess:(NSNotification *)tNotification{
    
    NSDictionary *dicProcess = [tNotification userInfo];
    PLog(@"downloadProcess: %@", dicProcess);
    
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
            
#if USE_NEW_AUDIO_PLAY
            
            PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
            
            if (![asMusicPlayer isMusicPlaying]) {
                
                [self initAndStartPlayer];
            }
            
#else // USE_NEW_AUDIO_PLAY
            
            PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
            if (![aaMusicPlayer isMusicPlaying] && _shouldStartPlayAfterDownloaded) {
                _shouldStartPlayAfterDownloaded = NO;
                [self initAndStartPlayer];
            }
            
#endif //USE_NEW_AUDIO_PLAY
            
        }
        
    }
    
}

-(void)downloadSuccess:(NSNotification *)tNotification{
    PLog(@"downloadSuccess...");
}

#pragma PHttpDownloaderDelegate

-(void)doDownloadFailed:(NSDictionary *)dicResult{
    
    PLog(@"doDownloadFailed...%@", dicResult);
    
    NSString *localkey = [dicResult objectForKey:@"LocalKey"];
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager deleteSongInfo:[localkey longLongValue]];
    
    //[SVProgressHUD showErrorWithStatus:@"歌曲下载失败:("];
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
            
#if USE_NEW_AUDIO_PLAY
            
            PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
            
            if (![asMusicPlayer isMusicPlaying]) {
                
                [self initAndStartPlayer];
            }
            
#else //USE_NEW_AUDIO_PLAY
            
            PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
            if (![aaMusicPlayer isMusicPlaying] && _shouldStartPlayAfterDownloaded) {
                _shouldStartPlayAfterDownloaded = NO;
                [self initAndStartPlayer];
            }
            
#endif //USE_NEW_AUDIO_PLAY
        }
        
    }
    
}

-(void)doDownloadSuccess:(NSDictionary *)dicResult{
    
    PLog(@"doDownloadSuccess...%@", dicResult);
    //[SVProgressHUD showErrorWithStatus:@"歌曲下载完成"];
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if (![asMusicPlayer isMusicPlaying]) {
        
        [self initAndStartPlayer];
    }
    
#else // USE_NEW_AUDIO_PLAY
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (![aaMusicPlayer isMusicPlaying] && _shouldStartPlayAfterDownloaded) {
        _shouldStartPlayAfterDownloaded = NO;
        [self initAndStartPlayer];
    }
  
#endif //USE_NEW_AUDIO_PLAY
}

#pragma PHttpDownloaderDelegate end

-(void)stopDownload{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadPause];
    
    _shouldStartPlayAfterDownloaded = YES;
    
}

-(void)initSongInfo{
    
    _lblSongInfo.text = [NSString stringWithFormat:@"%@ - %@", _currentSong.songname, _currentSong.artist];
    
    _playerBoradView.lblSongName.text = _currentSong.songname;
    _playerBoradView.lblArtist.text = _currentSong.artist;
    NSURL *tempCoverUrl = [NSURL URLWithString:_currentSong.coverurl];
    _cdOfSongView.coverOfSongEGOImageView.imageURL = tempCoverUrl;
    _cdEGOImageView.imageURL = tempCoverUrl;
    _playerBoradView.btnAvatar.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_MUSIC_IMAGE];
    _playerBoradView.btnAvatar.imageURL = tempCoverUrl;
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if (![asMusicPlayer isMusicPlaying]) {
        
        [self initAndStartPlayer];
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
        
        [songManager downloadStart:_currentSong delegate:self];
        
    }
    
}

-(void)initAndStartPlayer{
    
    PLog(@"initAndStartPlayer...");
    
    if (!_currentSong || !_currentSong.songCachePath) {
        PLog(@"_currentSong.songCachePath is nil...");
        return;
    }
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if (asMusicPlayer && [asMusicPlayer isMusicPlaying]) {
        
        return;
    }
    
    asMusicPlayer.song = _currentSong;
    
    BOOL isPlayerInit = [asMusicPlayer initPlayer];
    
    if (isPlayerInit) {
        
        asMusicPlayer.delegate = self;
        
        [asMusicPlayer play];
        [self timerStart];
        _hasAddMoodRecord = NO;
    }
    else {
        
        [asMusicPlayer playerDestroy];
        _shouldStartPlayAfterDownloaded = NO;
    }
    
#else //USE_NEW_AUDIO_PLAY
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (aaMusicPlayer && [aaMusicPlayer isMusicPlaying]) {
        return;
    }
    
    aaMusicPlayer.song = _currentSong;
    
    BOOL isPlayerInit = [aaMusicPlayer initPlayer];
    if (isPlayerInit) {
        aaMusicPlayer.delegate = self;
        [aaMusicPlayer play];
        [self timerStart];
        _hasAddMoodRecord = NO;
        
        //[SVProgressHUD showSuccessWithStatus:@"开始播放"];
        
    } else {
        
        [aaMusicPlayer playerDestory];
        _shouldStartPlayAfterDownloaded = YES;
        //[SVProgressHUD showSuccessWithStatus:@"播放器初始化失败:("];
        
    }
    
#endif //USE_NEW_AUDIO_PLAY
}

-(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:_currentSong.songname forKey:MPMediaItemPropertyTitle];
        [dict setObject:_currentSong.artist forKey:MPMediaItemPropertyArtist];
        MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:_cdEGOImageView.image];
        [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}

#pragma PMusicPlayerDelegate
//PAAMusicPlayer
-(void)aaMusicPlayerTimerFunction{
    
//    [self doUpdateForPlaying];
    
}

-(void)aaMusicPlayerStoped{
    
    //播放下一首
    [self doNextAction:nil];
    
}

//PAMusicPlayer
-(void)aMusicPlayerTimerFunction{
    
//    [self doUpdateForPlaying];
    
}

-(void)aMusicPlayerStoped{
    
    //播放下一首
    [self doNextAction:nil];
    
}

#pragma PMusicPlayerDelegate end

//播放时刷新所有对于view的数据
-(void)doUpdateForPlaying{
    
    [_topPlayerInfoView doUpdatePlayingTip];
    [self doRotateSongCover];
    [self doUpdateProcess];
    
}

//旋转歌曲封面
-(void)doRotateSongCover{
    
    CGAffineTransform transformTmp = _cdOfSongView.coverOfSongEGOImageView.transform;
    transformTmp = CGAffineTransformRotate(transformTmp, ROTATE_ANGLE);
    _cdOfSongView.coverOfSongEGOImageView.transform = transformTmp;
    
}

//根据圆圈的比率，刷新圆盘进度
-(void)doUpdateProcess{
    
    if (_checkUpdatePlayProcess < 10) {
        _checkUpdatePlayProcess++;
        return;
    }
    _checkUpdatePlayProcess = 0;
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    long duration = asMusicPlayer.getDuration;
    long currentTime = asMusicPlayer.getCurrentTime;
    
#else //USE_NEW_AUDIO_PLAY
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    long duration = aaMusicPlayer.getDuration;
    long currentTime = aaMusicPlayer.getCurrentTime;
    
#endif //USE_NEW_AUDIO_PLAY
    
    float playProcess = (duration > 0) ? (float)currentTime / (float)duration : 0;
    
    [_cdOfSongView updateProcess:playProcess];
    
    //大于10s，则发请求记录
    if (currentTime > 10 && !_hasAddMoodRecord) {
        _hasAddMoodRecord = YES;
        [self doAddMoodRecord];
    }
    
}

//记录当前心情歌曲
-(void)doAddMoodRecord{
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    [_miglabAPI doAddMoodRecord:userid token:accesstoken wordid:_currentSong.wordid songid:_currentSong.songid];
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _showInfoPageControl.currentPage = page;
    
}

#pragma UIScrollViewDelegate end


#pragma EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView{
    
    [self configNowPlayingInfoCenter];
    
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error{
    
    PLog(@"imageViewFailedToLoadImage tag: %d, error: %@", imageView.tag, error);
    if (imageView && imageView.tag == 2000) {
        //_cdOfSongView.coverOfSongEGOImageView
        imageView.image = [UIImage imageWithName:@"song_cover" type:@"png"];
    }
    
}

#pragma EGOImageButtonDelegate
- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton{
    
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error{
    
    PLog(@"imageButtonFailedToLoadImage tag: %d, error: %@", imageButton.tag, error);
    
}

@end
