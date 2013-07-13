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

@synthesize lblSongInfo = _lblSongInfo;
@synthesize showInfoPageControl = _showInfoPageControl;

@synthesize cdOfSongView = _cdOfSongView;
@synthesize ivCircleProcess = _ivCircleProcess;
@synthesize btnPlayProcessPoint = _btnPlayProcessPoint;
@synthesize isDraging = _isDraging;
@synthesize lastAngle = _lastAngle;

@synthesize cdOfSongEGOImageButton = _cdOfSongEGOImageButton;
@synthesize lrcOfSongTextView = _lrcOfSongTextView;

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
    [self doUpdateProcess];
    
}

//显示正在播放图标
-(void)doUpdatePlayingTip{
    
    long currentTime = _aaMusicPlayer.getCurrentTime;
    int rnd = currentTime % 7;//random() % 4;
    NSString *playingTipImageName = [NSString stringWithFormat:@"playing_tip_%d", rnd];
    _topPlayerInfoView.showPlayingImageView.image = [UIImage imageWithName:playingTipImageName type:@"png"];
    
}

//根据圆圈的比率，刷新圆盘进度
-(void)doUpdateProcess{
    
    long duration = _aaMusicPlayer.getDuration;
    long currentTime = _aaMusicPlayer.getCurrentTime;
    float playProcess = (duration > 0) ? (float)currentTime / (float)duration : 0;
    
    [self updateProcess:playProcess];
    
}

-(void)updateProcess:(float)processRate{
    
    if (processRate <= 0.01) {
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
