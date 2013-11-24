//
//  FriendOfReceiveMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfReceiveMusicViewController.h"
#import "UserSessionManager.h"
#import "FriendOfRecommendMusicViewController.h"

@interface FriendOfReceiveMusicViewController ()

@end

@implementation FriendOfReceiveMusicViewController

@synthesize msginfo = _msginfo;
@synthesize musicCommentHeader = _musicCommentHeader;
@synthesize messageContentView = _messageContentView;
@synthesize isFriend = _isFriend;
@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCollectedSuccess:) name:NotificationNameCollectSongSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCollectedFailed:) name:NotificationNameCommentSongFailed object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCancelSuccess:) name:NotificationNameCancelCollectedSongSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCancelFailed:) name:NotificationNameCancelCollectedSongFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCancelCollectedSongSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCancelCollectedSongFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    NSString* myname = [UserSessionManager GetInstance].currentUser.nickname;
    
    //nav bar
    self.navView.titleLabel.text = myname;
    
    /* music header */
    posy += 10;
    NSArray* musicHeadNib = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentPlayerView" owner:self options:nil];
    for (id oneObject in musicHeadNib) {
        
        if([oneObject isKindOfClass:[MusicCommentPlayerView class]]) {
            
            _musicCommentHeader = (MusicCommentPlayerView*)oneObject;
        }//if
    }//for
    _musicCommentHeader.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, 110);
    [self.view addSubview:_musicCommentHeader];
    
    /* 配置player */
    _musicCommentHeader.btnAvatar.layer.cornerRadius = 38;
    _musicCommentHeader.btnAvatar.layer.masksToBounds = YES;
    _musicCommentHeader.btnAvatar.layer.borderWidth = 2;
    _musicCommentHeader.btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _musicCommentHeader.btnAvatar.imageURL = [NSURL URLWithString:_msginfo.song.coverurl];
    _musicCommentHeader.lblSongName.text = _msginfo.song.songname;
    _musicCommentHeader.lblSongName.font = [UIFont fontOfApp:17.0f];
    _musicCommentHeader.lblSongArtist.text = _msginfo.song.artist;
    _musicCommentHeader.lblSongArtist.font = [UIFont fontOfApp:17.0f];
    [_musicCommentHeader.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_musicCommentHeader.btnCollect addTarget:self action:@selector(doCollectedOrCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_musicCommentHeader.btnDelete addTarget:self action:@selector(doHate:) forControlEvents:UIControlEventTouchUpInside];
    [_musicCommentHeader.btnShare setHidden:YES];
    
    int islike = [_msginfo.song.like intValue];
    if (islike > 0) {
        
        UIImage *darkHeartImage = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
        [_musicCommentHeader.btnCollect setImage:darkHeartImage forState:UIControlStateNormal];
    }
    else {
        
        UIImage* img = [UIImage imageWithName:@"music_menu_light_heart_nor" type:@"png"];
        [_musicCommentHeader.btnCollect setImage:img forState:UIControlStateNormal];
    }
    
    /* title */
    posy += 110 + 10;
    NSArray* msgContentNib = [[NSBundle mainBundle] loadNibNamed:@"FriendOfMessageContentView" owner:self options:nil];
    for (id oneObject in msgContentNib) {
        
        if ([oneObject isKindOfClass:[FriendOfMessageContentView class]]) {
            
            _messageContentView = (FriendOfMessageContentView*)oneObject;
        }//if
    }//for
    _messageContentView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - BOTTOM_PLAYER_HEIGHT - 20);
    [_messageContentView.lbtnSendSong addTarget:self action:@selector(doSendSong:) forControlEvents:UIControlEventTouchUpInside];
    [_messageContentView.lbtnChat addTarget:self action:@selector(doLoadChat:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel* lblcontenttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 227, 21)];
    lblcontenttitle.text = @"评论";
    lblcontenttitle.backgroundColor = [UIColor clearColor];
    lblcontenttitle.textColor = [UIColor whiteColor];
    lblcontenttitle.textAlignment = UITextAlignmentLeft;
    [_messageContentView addSubview:lblcontenttitle];
    
    UILabel* textcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 257, 80)];
    textcontent.text = _msginfo.content;
    textcontent.backgroundColor = [UIColor clearColor];
    textcontent.textAlignment = UITextAlignmentLeft;
    [_messageContentView addSubview:textcontent];
    
    [self.view addSubview:_messageContentView];
    
    _miglabAPI = [[MigLabAPI alloc] init];
}

