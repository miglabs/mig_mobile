//
//  PlayerViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

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
    _playerMenuView = [[MusicPlayerMenuView alloc] initDefaultMenuView:CGRectMake(11.5, kMainScreenHeight - 73 - 10, 297, 73)];
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
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongFailed:) name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongSuccess:) name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongFailed:) name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongSuccess:) name:NotificationNameCollectSongSuccess object:nil];
    
    //doCancelCollectedSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCollectedSongFailed:) name:NotificationNameCancelCollectedSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelCollectedSongSuccess:) name:NotificationNameCancelCollectedSongSuccess object:nil];
    
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
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongSuccess object:nil];
    
    //doCancelCollectedSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongSuccess object:nil];
    
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
            [_miglabAPI doCancelCollectedSong:accesstoken uid:userid songid:[songid longLongValue]];
        } else {
            [_miglabAPI doCollectSong:userid token:accesstoken sid:songid modetype:moodid typeid:typeid];
        }
        
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
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
    _playerMenuView.lblSongInfo.text = [NSString stringWithFormat:@"%@ - %@", currentsong.songname, currentsong.artist];
    
    int isLike = [currentsong.like intValue];
    if (isLike > 0) {
        
        UIImage *darkHeartImage = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
        [_playerMenuView.btnCollect setImage:darkHeartImage forState:UIControlStateNormal];
        
    } else {
        
        UIImage *lightHeartImage = [UIImage imageWithName:@"music_menu_light_heart_nor" type:@"png"];
        [_playerMenuView.btnCollect setImage:lightHeartImage forState:UIControlStateNormal];
        
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

@end
