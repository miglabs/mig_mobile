//
//  MainMenuViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PCommonUtil.h"
#import "SongDownloadManager.h"
#import "PDatabaseManager.h"
#import "UserSessionManager.h"
#import "SVProgressHUD.h"

#import "PPlayerManaerCenter.h"


#define SONG_INIT_SIZE 3000
#define ROTATE_ANGLE 0.01//0.026526

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

//播放页面
@synthesize playView = _playView;
@synthesize backgroundEGOImageView = _backgroundEGOImageView;
@synthesize topPlayerInfoView = _topPlayerInfoView;
@synthesize lblSongInfo = _lblSongInfo;
@synthesize showInfoPageControl = _showInfoPageControl;
@synthesize songInfoScrollView = _songInfoScrollView;
@synthesize cdOfSongView = _cdOfSongView;
@synthesize bottomPlayerMenuView = _bottomPlayerMenuView;

@synthesize cdEGOImageView = _cdEGOImageView;

//歌曲场景切换页面
@synthesize playerBoradView = _playerBoradView;

@synthesize isPlayViewShowing = _isPlayViewShowing;

@synthesize songList = _songList;
@synthesize currentSongIndex = _currentSongIndex;
@synthesize currentSong = _currentSong;
@synthesize shouldStartPlayAfterDownloaded = _shouldStartPlayAfterDownloaded;

@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isPlayViewShowing = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    FRAMELOG(self.view);
    
    //screen height
    PLog(@"kMainScreenHeight: %f", kMainScreenHeight);
    
    //doGetGuestInfo
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuestInfoFailed:) name:NotificationNameGetGuestFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuestInfoSuccess:) name:NotificationNameGetGuestSuccess object:nil];
    
    //login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
    
    //user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
    
    
    //构造场景选择页面
    [self initMenuView];
    
    //end 场景
    
    //构造播放页面
    [self initPlayView];
    
    //end 播放
    
    UIImage *defaultCover = [UIImage imageWithName:@"song_cover" type:@"png"];
    defaultCover = [UIImage createRoundedRectImage:defaultCover size:CGSizeMake(200, 200) radius:100];
    _cdEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultCover];
//    _cdEGOImageView.frame = CGRectMake(9, kMainScreenHeight - 50, 44, 44);
    _cdEGOImageView.frame = CGRectMake(62, 119, 196, 196);
    _cdEGOImageView.hidden = YES;
    [self.view addSubview:_cdEGOImageView];
    
    //download
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:NotificationNameDownloadFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadProcess:) name:NotificationNameDownloadProcess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadSuccess:) name:NotificationNameDownloadSuccess object:nil];
    
    //song list
    _songList = [[NSMutableArray alloc] init];
    _currentSongIndex = 0;
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
    //登录，获取用户资料
    [self initUserData];
    
    
    //test data
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
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)initMenuView{
    
    //bottom
    _playerBoradView = [[PCustomPlayerBoradView alloc] initPlayerBoradView:CGRectMake(0, kMainScreenHeight - 60, kMainScreenWidth, 60)];
    [_playerBoradView.btnAvatar addTarget:self action:@selector(doAvatarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerBoradView];
    
    
}

-(IBAction)doAvatarAction:(id)sender{
    
    //逆时针旋转
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnim.fromValue = [NSNumber numberWithFloat:0];
    transformAnim.toValue = [NSNumber numberWithFloat:2 * M_PI];
    transformAnim.duration = 0.3;
    transformAnim.autoreverses = NO;
    transformAnim.repeatCount = 2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:transformAnim, nil];
    animGroup.duration = 6;
    _cdEGOImageView.hidden = NO;
    [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
    
    //移动位置
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
        _cdEGOImageView.frame = CGRectMake(62, 119, 196, 196);
        
    } completion:^(BOOL finished) {
        
        _cdEGOImageView.hidden = YES;
        _cdOfSongView.coverOfSongEGOImageView.hidden = NO;
        
    }];
    
}

-(IBAction)doRemoveAction:(id)sender{
    
}

-(IBAction)doLikeAction:(id)sender{
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    [self playLocationSong];
    
}

-(IBAction)doNextAction:(id)sender{
    
    PLog(@"doNextAction...");
    
    if (_songList && [_songList count] > 0) {
        
        _currentSongIndex = (_currentSongIndex + 1) % [_songList count];
        _currentSong = [_songList objectAtIndex:_currentSongIndex];
        
        [self stopDownload];
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManaerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        if (aaMusicPlayer.isMusicPlaying) {
            [aaMusicPlayer pause];
        }
        
        [self initSongInfo];
        
    }
    
}

