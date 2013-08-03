//
//  PlayViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayViewController.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PCommonUtil.h"
#import "AppDelegate.h"
#import "MigLabAPI.h"
#import "Song.h"
#import "SongDownloadManager.h"
#import "PDatabaseManager.h"

#define SONG_INIT_SIZE 3000

#define ROTATE_ANGLE 0.01//0.026526
//计算角度旋转
//static CGFloat Rotate_Angle = 15 *(M_2_PI/360);

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize backgroundEGOImageView = _backgroundEGOImageView;
@synthesize topPlayerInfoView = _topPlayerInfoView;
@synthesize playingTipIndex = _playingTipIndex;

@synthesize songInfoScrollView = _songInfoScrollView;

@synthesize lblSongInfo = _lblSongInfo;
@synthesize showInfoPageControl = _showInfoPageControl;

@synthesize cdOfSongView = _cdOfSongView;
@synthesize ivCircleProcess = _ivCircleProcess;
@synthesize coverOfSongEGOImageView = _coverOfSongEGOImageView;
@synthesize cdCenterImageView = _cdCenterImageView;
@synthesize cdOfSongEGOImageButton = _cdOfSongEGOImageButton;
@synthesize btnPlayProcessPoint = _btnPlayProcessPoint;
@synthesize isDraging = _isDraging;
@synthesize lastAngle = _lastAngle;

@synthesize lrcOfSongTextView = _lrcOfSongTextView;

@synthesize aaMusicPlayer = _aaMusicPlayer;
@synthesize aMusicPlayer = _aMusicPlayer;

@synthesize bottomPlayerMenuView = _bottomPlayerMenuView;

@synthesize songList = _songList;
@synthesize currentSongIndex = _currentSongIndex;
@synthesize currentSong = _currentSong;
@synthesize shouldStartPlayAfterDownloaded = _shouldStartPlayAfterDownloaded;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _playingTipIndex = random() % 7;
        _shouldStartPlayAfterDownloaded = YES;
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
    
