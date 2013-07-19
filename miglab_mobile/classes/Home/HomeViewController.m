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
#import "PlayViewController.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "MainMenuViewController.h"
#import "UINavigationController+PAnimationCategory.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize aaMusicPlayer = _aaMusicPlayer;

@synthesize btnMove = _btnMove;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
    
    //download
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:NotificationNameDownloadFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProcess:) name:NotificationNameDownloadProcess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:NotificationNameDownloadSuccess object:nil];
    
    
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    [miglabAPI doAuthLogin:username password:password];
    
    
//    [miglabAPI doRegister:@"test@miglab.com" password:@"123456" nickname:@"archer" source:0];
    //[miglabAPI doGetGuestInfo];
    
    
    //test database
//    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
//    [databaseManager setSongMaxSize:231 type:@"mp3" fileMaxSize:2342343];
//    [databaseManager setSongMaxSize:231 type:@"mp3" fileMaxSize:2342343];
    
    
    [_btnMove addTarget:self action:@selector(dragBegin:withEvent:) forControlEvents:UIControlEventTouchDown];
    [_btnMove addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_btnMove addTarget:self action:@selector(dragEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
}

-(void)dragBegin:(UIControl *)c withEvent:ev{
    
    CGPoint beginPoint = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"dragBegin beginPoint.x: %f, beginPoint.y: %f", beginPoint.x, beginPoint.y);
    
}

-(void)dragMoving:(UIControl *)c withEvent:ev{
    
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"dragMoving c.center.x: %f, c.center.y: %f", c.center.x, c.center.y);
    
}

-(void)dragEnd:(UIControl *)c withEvent:ev{
    
    c.center = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"dragEnd c.center.x: %f, c.center.y: %f", c.center.x, c.center.y);
    
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
    
    [UserSessionManager GetInstance].accesstoken = accesstoken;
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    [miglabAPI doGetUserInfo:username accessToken:accesstoken];
}

-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSLog(@"getUserIdFailed...");
    
}

-(void)getUserInfoSuccess:(NSNotification *)tNotification{
    
    NSDictionary* result = [tNotification userInfo];
    NSLog(@"getUserIdSuccess...%@", result);
    
    User* user = [result objectForKey:@"result"];
    [UserSessionManager GetInstance].currentUser = user;
    
    PLog(@"%@", [UserSessionManager GetInstance].currentUser.userid);
    
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

-(IBAction)doInterfaceTest:(id)sender {
    
    NSString* token = [UserSessionManager GetInstance].accesstoken;
    NSString* uid = [UserSessionManager GetInstance].currentUser.userid;
    
    MigLabAPI* migapi = [[MigLabAPI alloc] init];
    //[migapi doGetGuestInfo]; //OK
    //[migapi doRegister:@"myfirstarcher" password:@"12345678" nickname:@"hehearcher" source:0]; //OK
    //[migapi doUpdateUserInfo:uid token:token username:[UserSessionManager GetInstance].currentUser.username nickname:@"migtest" gender:@"1" birthday:@"1987-08-23" location:@"china" source:@"0" head:[UserSessionManager GetInstance].currentUser.head];
    //[migapi doGetChannel:uid token:token num:5];
    //[migapi doGetMusicFromChannel:uid token:token channel:17];
    [migapi doGetModeScene:uid token:token decword:@"mood"];
}

//
-(IBAction)doGotoPlayView:(id)sender{
    
    PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:playViewController];
    [nav setNavigationBarHidden:YES];
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController setRootController:nav animated:YES];
    
}

-(IBAction)doGotoMenuView:(id)sender{
    
    MainMenuViewController *menuViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    
    UIViewAnimationTransition trans = UIViewAnimationOptionTransitionCurlUp;
    [self.navigationController pushViewController:menuViewController animatedWithTransition:trans];
    
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:menuViewController];
//    [nav setNavigationBarHidden:YES];
//    
//    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
//    [menuController setRootController:nav animated:YES];
    
}

@end