-(void)playLocationSong{
    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"qhc" ofType:@"caf"];
    BOOL fileexit = [[NSFileManager defaultManager] fileExistsAtPath:filepath];
    if (fileexit) {
        
        Song *tempSong = [[Song alloc] init];
        tempSong.songurl = filepath;
        tempSong.whereIsTheSong = WhereIsTheSong_IN_APP;
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManaerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        
        if (aaMusicPlayer.playerDestoried) {
            
            aaMusicPlayer.song = tempSong;
            
            BOOL isPlayerInit = [aaMusicPlayer initPlayer];
            if (isPlayerInit) {
                aaMusicPlayer.delegate = self;
                [aaMusicPlayer play];
            }
            
        } else {
            
            [aaMusicPlayer playerPlayPause];
            
        }
        
    }
    
}

//构造播放页面
-(void)initPlayView{
    
    //screen height
    PLog(@"kMainScreenHeight: %f", kMainScreenHeight);
    
    //构造播放页面
    _playView = [[UIView alloc] init];
    _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    
    //background view
    UIImage *defaultBackgroundImage = [UIImage imageWithName:@"bg_mask_2" type:@"png"];
    _backgroundEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultBackgroundImage];
    _backgroundEGOImageView.frame = CGRectMake(0, -20, kMainScreenWidth, kMainScreenHeight + 20);
    [_playView addSubview:_backgroundEGOImageView];
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, -20, kMainScreenWidth, 44)];
    [_topPlayerInfoView.btnMenu addTarget:self action:@selector(doShowMenuViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPlayerInfoView.btnShare addTarget:self action:@selector(doShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_topPlayerInfoView];
    
    //song info label
    _lblSongInfo = [[UILabel alloc] init];
    _lblSongInfo.frame = CGRectMake(0, 60, kMainScreenWidth, 21);
    _lblSongInfo.backgroundColor = [UIColor clearColor];
    _lblSongInfo.textAlignment = kTextAlignmentCenter;
    _lblSongInfo.textColor = [UIColor whiteColor];
    _lblSongInfo.shadowOffset = CGSizeMake(0, 1);
    _lblSongInfo.text = @"乐瑟 - 无敌仙曲";
    [_playView addSubview:_lblSongInfo];
    
    //song of page
    _showInfoPageControl = [[PCustomPageControl alloc] init];
    _showInfoPageControl.backgroundColor = [UIColor clearColor];
    _showInfoPageControl.frame = CGRectMake(0, 90, kMainScreenWidth, 15);
    _showInfoPageControl.numberOfPages = 2;
    _showInfoPageControl.currentPage = 0;
    _showInfoPageControl.imagePageStateNormal = [UIImage imageWithName:@"page_nor" type:@"png"];
    _showInfoPageControl.imagePageStateHighlighted = [UIImage imageWithName:@"page_sel" type:@"png"];
    [_playView addSubview:_showInfoPageControl];
    
    //song info
    _songInfoScrollView = [[UIScrollView alloc] init];
    _songInfoScrollView.backgroundColor = [UIColor clearColor];
    _songInfoScrollView.frame = CGRectMake(0, 100, kMainScreenWidth, kMainScreenHeight - 100 - 90);
    _songInfoScrollView.scrollEnabled = YES;
    _songInfoScrollView.showsHorizontalScrollIndicator = NO;
    _songInfoScrollView.pagingEnabled = YES;
    _songInfoScrollView.delegate = self;
    _songInfoScrollView.contentSize = CGSizeMake(kMainScreenWidth * 2, kMainScreenHeight - 100 - 90);
    
    //song of cd view
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PlayBodyView" owner:self options:nil];
    for (id oneObject in nib){
        if ([oneObject isKindOfClass:[PlayBodyView class]]){
            _cdOfSongView = (PlayBodyView *)oneObject;
        }//if
    }//for
    _cdOfSongView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight - 100 - 90);
    
    _cdOfSongView.coverOfSongEGOImageView.layer.cornerRadius = 98;
    _cdOfSongView.coverOfSongEGOImageView.layer.masksToBounds = YES;
    
    _cdOfSongView.btnCdOfSong.layer.cornerRadius = 98;
    _cdOfSongView.btnCdOfSong.layer.masksToBounds = YES;
    _cdOfSongView.btnCdOfSong.adjustsImageWhenHighlighted = NO;
    [_cdOfSongView.btnCdOfSong addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化进度指示
    [_cdOfSongView updateProcess:0.01];
    
    [_songInfoScrollView addSubview:_cdOfSongView];
    
    [_playView addSubview:_songInfoScrollView];
    
    //bottom
    _bottomPlayerMenuView = [[PCustomPlayerMenuView alloc] initPlayerMenuView:CGRectMake(0, kMainScreenHeight - 90, kMainScreenWidth, 90)];
    [_bottomPlayerMenuView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_bottomPlayerMenuView];
    
    //add view
    [self.view addSubview:_playView];
    
    //end 构造播放页面
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_playView addGestureRecognizer:panGestureRecognizer];
    
    
}