//    UIImage *defaultBackgroundImage = [UIImage imageWithName:@"cd_pic_0" type:@"png"];
    UIImage *defaultBackgroundImage = [UIImage imageWithName:@"bg_mask_2" type:@"png"];
    _backgroundEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultBackgroundImage];
    _backgroundEGOImageView.frame = CGRectMake(0, -20, 320, height + 20);
    [self.view addSubview:_backgroundEGOImageView];
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, -20, 320, 44)];
    [_topPlayerInfoView.btnMenu addTarget:self action:@selector(doShowLeftViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPlayerInfoView.btnShare addTarget:self action:@selector(doShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topPlayerInfoView];
    
    //song info label
    _lblSongInfo = [[UILabel alloc] init];
    _lblSongInfo.frame = CGRectMake(0, 60, 320, 21);
    _lblSongInfo.backgroundColor = [UIColor clearColor];
    _lblSongInfo.textAlignment = kTextAlignmentCenter;
    _lblSongInfo.textColor = [UIColor whiteColor];
    _lblSongInfo.shadowOffset = CGSizeMake(0, 1);
    _lblSongInfo.text = @"乐瑟 - 无敌仙曲";
    [self.view addSubview:_lblSongInfo];
    
    //song of page
    _showInfoPageControl = [[PCustomPageControl alloc] init];
    _showInfoPageControl.backgroundColor = [UIColor clearColor];
    _showInfoPageControl.frame = CGRectMake(0, 90, 320, 15);
    _showInfoPageControl.numberOfPages = 2;
    _showInfoPageControl.currentPage = 0;
    _showInfoPageControl.imagePageStateNormal = [UIImage imageWithName:@"page_nor" type:@"png"];
    _showInfoPageControl.imagePageStateHighlighted = [UIImage imageWithName:@"page_sel" type:@"png"];
    [self.view addSubview:_showInfoPageControl];
    
    //song info
    _songInfoScrollView = [[UIScrollView alloc] init];
    _songInfoScrollView.backgroundColor = [UIColor clearColor];
    _songInfoScrollView.frame = CGRectMake(0, 100, 320, height - 20 - 100 - 90);
    _songInfoScrollView.scrollEnabled = YES;
    _songInfoScrollView.showsHorizontalScrollIndicator = NO;
    _songInfoScrollView.pagingEnabled = YES;
    _songInfoScrollView.delegate = self;
    _songInfoScrollView.contentSize = CGSizeMake(320 * 2, height - 20 - 100 - 90);
    
    //song of cd view
    
    //cd of sone player
    _cdOfSongView.frame = CGRectMake(0, 0, 320, height - 20 - 100 - 90);
//    _cdOfSongView.backgroundColor = [UIColor redColor];
    
    _coverOfSongEGOImageView.layer.cornerRadius = 98;
    _coverOfSongEGOImageView.layer.masksToBounds = YES;
    
    _cdOfSongEGOImageButton.layer.cornerRadius = 98;
    _cdOfSongEGOImageButton.layer.masksToBounds = YES;
    _cdOfSongEGOImageButton.adjustsImageWhenHighlighted = NO;
    
//    CGSize imageSize = _cdOfSongEGOImageButton.frame.size;
//    UIImage *defaultSongCover = [UIImage imageWithName:@"song_cover" type:@"png"];
//    defaultSongCover = [UIImage createRoundedRectImage:defaultSongCover size:imageSize radius:imageSize.width / 2];
//    [_cdOfSongEGOImageButton setImage:defaultSongCover forState:UIControlStateNormal];
//    _cdOfSongEGOImageButton.adjustsImageWhenHighlighted = NO;
    
    [self updateProcess:0.01];
    
    [_songInfoScrollView addSubview:_cdOfSongView];
    
    [_btnPlayProcessPoint addTarget:self action:@selector(doDragBegin:withEvent:) forControlEvents:UIControlEventTouchDown];
    [_btnPlayProcessPoint addTarget:self action:@selector(doDragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_btnPlayProcessPoint addTarget:self action:@selector(doDragEnd:withEvent:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    //lrc of song layer
    //todo
    
    [self.view addSubview:_songInfoScrollView];
    
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
    
    //song list
    _songList = [[NSMutableArray alloc] init];
    _currentSongIndex = 0;
    
    _aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    
    Song *song0 = [[Song alloc] init];
    song0.songid = 346630;
    song0.songname = @"寂寞";
    song0.artist = @"谢容儿";
    song0.songurl = @"http://umusic.9158.com/2013/07/14/14/14/346630_3cd4dbc8abde417c83cd9261f50bdb4c.mp3";
    song0.coverurl = @"http://upic.9158.com/2013/07/12/12/31/20130712123159_img1008690313.jpg";
    song0.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    song0.songCachePath = [songManager getSongCachePath:song0];
    [_songList addObject:song0];
    
    Song *song1 = [[Song alloc] init];
    song1.songid = 314001;
    song1.songname = @"黄梅戏";
    song1.artist = @"慕容晓晓";
    song1.songurl = @"http://umusic.9158.com/2013/07/06/09/21/314001_a2e7fbfef7bd448e9349a3becfdea19e.mp3";
    song1.coverurl = @"http://upic.9158.com/2013/07/07/05/49/20130707054950_img1008690313.jpg";
    song1.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    song1.songCachePath = [songManager getSongCachePath:song1];
    [_songList addObject:song1];
    
    Song *song2 = [[Song alloc] init];
    song2.songid = 284711;
    song2.songname = @"青春纪念册";
    song2.artist = @"G_voice家族";
    song2.songurl = @"http://umusic.9158.com/2013/06/29/16/35/284711_abbf9d95fcbe42a486e86d4281881e0a.mp3";
    song2.coverurl = @"http://upic.9158.com/2013/07/05/07/16/20130705071624_img1008690313.jpg";
    song2.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    song2.songCachePath = [songManager getSongCachePath:song2];
    [_songList addObject:song2];
    
    Song *song3 = [[Song alloc] init];
    song3.songid = 267654;
    song3.songname = @"你是我的眼";
    song3.artist = @"萧煌奇";
    song3.songurl = @"http://umusic.9158.com/2013/06/24/23/40/267654_c281b790308e41d2966b24cf56838c0e.mp3";
    song3.whereIsTheSong = WhereIsTheSong_IN_CACHE;
    song3.songCachePath = [songManager getSongCachePath:song3];
    [_songList addObject:song3];
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
//    [miglabAPI doGetDefaultMusic:<#(NSString *)#> token:<#(NSString *)#> uid:<#(int)#>]
    
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
    
    //播放下一首
    [self doNextAction:nil];
    
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
            
            long long totalBytesExpectedToRead = [dicProcess objectForKey:@"TotalBytesExpectedToRead"];
            [databaseManager setSongMaxSize:_currentSong.songid type:songext fileMaxSize:totalBytesExpectedToRead];
            
        }
        
        //
        SongDownloadManager *songManager = [SongDownloadManager GetInstance];
        long long localsize = [songManager getSongLocalSize:_currentSong];
        if (localsize < SONG_INIT_SIZE) {
            //
            
        } else {
            
            if (![_aaMusicPlayer isMusicPlaying] && _shouldStartPlayAfterDownloaded) {
                _shouldStartPlayAfterDownloaded = NO;
                [self initAndStartPlayer];
            }
        
            
        }
        
    }
    
}

-(void)downloadSuccess:(NSNotification *)tNotification{
    PLog(@"downloadSuccess...");
}

-(void)stopDownload{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager downloadPause];
    
    _shouldStartPlayAfterDownloaded = YES;
    
}

-(void)initSongInfo{
    
    _lblSongInfo.text = [NSString stringWithFormat:@"%@ - %@", _currentSong.songname, _currentSong.artist];
    
    [self downloadSong];
    
}

-(void)downloadSong{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    float rate = [songManager getSongProgress:_currentSong];
    if (rate >= 1) {
        
        [self initAndStartPlayer];
        
    } else {
        
        [songManager downloadStart:_currentSong delegate:nil];
        
    }
    
}

-(void)initAndStartPlayer{
    
    if (_aaMusicPlayer && [_aaMusicPlayer isMusicPlaying]) {
        return;
    }
    
    PLog(@"initAndStartPlayer...");
    
    _aaMusicPlayer.song = _currentSong;
    
    BOOL isPlayerInit = [_aaMusicPlayer initPlayer];
    if (isPlayerInit) {
        _aaMusicPlayer.delegate = self;
        [_aaMusicPlayer play];
    }
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _showInfoPageControl.currentPage = page;
    
}

#pragma UIScrollViewDelegate end

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    [self playLocationSong];
    
}

