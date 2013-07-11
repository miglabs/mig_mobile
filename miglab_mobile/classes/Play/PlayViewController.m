//
//  PlayViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayViewController.h"
#import "UIImage+PImageCategory.h"
#import "PCommonUtil.h"
#import "AppDelegate.h"
#import "MigLabAPI.h"
#import "Song.h"
#import "SongDownloadManager.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize backgroundEGOImageView = _backgroundEGOImageView;
@synthesize topPlayerInfoView = _topPlayerInfoView;
@synthesize songInfoScrollView = _songInfoScrollView;
@synthesize showInfoPageControl = _showInfoPageControl;

@synthesize cdOfSongView = _cdOfSongView;
@synthesize lblSongInfo = _lblSongInfo;
@synthesize ivCircleProcess = _ivCircleProcess;
@synthesize ivPlayProcessPoint = _ivPlayProcessPoint;
@synthesize cdOfSongEGOImageButton = _cdOfSongEGOImageButton;

@synthesize aaMusicPlayer = _aaMusicPlayer;
@synthesize aMusicPlayer = _aMusicPlayer;

@synthesize bottomPlayerMenuView = _bottomPlayerMenuView;

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
    
    FRAMELOG(self.view);
    
    //screen height
    float height = [UIScreen mainScreen].bounds.size.height;
    PLog(@"height: %f", height);
    
    UIImage *defaultBackgroundImage = [UIImage imageWithName:@"cd_pic_0" type:@"png"];
    _backgroundEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultBackgroundImage];
    _backgroundEGOImageView.frame = CGRectMake(0, -20, 320, height + 20);
    [self.view addSubview:_backgroundEGOImageView];
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, -20, 320, 44)];
    [_topPlayerInfoView.btnMenu addTarget:self action:@selector(doShowLeftViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPlayerInfoView.btnShare addTarget:self action:@selector(doShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_topPlayerInfoView];
    
    //song info
    _songInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320 * 2, height - 20 - 44 - 90)];
    _songInfoScrollView.scrollEnabled = YES;
    _songInfoScrollView.showsHorizontalScrollIndicator = NO;
    _songInfoScrollView.pagingEnabled = YES;
    _songInfoScrollView.delegate = self;
    
    //song of cd view
    UIImageView *cdImageView = [[UIImageView alloc] init];
    cdImageView.frame = CGRectMake(0, 0, 320, height - 20 - 44 - 90);
    
    [self.view addSubview:_songInfoScrollView];
    
    //song of page
    _showInfoPageControl = [[UIPageControl alloc] init];
    _showInfoPageControl.frame = CGRectMake(0, 60, 320, 16);
    _showInfoPageControl.numberOfPages = 2;
    _showInfoPageControl.currentPage = 0;
    _showInfoPageControl.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showInfoPageControl];
    
    //bottom
    _bottomPlayerMenuView = [[PCustomPlayerMenuView alloc] initPlayerMenuView:CGRectMake(0, height - 20 - 90, 320, 90)];
    [_bottomPlayerMenuView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomPlayerMenuView];
    
    //download
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:NotificationNameDownloadFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProcess:) name:NotificationNameDownloadProcess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:NotificationNameDownloadSuccess object:nil];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doShowLeftViewAction:(id)sender{
    
    PLog(@"doShowLeftViewAction...");
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] menuController] showLeftController:YES];
    
}

-(IBAction)doShareAction:(id)sender{
    
    PLog(@"doShareAction...");
    
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

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
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
                _aaMusicPlayer.delegate = self;
                [_aaMusicPlayer play];
            }
            
        } else {
            
            [_aaMusicPlayer playerPlayPause];
            
        }
        
    }
    
}

//根据圆圈的比率，刷新圆盘进度
-(void)updateProcess:(float)processRate{
    
    if (processRate <= 0.01) {
        processRate = 0.01;
    }
    
    float width = 213.0f;
    float height = 213.0f;
    CGSize imageSize = CGSizeMake(width, height);
    //半径
    CGFloat radius = MIN(height, width) / 2 - 10;
    //扇形开始角度
    CGFloat radians = DEGREES_2_RADIANS((processRate * 359.9) - 90);
    CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
    CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
    
    //金属圆点
    CGRect processPointFrame = _ivPlayProcessPoint.frame;
    processPointFrame.origin.x = xOffset + 72 - (processPointFrame.size.width/2);
    processPointFrame.origin.y = yOffset + 90 -  (processPointFrame.size.height/2);
    _ivPlayProcessPoint.frame = processPointFrame;
    
    //圆盘
    UIImage *circleProcess = [UIImage imageWithName:@"progress_line" type:@"png"];
    UIImage *processMask = [PCommonUtil getCircleProcessImageWithNoneAlpha:imageSize progress:processRate];
    UIImage *currentProcessImage = [PCommonUtil maskImage:circleProcess withImage:processMask];
    _ivCircleProcess.image = currentProcessImage;
    
}

-(IBAction)doRemoveAction:(id)sender{
    
    PLog(@"doRemoveAction...");
    
}

-(IBAction)doLikeAction:(id)sender{
    
    PLog(@"doLikeAction...");
    
}

-(IBAction)doNextAction:(id)sender{
    
    PLog(@"doNextAction...");
    
}

#pragma PMusicPlayerDelegate
//PAAMusicPlayer
-(void)aaMusicPlayerTimerFunction{
    
    long duration = _aaMusicPlayer.getDuration;
    long currentTime = _aaMusicPlayer.getCurrentTime;
    float playProcess = (duration > 0) ? (float)currentTime / (float)duration : 0;
    [self updatePlayingProcess:playProcess];
    
}

-(void)aaMusicPlayerStoped{
    
}

//PAMusicPlayer
-(void)aMusicPlayerTimerFunction{
    
}

-(void)aMusicPlayerStoped{
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _showInfoPageControl.currentPage = page;
    
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