-(IBAction)doShowMenuViewAction:(id)sender{
    
    PLog(@"doShowMenuViewAction...");
    
    //逆时针旋转
    CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    transformAnim.fromValue = [NSNumber numberWithFloat:2 * M_PI];
    transformAnim.toValue = [NSNumber numberWithFloat:0];
    transformAnim.duration = 0.3;
    transformAnim.autoreverses = NO;
    transformAnim.repeatCount = 2;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:transformAnim, nil];
    animGroup.duration = 6;
    _cdEGOImageView.hidden = NO;
    _cdOfSongView.coverOfSongEGOImageView.hidden = YES;
    [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
    
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        _playView.frame = CGRectMake(320, 0, kMainScreenWidth, kMainScreenHeight);
        _cdEGOImageView.frame = CGRectMake(9, kMainScreenHeight - 50, 44, 44);
        
    } completion:^(BOOL finished) {
        
        _cdEGOImageView.hidden = YES;
        
    }];
    
}

-(IBAction)doShareAction:(id)sender{
    
    PLog(@"doShareAction...");
    
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_playView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
    
    NSLog(@"recognizer.view.center.x: %f, recognizer.view.center.y: %f", recognizer.view.center.x, recognizer.view.center.y);
    
    [recognizer setTranslation:CGPointZero inView:_playView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            
            if (recognizer.view.frame.origin.x > 50) {
                
                [self doShowMenuViewAction:nil];
                //                _playView.frame = CGRectMake(320, 0, kMainScreenWidth, kMainScreenHeight);
                
            } else {
                
                _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
                
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        //
        
    }
    
}

-(IBAction)doShowPlayViewAction:(id)sender{
    
//    float height = [UIScreen mainScreen].bounds.size.height;
    
    /*
     CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
     CGMutablePathRef aPath = CGPathCreateMutable();
     CGPathMoveToPoint(aPath, nil, 9, height - 20 - 50);
     CGPathAddQuadCurveToPoint(aPath, nil, 30, 100, 62, 119);
     animation.path = aPath;
     animation.duration = 0.7;
     */
    
    //    //路径曲线
    //    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //    CGMutablePathRef aPath = CGPathCreateMutable();
    //    CGPathMoveToPoint(aPath, nil, 9, height - 20 - 50);
    //    CGPathAddQuadCurveToPoint(aPath, nil, 60, 100, 62, 119);
    //    moveAnim.path = aPath;
    //    moveAnim.duration = 0.6;
    //    moveAnim.removedOnCompletion = YES;
    
    //    [_cdEGOImageView.layer addAnimation:moveAnim forKey:@"position"];
    
    /*
     CGPoint fromPoint = _cdEGOImageView.center;
     
     //路径曲线
     UIBezierPath *movePath = [UIBezierPath bezierPath];
     [movePath moveToPoint:fromPoint];
     CGPoint toPoint = CGPointMake(62, 119);
     [movePath addQuadCurveToPoint:toPoint
     controlPoint:CGPointMake(100, 0)];
     //关键帧
     CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     moveAnim.path = movePath.CGPath;
     moveAnim.duration = 0.6;
     moveAnim.removedOnCompletion = YES;
     
     //旋转变化
     CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     //沿Z轴旋转
     transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
     transformAnim.cumulative = YES;
     transformAnim.duration = 0.3;
     //旋转2遍，360度
     transformAnim.repeatCount = 2;
     transformAnim.removedOnCompletion = YES;
     
     //缩放
     CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"scale"];
     scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
     scaleAnim.duration = 0.6;
     scaleAnim.removedOnCompletion = YES;
     
     CAAnimationGroup *animGroup = [CAAnimationGroup animation];
     animGroup.animations = [NSArray arrayWithObjects:transformAnim, scaleAnim, nil];
     animGroup.duration = 6;
     [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
     */
    
    /*
     CGPoint fromPoint = _cdEGOImageView.center;
     
     //路径曲线
     UIBezierPath *movePath = [UIBezierPath bezierPath];
     [movePath moveToPoint:fromPoint];
     CGPoint toPoint = CGPointMake(62, 119);
     [movePath addQuadCurveToPoint:toPoint
     controlPoint:CGPointMake(62, 119)];
     //关键帧
     CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     moveAnim.path = movePath.CGPath;
     //    moveAnim.removedOnCompletion = YES;
     
     //旋转变化
     CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     //x，y轴缩小到0.1,Z 轴不变
     scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1.0)];
     //    scaleAnim.removedOnCompletion = YES;
     
     //透明度变化
     CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
     opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
     opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
     //    opacityAnim.removedOnCompletion = YES;
     
     //关键帧，旋转，透明度组合起来执行
     CAAnimationGroup *animGroup = [CAAnimationGroup animation];
     animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim,opacityAnim, nil];
     animGroup.duration = 1;
     [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
     */
    /*
     CGPoint fromPoint = _cdEGOImageView.center;
     UIBezierPath *movePath = [UIBezierPath bezierPath];
     [movePath moveToPoint:fromPoint];
     CGPoint toPoint = CGPointMake(fromPoint.x +100 , fromPoint.y ) ;
     [movePath addLineToPoint:toPoint];
     
     CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
     moveAnim.path = movePath.CGPath;
     
     CABasicAnimation *TransformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     TransformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     
     //沿Z轴旋转
     TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,0,1)];
     
     //沿Y轴旋转
     //   scaleAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,0,1.0,0)];
     
     //沿X轴旋转
     //     TransformAnim.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI,1.0,0,0)];
     TransformAnim.cumulative = YES;
     TransformAnim.duration = 0.6;
     //旋转2遍，360度
     TransformAnim.repeatCount =2;
     _cdEGOImageView.center = toPoint;
     TransformAnim.removedOnCompletion = YES;
     CAAnimationGroup *animGroup = [CAAnimationGroup animation];
     animGroup.animations = [NSArray arrayWithObjects:moveAnim, TransformAnim, nil];
     animGroup.duration = 0.6;
     */
    
    //    [_cdEGOImageView.layer addAnimation:animGroup forKey:nil];
    
    /*
     //用例3 scale+rotate+position
     CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
     CATransform3D rotateTransform = CATransform3DMakeRotation(1.57, 0, 0, -1);
     CATransform3D scaleTransform = CATransform3DMakeScale(5, 5, 5);
     CATransform3D positionTransform = CATransform3DMakeTranslation(0, 0, 0); //位置移动
     CATransform3D combinedTransform = CATransform3DConcat(rotateTransform, scaleTransform); //Concat就是combine的意思
     combinedTransform = CATransform3DConcat(combinedTransform, positionTransform); //再combine一次把三个动作连起来
     
     [anim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]]; //放在3D坐标系中最正的位置
     [anim setToValue:[NSValue valueWithCATransform3D:combinedTransform]];
     [anim setDuration:5.0f];
     
     [_cdEGOImageView.layer addAnimation:anim forKey:nil];
     
     [_cdEGOImageView.layer setTransform:combinedTransform];  //如果没有这句，layer执行完动画又会返回最初的state
     */
    
    /*
     //旋转变化
     CABasicAnimation *transformAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
     transformAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
     //沿Z轴旋转
     transformAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0, 0, 1)];
     transformAnim.cumulative = YES;
     transformAnim.duration = 0.3;
     //旋转2遍，360度
     transformAnim.repeatCount = 2;
     transformAnim.removedOnCompletion = YES;
     */
    
    
    
    //逆时针旋转
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.duration = 0.3;
    shake.autoreverses = NO;
    shake.repeatCount = 2;
    
    if (_isPlayViewShowing) {
        //逆时针旋转
        shake.fromValue = [NSNumber numberWithFloat:2 * M_PI];
        shake.toValue = [NSNumber numberWithFloat:0];
        
    } else {
        //顺时针旋转
        shake.fromValue = [NSNumber numberWithFloat:0];
        shake.toValue = [NSNumber numberWithFloat:2 * M_PI];
        
    }
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:shake, nil];
    animGroup.duration = 6;
    _cdEGOImageView.hidden = NO;
    [_cdEGOImageView.layer addAnimation:animGroup forKey:@"animGroup"];
    
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (_isPlayViewShowing) {
            
            _isPlayViewShowing = NO;
            
            _playView.frame = CGRectMake(320, 0, kMainScreenWidth, kMainScreenHeight);
            _cdEGOImageView.frame = CGRectMake(9, kMainScreenHeight - 50, 44, 44);
            
        } else {
            
            _isPlayViewShowing = YES;
            
            _playView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
            _cdEGOImageView.frame = CGRectMake(62, 119, 196, 196);
            
        }
        
    } completion:^(BOOL finished) {
        
        _cdEGOImageView.hidden = YES;
        
    }];
    
}

