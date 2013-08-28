//
//  RootViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RootViewController.h"
#import "SYAppStart.h"

#import "GeneViewController.h"
#import "MusicViewController.h"
#import "FriendViewController.h"

#import "PDatabaseManager.h"
#import "PPlayerManagerCenter.h"

#import "UserSessionManager.h"
#import "SVProgressHUD.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize isFirstWillAppear = _isFirstWillAppear;
@synthesize isFirstDidAppear = _isFirstDidAppear;

@synthesize rootNavMenuView = _rootNavMenuView;
@synthesize dicViewControllerCache = _dicViewControllerCache;
@synthesize currentShowViewTag = _currentShowViewTag;

@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //doGetGuestInfo
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuestInfoFailed:) name:NotificationNameGetGuestFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuestInfoSuccess:) name:NotificationNameGetGuestSuccess object:nil];
        
        //login
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
        
        //user
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
        
        //getModeMusic
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getModeMusicFailed:) name:NotificationNameModeMusicFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getModeMusicSuccess:) name:NotificationNameModeMusicSuccess object:nil];
        
        
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
    
    //getModeMusic
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameModeMusicFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameModeMusicSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _rootNavMenuView = [[RootNavigationMenuView alloc] initRootNavigationMenuView:CGRectMake(0, 0, 320, 44)];
    _rootNavMenuView.btnMenuFirst.tag = 100;
    _rootNavMenuView.btnMenuSecond.tag = 101;
    _rootNavMenuView.btnMenuThird.tag = 102;
    [_rootNavMenuView.btnMenuFirst setTitle:@"音乐基因" forState:UIControlStateNormal];
    [_rootNavMenuView.btnMenuSecond setTitle:@"歌单" forState:UIControlStateNormal];
    [_rootNavMenuView.btnMenuThird setTitle:@"歌友" forState:UIControlStateNormal];
    [_rootNavMenuView.btnMenuFirst addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuSecond addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuThird addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rootNavMenuView];
    
    //缓存view
    _dicViewControllerCache = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self segmentAction:_rootNavMenuView.btnMenuFirst];
    
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
    //登录，获取用户资料
    //login
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        //根据描述词获取歌曲 test
        //随机心情词id
        int rnd = (rand() % 6) + 1;
        NSString *tempwordid = [NSString stringWithFormat:@"%d", rnd];
        [_miglabAPI doGetModeMusic:userid token:accesstoken wordid:tempwordid mood:@"mm"];
        
    } else {
        
        // testing code for Archer
        [_miglabAPI doGetTypeSongs:@"12" token:@"fdaereafdafae" moodid:@"1" moodindex:@"1" sceneid:@"1" sceneindex:@"1" channelid:@"1" channelindex:@"1"];
        
        [self initUserData];
        
    }
    
    //test data
    
    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
    
    PLog(@"rand(): %d, random(): %ld", rand(), random());
    int songListCount = [tempSongInfoList count];
    int rnd = rand() % songListCount;
    
    PPlayerManagerCenter *playerManagerCenter = [PPlayerManagerCenter GetInstance];
    [playerManagerCenter.songList addObjectsFromArray:tempSongInfoList];
    playerManagerCenter.currentSongIndex = rnd;
    playerManagerCenter.currentSong = (songListCount > 0) ? [tempSongInfoList objectAtIndex:rnd] : nil;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!_isFirstWillAppear) {
        _isFirstWillAppear = YES;
        [SYAppStart show];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (!_isFirstDidAppear) {
        _isFirstDidAppear = YES;
        [SYAppStart hide:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentAction:(id)sender{
    
    UIButton *tempButton = sender;
    
    _currentShowViewTag = tempButton.tag;
    NSLog(@"_currentShowViewTag: %d", _currentShowViewTag);
    
    //remove
    UIView *oldShowView = [self.view viewWithTag:999];
    [oldShowView removeFromSuperview];
    
    //show
    UIViewController *controller = [self getControllerBySegIndex:_currentShowViewTag];
    UIView *newShowView = controller.view;
    newShowView.tag = 999;
    [self.view insertSubview:newShowView belowSubview:_rootNavMenuView];
    
}

-(UIViewController *)getControllerBySegIndex:(int)segindex{
    
    NSNumber *numIndex = [NSNumber numberWithInt:segindex];
    UIViewController *controller = [_dicViewControllerCache objectForKey:numIndex];
    
    switch (segindex) {
        case 100:
        {
            if (controller) {
                //update
                GeneViewController *oldGene = (GeneViewController *)controller;
                
            } else {
                
                GeneViewController *gene = [[GeneViewController alloc] initWithNibName:@"GeneViewController" bundle:nil];
                [gene setTopViewcontroller:self];
                [_dicViewControllerCache setObject:gene forKey:numIndex];
                controller = gene;
                
            }
            
        }
            break;
        case 101:
        {
            if (controller) {
                //update
                MusicViewController *oldMusic = (MusicViewController *)controller;
                
            } else {
                
                MusicViewController *music = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
                [music setTopViewcontroller:self];
                [_dicViewControllerCache setObject:music forKey:numIndex];
                controller = music;
                
            }
        }
            break;
        case 102:
        {
            if (controller) {
                //update
                FriendViewController *oldFriend = (FriendViewController *)controller;
                
            } else {
                
                FriendViewController *friend = [[FriendViewController alloc] initWithNibName:@"FriendViewController" bundle:nil];
                [friend setTopViewcontroller:self];
                [_dicViewControllerCache setObject:friend forKey:numIndex];
                controller = friend;
                
            }
        }
            break;
            
        default:
            break;
    }
    
    return controller;
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

#pragma Miglab API notification

//getGuestInfo notification
-(void)getGuestInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getGuestInfoFailed: %@", result);
    
    [SVProgressHUD showErrorWithStatus:@"游客信息获取失败:("];
    
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
    [SVProgressHUD showErrorWithStatus:@"用户信息获取失败:("];
    
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
    
    [SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
    //根据描述词获取歌曲 test
    //随机心情词id
    int rnd = (rand() % 6) + 1;
    NSString *tempwordid = [NSString stringWithFormat:@"%d", rnd];
    [_miglabAPI doGetModeMusic:userid token:accesstoken wordid:tempwordid mood:@"mm"];
    
}

//doGetModeMusic notification
-(void)getModeMusicFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getModeMusicFailed...%@", [result objectForKey:@"msg"]);
    [SVProgressHUD showErrorWithStatus:@"根据描述词获取歌曲失败:("];
    
}

-(void)getModeMusicSuccess:(NSNotification *)tNotification{
    
    PLog(@"getModeMusicSuccess...");
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *songInfoList = [result objectForKey:@"result"];
    [[PDatabaseManager GetInstance] insertSongInfoList:songInfoList];
    
    NSMutableArray *tempsonglist = [[PDatabaseManager GetInstance] getSongInfoList:20];
    [[PPlayerManagerCenter GetInstance].songList addObjectsFromArray:tempsonglist];
    
    [SVProgressHUD showErrorWithStatus:@"根据描述词获取歌曲成功:)"];
    
}

@end
