//
//  DetailPlayerViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "DetailPlayerViewController.h"
#import "PPlayerManagerCenter.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UserSessionManager.h"
#import "SVProgressHUD.h"
#import "PDatabaseManager.h"
#import "ShareChooseView.h"

@interface DetailPlayerViewController ()

@end

@implementation DetailPlayerViewController

@synthesize topPlayerInfoView = _topPlayerInfoView;

@synthesize lblSongInfo = _lblSongInfo;

@synthesize cdOfSongView = _cdOfSongView;

@synthesize bottomPlayerMenuView = _bottomPlayerMenuView;

@synthesize playerTimer = _playerTimer;
@synthesize checkUpdatePlayProcess = _checkUpdatePlayProcess;

//分享选择
@synthesize shareAchtionSheet = _shareAchtionSheet;

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
    
    self.navView.hidden = YES;
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, -20, kMainScreenWidth, 44)];
    [_topPlayerInfoView.btnMenu addTarget:self action:@selector(doShowMenuViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPlayerInfoView.btnShare addTarget:self action:@selector(doShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topPlayerInfoView];
    
    //song info label
    _lblSongInfo = [[UILabel alloc] init];
    _lblSongInfo.frame = CGRectMake(0, 70, kMainScreenWidth, 21);
    _lblSongInfo.backgroundColor = [UIColor clearColor];
    _lblSongInfo.textAlignment = kTextAlignmentCenter;
    _lblSongInfo.textColor = [UIColor whiteColor];
    _lblSongInfo.shadowOffset = CGSizeMake(0, 1);
    _lblSongInfo.text = @"乐瑟 - 无敌仙曲";
    _lblSongInfo.font = [UIFont systemFontOfSize:20.0f];
    [self.view addSubview:_lblSongInfo];
    
    //song of cd view
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayBodyView" owner:self options:nil];
    for (id oneObject in nib){
        if ([oneObject isKindOfClass:[PlayBodyView class]]){
            _cdOfSongView = (PlayBodyView *)oneObject;
        }//if
    }//for
    _cdOfSongView.frame = CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight - 100 - 90);
    
    _cdOfSongView.coverOfSongEGOImageView.tag = 2000;
    _cdOfSongView.coverOfSongEGOImageView.delegate = self;
    _cdOfSongView.coverOfSongEGOImageView.layer.cornerRadius = 98;
    _cdOfSongView.coverOfSongEGOImageView.layer.masksToBounds = YES;
    
    _cdOfSongView.btnCdOfSong.layer.cornerRadius = 98;
    _cdOfSongView.btnCdOfSong.layer.masksToBounds = YES;
    _cdOfSongView.btnCdOfSong.adjustsImageWhenHighlighted = NO;
    [_cdOfSongView.btnCdOfSong addTarget:self action:@selector(doPlayOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _cdOfSongView.lrcOfSongTextView.hidden = YES;
    
    //初始化进度指示
    [_cdOfSongView updateProcess:0.01];
    
    [self.view addSubview:_cdOfSongView];
    
    //bottom
    _bottomPlayerMenuView = [[PCustomPlayerMenuView alloc] initPlayerMenuView:CGRectMake(0, kMainScreenHeight - 90, 320, 90)];
    [_bottomPlayerMenuView.btnRemove addTarget:self action:@selector(doDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnLike addTarget:self action:@selector(doCollectAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomPlayerMenuView];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //doHateSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongFailed:) name:NotificationNameHateSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hateSongSuccess:) name:NotificationNameHateSongSuccess object:nil];
    
    //doCollectSong
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongFailed:) name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectSongSuccess:) name:NotificationNameCollectSongSuccess object:nil];
    
    //data
    [self initSongInfo];
    
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

-(IBAction)doShowMenuViewAction:(id)sender{
    
    PLog(@"doShowMenuViewAction...");
    
    [self timerStop];
    
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)doShareAction:(id)sender{
    
    PLog(@"doShareAction...");
    
    _shareAchtionSheet = [[UIActionSheet alloc] initWithTitle:@"\n\n\n\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    ShareChooseView *shareSelectedView = [[ShareChooseView alloc] initShareChooseView];
    [shareSelectedView.btnFirst addTarget:self action:@selector(doGotoShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareSelectedView.btnSecond addTarget:self action:@selector(doGotoShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareSelectedView.btnThird addTarget:self action:@selector(doGotoShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareSelectedView.btnFour addTarget:self action:@selector(doGotoShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareSelectedView.btnFive addTarget:self action:@selector(doGotoShareView:) forControlEvents:UIControlEventTouchUpInside];
    [shareSelectedView.btnSix addTarget:self action:@selector(doGotoShareView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_shareAchtionSheet addSubview:shareSelectedView];
    
    [_shareAchtionSheet showInView:self.view];
    
}

-(IBAction)doGotoShareView:(id)sender{
    
    UIButton *btnShare = sender;
    PLog(@"btnShare.tag: %d", btnShare.tag);
    
    switch (btnShare.tag) {
        case 201:
        {
            //qqzone
            
        }
            break;
        case 202:
        {
            //sinaweibo
            
        }
            break;
        case 203:
        {
            //weixin
            
        }
            break;
        case 204:
        {
            //tencentweibo
            
        }
            break;
        case 205:
        {
            //renren
            
        }
            break;
        case 206:
        {
            //sms
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    PLog(@"actionSheet clickedButtonAtIndex: %d", buttonIndex);
}

-(IBAction)doDeleteAction:(id)sender{
    
    PLog(@"DetailPlayerViewController doDeleteAction...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
        [_miglabAPI doHateSong:userid token:accesstoken sid:currentSong.songid];
        
        int currentSongIndex = [PPlayerManagerCenter GetInstance].currentSongIndex;
        [[PPlayerManagerCenter GetInstance].songList removeObjectAtIndex:currentSongIndex];
        [[PDatabaseManager GetInstance] deleteSongInfo:currentSong.songid];
        [self doNextAction:nil];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    
}

-(IBAction)doCollectAction:(id)sender{
    
    PLog(@"DetailPlayerViewController doCollectAction...");
    
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
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    
}

-(IBAction)doPlayOrPauseAction:(id)sender{
    
    PLog(@"DetailPlayerViewController doPlayOrPauseAction...");
    
    [[PPlayerManagerCenter GetInstance] doPlayOrPause];
    
    [self initSongInfo];
    
}

-(IBAction)doNextAction:(id)sender{
    
    PLog(@"DetailPlayerViewController doNextAction...");
    
    [[PPlayerManagerCenter GetInstance] doNext];
    
    [self initSongInfo];
    
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

-(void)initSongInfo{
    
    UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
    _topPlayerInfoView.lblPlayingSongInfo.text = usergene.type.desc;
    
    Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
    _lblSongInfo.text = [NSString stringWithFormat:@"%@ - %@", currentSong.artist, currentSong.songname];
    _cdOfSongView.coverOfSongEGOImageView.imageURL = [NSURL URLWithString:currentSong.coverurl];
    
//    _cdOfSongView.lrcOfSongTextView.text = usergene.scene.desc;
    
    [self timerStart];
    
}

-(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:currentSong.songname forKey:MPMediaItemPropertyTitle];
        [dict setObject:currentSong.artist forKey:MPMediaItemPropertyArtist];
        MPMediaItemArtwork * mArt = [[MPMediaItemArtwork alloc] initWithImage:_cdOfSongView.coverOfSongEGOImageView.image];
        [dict setObject:mArt forKey:MPMediaItemPropertyArtwork];
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
    }
    
}

//播放时间刷新
-(void)timerStop{
    
    @synchronized(self){
        if (_playerTimer) {
            if ([_playerTimer isValid]) {
                [_playerTimer invalidate];
            }
            _playerTimer = nil;
        }
    }
    
}

-(void)timerStart{
    
    [self timerStop];
    _playerTimer = [NSTimer scheduledTimerWithTimeInterval:PlayerTimerFunctionInterval target:self selector:@selector(playerTimerFunction) userInfo:nil repeats:YES];
    
}

-(void)playerTimerFunction{

//    PLog(@"playerTimerFunction...");
    
    //更新播放信息
    [self doUpdateForPlaying];
    
}

//播放时刷新所有对于view的数据
-(void)doUpdateForPlaying{
    
    [_topPlayerInfoView doUpdatePlayingTip];
    [_cdOfSongView doRotateSongCover];
    [self doUpdateProcess];
    
}

//根据圆圈的比率，刷新圆盘进度
-(void)doUpdateProcess{
    
    if (_checkUpdatePlayProcess < 10) {
        _checkUpdatePlayProcess++;
        return;
    }
    _checkUpdatePlayProcess = 0;
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    long duration = aaMusicPlayer.getDuration;
    long currentTime = aaMusicPlayer.getCurrentTime;
    float playProcess = (duration > 0) ? (float)currentTime / (float)duration : 0;
    
    [_cdOfSongView updateProcess:playProcess];
    
    //如果未播放就停止
    if (![aaMusicPlayer isMusicPlaying]) {
        [self timerStop];
    }
    
}

#pragma EGOImageViewDelegate
- (void)imageViewLoadedImage:(EGOImageView*)imageView{
    
}

- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error{
    
}

#pragma EGOImageButtonDelegate
- (void)imageButtonLoadedImage:(EGOImageButton*)imageButton{
    
}

- (void)imageButtonFailedToLoadImage:(EGOImageButton*)imageButton error:(NSError*)error{
    
}

@end