//登录，获取用户资料
-(void)initUserData{
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    
    [databaseManager insertUserAccout:@"pig" password:@"pig" userid:@""];
    
    User *lastUser = [databaseManager getLastLoginUser];
    if (lastUser && lastUser.username && lastUser.password) {
        
        [_miglabAPI doAuthLogin:lastUser.username password:lastUser.password];
        
    } else {
        
        [_miglabAPI doGetGuestInfo];
        
    }
    
}

//getGuestInfo notification
-(void)getGuestInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getGuestInfoFailed: %@", result);
    
}

-(void)getGuestInfoSuccess:(NSNotification *)tNotification{
    
    NSLog(@"getGuestInfoSuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    User *guest = [result objectForKey:@"result"];
    [guest log];
    
    [_miglabAPI doAuthLogin:guest.username password:guest.password];
    
}

//login notification
-(void)loginFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"loginFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"登录失败"];
    
}

-(void)loginSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"loginSuccess: %@", result);
    
    NSString *accesstoken = [result objectForKey:@"AccessToken"];
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    
    [UserSessionManager GetInstance].accesstoken = accesstoken;
    
    MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
    [miglabAPI doGetUserInfo:username accessToken:accesstoken];
}

//getUserInfo notification
-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getUserInfoFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    
}