-(void)playLocationSong{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"qhc" ofType:@"caf"];
    BOOL fileexit = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileexit) {
        
        Song *tempSong = [[Song alloc] init];
        tempSong.songurl = filepath;
        tempSong.whereIsTheSong = WhereIsTheSong_IN_APP;
        
        _aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        
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

-(IBAction)doDragBegin:(UIControl *)c withEvent:ev{
    
    CGPoint beginPoint = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"dragBegin beginPoint.x: %f, beginPoint.y: %f", beginPoint.x, beginPoint.y);
    
    _isDraging = YES;
    _lastAngle = [self angleBetweenCenterAndPoint:beginPoint];
    
}

-(IBAction)doDragMoving:(UIControl *)c withEvent:ev{
    
    CGPoint movePoint = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"dragMoving movePoint.x: %f, movePoint.y: %f", movePoint.x, movePoint.y);
    
    CGFloat delta = [self angleBetweenCenterAndPoint:movePoint] - _lastAngle;
    
    if (fabsf(delta) > (2*M_PI)-fabsf(delta)) {
        BOOL greaterThanZero = (delta > 0);
        delta = (2*M_PI)-fabsf(delta);
        if (greaterThanZero) {
            delta = -1 * delta;
        }
    }
    
    _lastAngle = [self angleBetweenCenterAndPoint:movePoint];
    
    [self movePlayProcessPointToPosition:[self angleBetweenCenterAndPoint:movePoint]];
    
}

-(IBAction)doDragEnd:(UIControl *)c withEvent:ev{
    
    CGPoint endPoint = [[[ev allTouches] anyObject] locationInView:self.view];
    NSLog(@"dragEnd endPoint.x: %f, endPoint.y: %f", endPoint.x, endPoint.y);
    
    _isDraging = NO;
    
}

#pragma mark - Math Helper methods
-(CGFloat)angleBetweenCenterAndPoint:(CGPoint)point {
    
    CGPoint center = CGPointMake(160.0f, 100.0f + 20.0f + 100.0f);
    CGFloat origAngle = atan2f(center.y - point.y, point.x - center.x);
    
    //Translate to Unit circle
    if (origAngle > 0) {
        origAngle = (M_PI - origAngle) + M_PI;
    } else {
        origAngle = fabsf(origAngle);
    }
    
    //Rotating so "origin" is at "due north/Noon", I need to stop mixing metaphors
    origAngle = fmodf(origAngle+(M_PI/2), 2*M_PI);
    NSLog(@"origAngle: %f", origAngle);
    
    return origAngle;
}

