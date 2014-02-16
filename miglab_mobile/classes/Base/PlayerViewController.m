//
//  PlayerViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>

#import "DetailPlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

//导航指针
@synthesize topViewcontroller = _topViewcontroller;
//底部播放器
@synthesize playerMenuView = _playerMenuView;
//接口api
@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //menu
    _playerMenuView = [[MusicPlayerMenuView alloc] initDefaultMenuView:CGRectMake(11.5, kMainScreenHeight + self.topDistance - 73 - 10, 297, 73)];
    _playerMenuView.btnAvatar.delegate = self;
    [_playerMenuView.btnAvatar addTarget:self action:@selector(doPlayerAvatar:) forControlEvents:UIControlEventTouchUpInside];
    _playerMenuView.lblSongInfo.text = @"迷宫仙曲－乐瑟";
    [_playerMenuView.btnDelete addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnCollect addTarget:self action:@selector(doCollect:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnNext addTarget:self action:@selector(doNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerMenuView];
    
    //
    _topViewcontroller = (_topViewcontroller != nil) ? _topViewcontroller : self;
    
    //
    _miglabAPI = [[MigLabAPI alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    PLog(@"PlayerViewController viewWillAppear...");
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongFailed:) name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongSuccess:) name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongFailed:) name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongSuccess:) name:NotificationNameCollectSongSuccess object:nil];
    
    //doCancelCollectedSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCollectedSongFailed:) name:NotificationNameDeleteCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCollectedSongSuccess:) name:NotificationNameDeleteCollectSongSuccess object:nil];
    
    //doPlayOrPause
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStart:) name:NotificationNamePlayerStart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStop:) name:NotificationNamePlayerStop object:nil];
    
    
    [self updateSongInfo];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    PLog(@"PlayerViewController viewDidAppear...");
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    PLog(@"PlayerViewController viewWillDisappear...");
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    PLog(@"PlayerViewController viewDidDisappear...");
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongSuccess object:nil];
    
    //doCancelCollectedSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameDeleteCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameDeleteCollectSongSuccess object:nil];
    
    //doPlayOrPause
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNamePlayerStart object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNamePlayerStop object:nil];
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause...");
                [self doPlayOrPause:nil];
                break;
            }
            case UIEventSubtypeRemoteControlPlay:
            {
                NSLog(@"UIEventSubtypeRemoteControlPlay...");
                break;
            }
            case UIEventSubtypeRemoteControlPause:
            {
                NSLog(@"UIEventSubtypeRemoteControlPause...");
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
                [self doNext:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doPlayerAvatar:(id)sender{
    
    PLog(@"doPlayerAvatar...");
    
    DetailPlayerViewController *detailPlayerViewController = [[DetailPlayerViewController alloc] initWithNibName:@"DetailPlayerViewController" bundle:nil];
    [_topViewcontroller presentModalViewController:detailPlayerViewController animated:YES];
    
}

-(IBAction)doDelete:(id)sender{
    
    PLog(@"doDelete...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].userid;
        [_miglabAPI doHateSong:userid token:accesstoken sid:currentSong.songid];
        
        int currentSongIndex = [PPlayerManagerCenter GetInstance].currentSongIndex;
        [[PPlayerManagerCenter GetInstance].songList removeObjectAtIndex:currentSongIndex];
        [[PDatabaseManager GetInstance] deleteSongInfo:currentSong.songid];
        [self doNext:nil];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    
}

-(IBAction)doCollect:(id)sender{
    
    PLog(@"doCollect...");
    
    UserSessionManager *userSessionManager = [UserSessionManager GetInstance];
    if (userSessionManager.isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *songid = [NSString stringWithFormat:@"%lld", currentSong.songid];
        NSString *moodid = [NSString stringWithFormat:@"%d", userSessionManager.currentUserGene.mood.typeid];
        NSString *typeid = [NSString stringWithFormat:@"%d", userSessionManager.currentUserGene.type.typeid];
        
        int isLike = [currentSong.like intValue];
        if (isLike > 0) {
            [_miglabAPI doDeleteCollectedSong:userid token:accesstoken songid:songid];
        } else {
            [_miglabAPI doCollectSong:userid token:accesstoken sid:songid modetype:moodid typeid:typeid];
        }
        
        
    } else {
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    [[PPlayerManagerCenter GetInstance] doPlayOrPause];
    
    [self updateSongInfo];
    
}

-(IBAction)doNext:(id)sender{
    
    PLog(@"doNext...");
    
    [[PPlayerManagerCenter GetInstance] doNext];
    
    [self updateSongInfo];
    
    UIImage *stopNorImage = [UIImage imageWithName:@"music_menu_stop_nor" type:@"png"];
    [_playerMenuView.btnPlayOrPause setImage:stopNorImage forState:UIControlStateNormal];
    
    //获取更多歌曲
    int tempCurrentSongIndex = [PPlayerManagerCenter GetInstance].currentSongIndex;
    if (tempCurrentSongIndex + 1 >= [PPlayerManagerCenter GetInstance].songList.count) {
        
        //根据音乐基因获取歌曲
        [self loadTypeSongs];
        
    }//if
    
}

//根据音乐基因获取歌曲
-(void)loadTypeSongs{
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        NSString *ttypeid = [NSString stringWithFormat:@"%d", usergene.type.typeid];
        NSString *ttypenum = [NSString stringWithFormat:@"%d", usergene.type.changenum];
        NSString *tmoodid = [NSString stringWithFormat:@"%d", usergene.mood.typeid];
        NSString *tmoodnum = [NSString stringWithFormat:@"%d", usergene.mood.changenum];
        NSString *tsceneid = [NSString stringWithFormat:@"%d", usergene.scene.typeid];
        NSString *tscenenum = [NSString stringWithFormat:@"%d", usergene.scene.changenum];
        NSString *tchannelid = [NSString stringWithFormat:@"%@", usergene.channel.channelId];
        NSString *tchannelnum = [NSString stringWithFormat:@"%d", usergene.channel.changenum];
        
        [self.miglabAPI doGetTypeSongs:userid token:accesstoken typeid:ttypeid typeindex:ttypenum moodid:tmoodid moodindex:tmoodnum sceneid:tsceneid sceneindex:tscenenum channelid:tchannelid channelindex:tchannelnum num:[NSString stringWithFormat:@"%d", GET_TYPE_SONGS_NUM]];
        
    } else {
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
    
}

-(void)updateSongInfo{
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if ([aaMusicPlayer isMusicPlaying]) {
        UIImage *stopNorImage = [UIImage imageWithName:@"music_menu_stop_nor" type:@"png"];
        [_playerMenuView.btnPlayOrPause setImage:stopNorImage forState:UIControlStateNormal];
    } else {
        UIImage *playNorImage = [UIImage imageWithName:@"music_menu_play_nor" type:@"png"];
        [_playerMenuView.btnPlayOrPause setImage:playNorImage forState:UIControlStateNormal];
    }
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    _playerMenuView.btnAvatar.imageURL = [NSURL URLWithString:currentsong.coverurl];
    
    if (currentsong.songname && currentsong.artist) {
        _playerMenuView.lblSongInfo.text = [NSString stringWithFormat:@"%@ - %@", currentsong.songname, currentsong.artist];
    } else if (currentsong.songname) {
        _playerMenuView.lblSongInfo.text = [NSString stringWithFormat:@"%@", currentsong.songname];
    } else if (currentsong.artist) {
        _playerMenuView.lblSongInfo.text = [NSString stringWithFormat:@"%@", currentsong.artist];
    } else {
        _playerMenuView.lblSongInfo.text = @"无敌仙曲－乐瑟乐瑟";
    }
    
    
    int isLike = [currentsong.like intValue];
    if (isLike > 0) {
        
        UIImage *darkHeartImage = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
        [_playerMenuView.btnCollect setImage:darkHeartImage forState:UIControlStateNormal];
        
    } else {
        
        UIImage *lightHeartImage = [UIImage imageWithName:@"music_menu_light_heart_nor" type:@"png"];
        [_playerMenuView.btnCollect setImage:lightHeartImage forState:UIControlStateNormal];
        
    }
    
    if (currentsong && currentsong.songname && currentsong.artist) {
        [self configNowPlayingInfoCenter:currentsong artwork:nil];
    }

    
}

-(void)configNowPlayingInfoCenter:(Song *)currentSong artwork:(UIImage *)tArtwork{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:currentSong.songname forKey:MPMediaItemPropertyTitle];
        [dict setObject:currentSong.artist forKey:MPMediaItemPropertyArtist];
        
        if (tArtwork) {
            MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:tArtwork];
            [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        }
        
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}

#pragma notification

-(void)hateSongFailed:(NSNotification *)tNotification{
    [SVProgressHUD showErrorWithStatus:@"拉黑歌曲失败:("];
}

-(void)hateSongSuccess:(NSNotification *)tNotification{
    [SVProgressHUD showSuccessWithStatus:@"拉黑歌曲成功:)"];
}

-(void)collectSongFailed:(NSNotification *)tNotification{
    [SVProgressHUD showErrorWithStatus:@"收藏歌曲失败:("];
}

-(void)collectSongSuccess:(NSNotification *)tNotification{
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    currentsong.like = @"1";
    
    [[PDatabaseManager GetInstance] updateSongInfoOfLike:currentsong.songid like:@"1"];
    
    UIImage *darkHeartImage = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
    [_playerMenuView.btnCollect setImage:darkHeartImage forState:UIControlStateNormal];
    
    [SVProgressHUD showSuccessWithStatus:@"收藏歌曲成功:)"];
}

-(void)cancelCollectedSongFailed:(NSNotification *)tNotification{
    [SVProgressHUD showErrorWithStatus:@"取消收藏歌曲失败:("];
}

-(void)cancelCollectedSongSuccess:(NSNotification *)tNotification{
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    currentsong.like = @"0";
    
    [[PDatabaseManager GetInstance] updateSongInfoOfLike:currentsong.songid like:@"0"];
    
    UIImage *lightHeartImage = [UIImage imageWithName:@"music_menu_light_heart_nor" type:@"png"];
    [_playerMenuView.btnCollect setImage:lightHeartImage forState:UIControlStateNormal];
    
    [SVProgressHUD showSuccessWithStatus:@"取消收藏歌曲成功:)"];
}

-(void)playerStart:(NSNotification *)tNotification{
    
    PLog(@"playerStart...");
    
    [self updateSongInfo];
    
}

-(void)playerStop:(NSNotification *)tNotification{
    
    PLog(@"playerStop...");
    
    [self updateSongInfo];
    
}

#pragma EGOImageButtonDelegate

- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton{
    
    if (imageButton) {
        
        Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
        UIImage *songcover = [_playerMenuView.btnAvatar imageForState:UIControlStateNormal];
        [self configNowPlayingInfoCenter:currentsong artwork:songcover];
        
    }
    
}

@end