-(void)getUserInfoSuccess:(NSNotification *)tNotification{
    
    NSDictionary* result = [tNotification userInfo];
    NSLog(@"getUserIdSuccess...%@", result);
    
    User* user = [result objectForKey:@"result"];
    [UserSessionManager GetInstance].currentUser = user;
    
    PLog(@"%@", [UserSessionManager GetInstance].currentUser.userid);
    
}

// end 登录，获取用户资料

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
            
            PAAMusicPlayer *aaMusicPlayer = [[PPlayerManaerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
            if (!aaMusicPlayer.isMusicPlaying && _shouldStartPlayAfterDownloaded) {
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
        
        [songManager downloadStart:_currentSong];
        
    }
    
}

-(void)initAndStartPlayer{
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManaerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    if (aaMusicPlayer && aaMusicPlayer.isMusicPlaying) {
        return;
    }
    
    PLog(@"initAndStartPlayer...");
    
    aaMusicPlayer.song = _currentSong;
    
    BOOL isPlayerInit = [aaMusicPlayer initPlayer];
    if (isPlayerInit) {
        aaMusicPlayer.delegate = self;
        [aaMusicPlayer play];
    }
    
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
    
    [_topPlayerInfoView doUpdatePlayingTip];
    [self doRotateSongCover];
    [self doUpdateProcess];
    
}

//旋转歌曲封面
-(void)doRotateSongCover{
    
    CGAffineTransform transformTmp = _cdOfSongView.coverOfSongEGOImageView.transform;
    transformTmp = CGAffineTransformRotate(transformTmp, ROTATE_ANGLE);
    _cdOfSongView.coverOfSongEGOImageView.transform = transformTmp;
    
}

//根据圆圈的比率，刷新圆盘进度
-(void)doUpdateProcess{
    
    PAAMusicPlayer *aaMusicPlayer = [[PPlayerManaerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    long duration = aaMusicPlayer.getDuration;
    long currentTime = aaMusicPlayer.getCurrentTime;
    float playProcess = (duration > 0) ? (float)currentTime / (float)duration : 0;
    
    [_cdOfSongView updateProcess:playProcess];
    
}

#pragma UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int page = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _showInfoPageControl.currentPage = page;
    
}

#pragma UIScrollViewDelegate end


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
