//
//  PlayerViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "UserSessionManager.h"
#import "PPlayerManagerCenter.h"
#import "SVProgressHUD.h"

#import "DetailPlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

@synthesize topViewcontroller = _topViewcontroller;

@synthesize playerMenuView = _playerMenuView;
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

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongFailed:) name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongSuccess:) name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongFailed:) name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongSuccess:) name:NotificationNameCollectSongSuccess object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
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
    //    [_topViewcontroller.navigationController pushViewController:detailPlayerViewController animated:YES];
    [_topViewcontroller presentModalViewController:detailPlayerViewController animated:YES];
    
}

-(IBAction)doDelete:(id)sender{
    
    PLog(@"doDelete...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
        [_miglabAPI doHateSong:accesstoken uid:userid sid:currentSong.songid];
        
    }
    
}

-(IBAction)doCollect:(id)sender{
    
    PLog(@"doCollect...");
    
    UserSessionManager *userSessionManager = [UserSessionManager GetInstance];
    if (userSessionManager.isLoggedIn) {
        
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
        [_miglabAPI doCollectSong:accesstoken uid:userid songid:currentSong.songid];
        
    }
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    [[PPlayerManagerCenter GetInstance] doPlayOrPause];
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if ([aaMusicPlayer isMusicPlaying]) {
        UIImage *stopNorImage = [UIImage imageWithName:@"music_menu_stop_nor" type:@"png"];
        [_playerMenuView.btnPlayOrPause setImage:stopNorImage forState:UIControlStateNormal];
    } else {
        UIImage *playNorImage = [UIImage imageWithName:@"music_menu_play_nor" type:@"png"];
        [_playerMenuView.btnPlayOrPause setImage:playNorImage forState:UIControlStateNormal];
    }
    
}

-(IBAction)doNext:(id)sender{
    
    PLog(@"doNext...");
    
    [[PPlayerManagerCenter GetInstance] doNext];
    
}

-(void)hateSongFailed:(NSNotification *)tNotification{
    [SVProgressHUD showErrorWithStatus:@"歌曲拉黑失败:("];
}

-(void)hateSongSuccess:(NSNotification *)tNotification{
    [SVProgressHUD showSuccessWithStatus:@"歌曲拉黑成功:)"];
}

-(void)collectSongFailed:(NSNotification *)tNotification{
    [SVProgressHUD showErrorWithStatus:@"歌曲收藏失败:("];
}

-(void)collectSongSuccess:(NSNotification *)tNotification{
    [SVProgressHUD showSuccessWithStatus:@"歌曲收藏成功:)"];
}

@end