-(void)doSendSong:(id)sender {
    
    // 跳转到送歌页面
    FriendOfRecommendMusicViewController* recommandView = [[FriendOfRecommendMusicViewController alloc] initWithNibName:@"FriendOfRecommendMusicViewController" bundle:nil];
    recommandView.toUserInfo = _msginfo.userInfo;
    [self.navigationController pushViewController:recommandView animated:YES];
}

-(void)doLoadChat:(id)sender {
    
    [SVProgressHUD showErrorWithStatus:@"还没有聊天功能啊..."];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateDisplayInfo {
    
    PAAMusicPlayer* aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    
    if ([aaMusicPlayer isMusicPlaying]) {
        
        UIImage* stop = [UIImage imageWithName:@"music_menu_stop_nor" type:@"png"];
        [_musicCommentHeader.btnPlayOrPause setImage:stop forState:UIControlStateNormal];
    }
    else {
        
        UIImage* play = [UIImage imageWithName:@"music_menu_play_nor" type:@"png"];
        [_musicCommentHeader.btnPlayOrPause setImage:play forState:UIControlStateNormal];
    }
}

-(IBAction)doPlayOrPause:(id)sender {
    
    PLog(@"recommand song play or pause");
    
    [[PPlayerManagerCenter GetInstance] doInsertPlay:_msginfo.song];
    
    [self updateDisplayInfo];
}

-(IBAction)doCollectedOrCancel:(id)sender {
    
    PLog(@"recommand collected or cancel");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        Song* song = _msginfo.song;
        NSString* songid = [NSString stringWithFormat:@"%lld", song.songid];
        NSString* moodid = [NSString stringWithFormat:@"%d", [UserSessionManager GetInstance].currentUserGene.mood.typeid];
        NSString* typeid = [NSString stringWithFormat:@"%d", [UserSessionManager GetInstance].currentUserGene.type.typeid];
        
        int isLike = [song.like intValue];
        
        if (isLike > 0) {
            
            [_miglabAPI doDeleteCollectedSong:userid token:accesstoken songid:songid];
        }
        else {
            
            [_miglabAPI doCollectSong:userid token:accesstoken sid:songid modetype:moodid typeid:typeid];
        }
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"您还没有登录哦~"];
    }
}

-(IBAction)doHate:(id)sender {
    
    PLog(@"recommand delete song");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        Song* song = _msginfo.song;
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [_miglabAPI doHateSong:userid token:accesstoken sid:song.songid];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"您还没有登录哦~"];
    }
}


#pragma mark - Notification
-(void)doCollectedSuccess:(NSNotification *)tNotification {
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    currentsong.like = @"1";
    
    [[PDatabaseManager GetInstance] updateSongInfoOfLike:currentsong.songid like:@"1"];
    
    UIImage* img = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
    [_musicCommentHeader.btnCollect setImage:img forState:UIControlStateNormal];
    
    [SVProgressHUD showErrorWithStatus:@"收藏歌曲成功"];
}

-(void)doCollectedFailed:(NSNotification *)tNotification {
    
    
}

-(void)doCancelSuccess:(NSNotification *)tNotification {
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    currentsong.like = @"0";
    
    [[PDatabaseManager GetInstance] updateSongInfoOfLike:currentsong.songid like:@"0"];
    
    UIImage* img = [UIImage imageWithName:@"music_menu_light_heart_nor" type:@"png"];
    [_musicCommentHeader.btnCollect setImage:img forState:UIControlStateNormal];
    
    [SVProgressHUD showErrorWithStatus:@"取消成功"];
}

-(void)doCancelFailed:(NSNotification *)tNotification {
    
    
}


@end