- (void)movePlayProcessPointToPosition:(CGFloat)angle {
    
    CGRect rect = _btnPlayProcessPoint.frame;
    CGPoint center = CGPointMake(160.0f, 100.0f + 20.0f + 100.0f);
    angle -= (M_PI/2);
    
    rect.origin.x = center.x + 75 * cosf(angle) - (rect.size.width/2);
    rect.origin.y = center.y + 75 * sinf(angle) - (rect.size.height/2);
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    _btnPlayProcessPoint.frame = rect;
    
    [CATransaction commit];
}

#pragma PMusicPlayerDelegate
//PAAMusicPlayer
-(void)aaMusicPlayerTimerFunction{
    
    [self doUpdateForPlaying];
    
}

-(void)aaMusicPlayerStoped{
    
}

//PAMusicPlayer
-(void)aMusicPlayerTimerFunction{
    
    [self doUpdateForPlaying];
    
}

-(void)aMusicPlayerStoped{
    
}

#pragma PMusicPlayerDelegate end

//播放时刷新所有对于view的数据
-(void)doUpdateForPlaying{
    
    [self doUpdatePlayingTip];
    [self doRotateSongCover];
    [self doUpdateProcess];
    
}

//显示正在播放图标
-(void)doUpdatePlayingTip{
    
    _playingTipIndex++;
    _playingTipIndex = _playingTipIndex % 7;
    
    NSString *playingTipImageName = [NSString stringWithFormat:@"playing_tip_%d", _playingTipIndex];
    _topPlayerInfoView.showPlayingImageView.image = [UIImage imageWithName:playingTipImageName type:@"png"];
    
}

//旋转歌曲封面
-(void)doRotateSongCover{
    
    CGAffineTransform transformTmp = _coverOfSongEGOImageView.transform;
    transformTmp = CGAffineTransformRotate(transformTmp, ROTATE_ANGLE);
    _coverOfSongEGOImageView.transform = transformTmp;
    
}

//根据圆圈的比率，刷新圆盘进度
-(void)doUpdateProcess{
    
    long duration = _aaMusicPlayer.getDuration;
    long currentTime = _aaMusicPlayer.getCurrentTime;
    float playProcess = (duration > 0) ? (float)currentTime / (float)duration : 0;
    
    [self updateProcess:playProcess];
    
}

-(void)updateProcess:(float)processRate{
    
    if (processRate < 0.01) {
        processRate = 0.01;
    }
    
    float width = 213.0f;
    float height = 213.0f;
    CGSize imageSize = CGSizeMake(width, height);
    
    //圆盘
    UIImage *circleProcess = [UIImage imageWithName:@"progress_line" type:@"png"];
    UIImage *processMask = [PCommonUtil getCircleProcessImageWithNoneAlpha:imageSize progress:processRate];
    UIImage *currentProcessImage = [PCommonUtil maskImage:circleProcess withImage:processMask];
    _ivCircleProcess.image = currentProcessImage;
    
    //圆点
    if (!_isDraging) {
        
        //半径
        CGFloat radius = MIN(height, width) / 2 + 10;
        //扇形开始角度
        CGFloat radians = DEGREES_2_RADIANS((processRate * 359.9) - 90);
        CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
        CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
        
        CGRect processPointFrame = _btnPlayProcessPoint.frame;
        processPointFrame.origin.x = xOffset + 45 - (processPointFrame.size.width/2);
        processPointFrame.origin.y = yOffset - (processPointFrame.size.height/2);
        _btnPlayProcessPoint.frame = processPointFrame;
    }
    
}

-(IBAction)doRemoveAction:(id)sender{
    
    PLog(@"doRemoveAction...");
    
}

-(IBAction)doLikeAction:(id)sender{
    
    PLog(@"doLikeAction...");
    
}

-(IBAction)doNextAction:(id)sender{
    
    PLog(@"doNextAction...");
    
    if (_songList && [_songList count] > 0) {
        
        _currentSongIndex = (_currentSongIndex + 1) % [_songList count];
        _currentSong = [_songList objectAtIndex:_currentSongIndex];
        
        [self stopDownload];
        
        if ([_aaMusicPlayer isMusicPlaying]) {
            [_aaMusicPlayer pause];
        }
        
        [self initSongInfo];
        
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
