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

@synthesize locationManager = _locationManager;

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
        
        //getTypeSongs
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTypeSongsFailed:) name:NotificationNameGetTypeSongsFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTypeSongsSuccess:) name:NotificationNameGetTypeSongsSuccess object:nil];
        
        //setUserPos
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserPosFailed:) name:NotificationNameSetUserPosFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setUserPosSuccess:) name:NotificationNameSetUserPosSuccess object:nil];
        
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
    
    //getTypeSongs
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetTypeSongsFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetTypeSongsSuccess object:nil];
    
    //setUserPos
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameSetUserPosFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameSetUserPosSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _rootNavMenuView = [[RootNavigationMenuView alloc] initRootNavigationMenuView:CGRectMake(0, 0, 320, 44)];
    [_rootNavMenuView.btnMenuFirst addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuSecond addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuThird addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rootNavMenuView];
    
    //缓存view
    _dicViewControllerCache = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self segmentAction:_rootNavMenuView.btnMenuFirst];
    
    //
    _miglabAPI = [[MigLabAPI alloc] init];
    
    //gps
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    }
    
    //登录，获取用户资料
    //login
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    if (![UserSessionManager GetInstance].isLoggedIn) {
        
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
    
    //Once the view has loaded then we can register to begin recieving controls and we can become the first responder
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    //start gps
    [_locationManager startUpdatingLocation];
    
    //
    [self doUpdateView:_currentShowViewTag];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    if (!_isFirstDidAppear) {
        _isFirstDidAppear = YES;
        [SYAppStart hide:YES];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    //End recieving events
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    
    
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

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"RootViewController doPlayOrPause...");
    
    [[PPlayerManagerCenter GetInstance] doPlayOrPause];
    
}

-(IBAction)doNext:(id)sender{
    
    PLog(@"RootViewController doNext...");
    
    [[PPlayerManagerCenter GetInstance] doNext];
    
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
    
    [_rootNavMenuView setSelectedMenu:_currentShowViewTag - 100];
    [self doUpdateView:_currentShowViewTag];
    
}

-(void)doUpdateView:(int)viewtag{
    
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
                [oldGene viewWillAppear:YES];
                
            } else {
                
                GeneViewController *gene = [[GeneViewController alloc] initWithNibName:@"GeneViewController" bundle:nil];
                [gene setTopViewcontroller:self];
                [gene viewWillAppear:YES];
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
                [oldMusic viewWillAppear:YES];
                
            } else {
                
                MusicViewController *music = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
                [music setTopViewcontroller:self];
                [music viewWillAppear:YES];
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
                [oldFriend viewWillAppear:YES];
                
            } else {
                
                FriendViewController *friend = [[FriendViewController alloc] initWithNibName:@"FriendViewController" bundle:nil];
                [friend setTopViewcontroller:self];
                [friend viewWillAppear:YES];
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
    [UserSessionManager GetInstance].userid = user.userid;
    [UserSessionManager GetInstance].currentUser = user;
    [UserSessionManager GetInstance].isLoggedIn = YES;
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:0];
    
    [SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
    /*
    UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
    NSString *tmoodid = [NSString stringWithFormat:@"%d", usergene.mood.typeid];
    NSString *tsceneid = [NSString stringWithFormat:@"%d", usergene.scene.typeid];
    NSString *tchannelid = [NSString stringWithFormat:@"%@", usergene.channel.channelId];
    [_miglabAPI doGetTypeSongs:userid token:accesstoken moodid:tmoodid moodindex:@"0" sceneid:tsceneid sceneindex:@"0" channelid:tchannelid channelindex:@"0" num:@"5"];
    */
    
    //gene
    NSNumber *numGeneIndex = [NSNumber numberWithInt:100];
    GeneViewController *tempGene = [_dicViewControllerCache objectForKey:numGeneIndex];
    [tempGene loadTypeSongs];
    
    
    
    
}

//getTypeSongsFailed notification
-(void)getTypeSongsFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getTypeSongsFailed...%@", [result objectForKey:@"msg"]);
    [SVProgressHUD showErrorWithStatus:@"根据纬度获取歌曲失败:("];
    
}

-(void)getTypeSongsSuccess:(NSNotification *)tNotification{
    
    PLog(@"getModeMusicSuccess...");
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *songInfoList = [result objectForKey:@"result"];
    [[PDatabaseManager GetInstance] insertSongInfoList:songInfoList];
    
    NSMutableArray *tempsonglist = [[PDatabaseManager GetInstance] getSongInfoList:20];
    [[PPlayerManagerCenter GetInstance].songList addObjectsFromArray:tempsonglist];
    
    [SVProgressHUD showErrorWithStatus:@"根据纬度获取歌曲成功:)"];
    
}

//setUserPos
-(void)setUserPosFailed:(NSNotification *)tNotification{
    
    PLog(@"setUserPosFailed...");
    
}

-(void)setUserPosSuccess:(NSNotification *)tNotification{
    
    PLog(@"setUserPosSuccess...");
    
}

#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    PLog(@"[newLocation description]: %@", [newLocation description]);
    
    //取得经纬度
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CLLocationDegrees gLatitude = coordinate.latitude;
    CLLocationDegrees GLongitude = coordinate.longitude;
    NSString *strLatitude = [NSString stringWithFormat:@"%g", gLatitude];
    NSString *strLongitude = [NSString stringWithFormat:@"%g", GLongitude];
    NSLog(@"strLatitude: %@, strLongitude: %@", strLatitude, strLongitude);
    
    [_locationManager stopUpdatingLocation];
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *strLocation = [NSString stringWithFormat:@"%@,%@", strLatitude, strLongitude];
        
        [_miglabAPI doSetUserPos:userid token:accesstoken location:strLocation];
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    PLog(@"locationManager didFailWithError: %@", [error localizedDescription]);
}

@end
