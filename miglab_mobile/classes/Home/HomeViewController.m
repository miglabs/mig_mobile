//
//  HomeViewController.m
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "HomeViewController.h"
#import "MigLabAPI.h"
#import "Song.h"
#import "SongDownloadManager.h"
#import "MigLabConfig.h"
#import "UserSessionManager.h"
#import "PPlayerManaerCenter.h"
#import "PDatabaseManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize aaMusicPlayer = _aaMusicPlayer;

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
    
    
    //test
    
    //login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
    
    //user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserIdFailed:) name:NotificationNameGetUserIdFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserIdSuccess:) name:NotificationNameGetUserIdSuccess object:nil];
    
    //download
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:NotificationNameDownloadFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProcess:) name:NotificationNameDownloadProcess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:NotificationNameDownloadSuccess object:nil];
    
    
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    //[miglabAPI doAuthLogin:username password:password];
    
    [miglabAPI doRegister:@"archer1234" password:@"123456" nickname:@"archer" source:0];
    
    
    //test database
//    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
//    [databaseManager setSongMaxSize:231 type:@"mp3" fileMaxSize:2342343];
//    [databaseManager setSongMaxSize:231 type:@"mp3" fileMaxSize:2342343];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loginFailed:(NSNotification *)tNotification{
    
    NSLog(@"loginFailed...");
    
}

-(void)loginSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"loginSuccess: %@", result);
    
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *accesstoken = [result objectForKey:@"AccessToken"];
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    [miglabAPI doGetUserInfo:username accessToken:accesstoken];
}

-(void)getUserIdFailed:(NSNotification *)tNotification{
    
    NSLog(@"getUserIdFailed...");
    
}

-(void)getUserIdSuccess:(NSNotification *)tNotification{
    
    NSLog(@"getUserIdSuccess...");
    
}

//-------------------------
-(IBAction)doPlay:(id)sender{
    
    PLog(@"do play...");
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"qhc" ofType:@"caf"];
    BOOL fileexit = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileexit) {
        
        Song *tempSong = [[Song alloc] init];
        tempSong.songurl = filepath;
        tempSong.whereIsTheSong = WhereIsTheSong_IN_APP;
        
        _aaMusicPlayer = [[PPlayerManaerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        
        if (_aaMusicPlayer.playerDestoried) {
            
            _aaMusicPlayer.song = tempSong;
            
            BOOL isPlayerInit = [_aaMusicPlayer initPlayer];
            if (isPlayerInit) {
                [_aaMusicPlayer play];
            }
            
        } else {
            
            [_aaMusicPlayer playerPlayPause];
            
        }
        
        
        
    }
    
}

//-------------------------

-(IBAction)doStart:(id)sender{
    
    Song *song = [[Song alloc] init];
    song.songid = 276269;
    song.songurl = @"http://umusic.9158.com//2013/06/27/10/36/276269_3e084a286f644b3caa3d701025b34ca3.mp3";
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadStart:song];
    
}

-(IBAction)doPause:(id)sender{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadPause];
    
}

-(IBAction)doResume:(id)sender{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadResume];
}

-(void)downloadFailed:(NSNotification *)tNotification{
    PLog(@"downloadFailed...");
}

-(void)downloadProcess:(NSNotification *)tNotification{
    
    NSDictionary *dicProcess = [tNotification userInfo];
    PLog(@"downloadProcess: %@", dicProcess);
}

-(void)downloadSuccess:(NSNotification *)tNotification{
    PLog(@"downloadSuccess...");
}

@end
