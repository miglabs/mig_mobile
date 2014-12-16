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
#import "ChatViewController.h"
#import "MyFriendPersonalPageViewController.h"

@interface FriendOfReceiveMusicViewController ()

@end

@implementation FriendOfReceiveMusicViewController

@synthesize msginfo = _msginfo;
@synthesize musicCommentHeader = _musicCommentHeader;
@synthesize messageContentView = _messageContentView;
@synthesize isFriend = _isFriend;
@synthesize miglabAPI = _miglabAPI;
@synthesize isFirstPlay = _isFirstPlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCollectedSuccess:) name:NotificationNameCollectSongSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCollectedFailed:) name:NotificationNameCommentSongFailed object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCancelSuccess:) name:NotificationNameCancelCollectedSongSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCancelFailed:) name:NotificationNameCancelCollectedSongFailed object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStart:) name:NotificationNamePlayerStart object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerStop:) name:NotificationNamePlayerStop object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCancelCollectedSongSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCancelCollectedSongFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNamePlayerStart object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNamePlayerStop object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isFirstPlay = YES;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    NSString* name = _msginfo.userInfo.nickname;
    
    //nav bar
    self.navView.titleLabel.text = [NSString stringWithFormat:@"来自%@", name];
    
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
    _musicCommentHeader.btnAvatar.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_MUSIC_IMAGE];
    if (_msginfo.song.coverurl) {
        _musicCommentHeader.btnAvatar.imageURL = [NSURL URLWithString:_msginfo.song.coverurl];
    }
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
    
    posy += 110;
    
    // "评论"标识
    UILabel* lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10 + 10, posy + 2, 180, 15)];
    lblComment.text = @"评论";
    lblComment.textColor = [UIColor grayColor];
    lblComment.backgroundColor = [UIColor clearColor];
    lblComment.textAlignment = UITextAlignmentLeft;
    lblComment.font = [UIFont fontOfApp:12];
    [self.view addSubview:lblComment];
    
    
    /* title */
    posy += 20;
    NSArray* msgContentNib = [[NSBundle mainBundle] loadNibNamed:@"FriendOfMessageContentView" owner:self options:nil];
    for (id oneObject in msgContentNib) {
        
        if ([oneObject isKindOfClass:[FriendOfMessageContentView class]]) {
            
            _messageContentView = (FriendOfMessageContentView*)oneObject;
        }//if
    }//for
    _messageContentView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - BOTTOM_PLAYER_HEIGHT - 20);
    [_messageContentView.lbtnSendSong addTarget:self action:@selector(doSendSong:) forControlEvents:UIControlEventTouchUpInside];
    [_messageContentView.lbtnChat addTarget:self action:@selector(doLoadChat:) forControlEvents:UIControlEventTouchUpInside];
    
    // 添加发送人信息
    int starty = 10;
    int startx = 10;
    int maxWidth = 277;
    
    //添加发送人头像
    int avatarWidth = 30;
    int avatarHeight = 30;
    EGOImageButton* btnAvatar = [[EGOImageButton alloc] initWithFrame:CGRectMake(startx, starty, avatarWidth, avatarHeight)];
    
    btnAvatar.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    if (_msginfo.userInfo.headurl) {
        
        btnAvatar.imageURL = [NSURL URLWithString:_msginfo.userInfo.headurl];
    }
    btnAvatar.layer.cornerRadius = avatarWidth / 2;
    btnAvatar.layer.masksToBounds = YES;
    btnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
    btnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;
    [btnAvatar addTarget:self action:@selector(checkUsrInfo:) forControlEvents:UIControlEventTouchUpInside];
    [_messageContentView addSubview:btnAvatar];
    
    // 添加发送人名字
    UILabel* lblSenderName = [[UILabel alloc] initWithFrame:CGRectMake(startx + avatarWidth + 5, starty - 5, 160, avatarHeight / 3 * 2)];
    lblSenderName.text = _msginfo.userInfo.nickname;
    lblSenderName.textColor = [UIColor whiteColor];
    lblSenderName.backgroundColor = [UIColor clearColor];
    lblSenderName.textAlignment = UITextAlignmentLeft;
    lblSenderName.font = [UIFont fontOfApp:14];
    [_messageContentView addSubview:lblSenderName];
    
    // 添加发送人性别图片
    NSString* senderSex = _msginfo.userInfo.sex;
    CGSize senderNameLength = [lblSenderName.text sizeWithFont:lblSenderName.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGRect senderNameRect = lblSenderName.frame;
    CGRect imgRect = CGRectMake(senderNameRect.origin.x + senderNameLength.width + 5, senderNameRect.origin.y + 5, 12, 12);
    UIImageView* imgSex = [[UIImageView alloc] initWithFrame:imgRect];
    if ([senderSex isEqualToString:STR_MALE]) {
        
        imgSex.image = [UIImage imageNamed:@"user_gender_male"];
    }
    else {
        
        imgSex.image = [UIImage imageNamed:@"user_gender_female"];
    }
    [_messageContentView addSubview:imgSex];
    
    
    // 添加发送人位置和收听歌曲显示
    long distance = _msginfo.userInfo.distance;
    NSString* songName = _msginfo.userInfo.songname;
    UILabel* lblSenderInfo = [[UILabel alloc] initWithFrame:CGRectMake(startx + avatarWidth + 5, starty + avatarHeight / 3 * 2, maxWidth - avatarWidth - starty, avatarHeight / 3)];
    lblSenderInfo.text = [NSString stringWithFormat:@"%ldkm | 正在听 %@", distance, songName];
    lblSenderInfo.textColor = [UIColor whiteColor];
    lblSenderInfo.backgroundColor = [UIColor clearColor];
    lblSenderInfo.textAlignment = UITextAlignmentLeft;
    lblSenderInfo.font = [UIFont fontOfApp:10];
    [_messageContentView addSubview:lblSenderInfo];
    
    starty += avatarHeight + 5;
    
    // 修改发送信息显示框
    int msgCntWidth = maxWidth;
    int msgCntHeight = 95;
    int msgCntBorderWidth = 10;
    _messageContentView.imgBorder.frame = CGRectMake(startx, starty, msgCntWidth, msgCntHeight);
    
    // 添加发送信息内容
    UILabel* textcontent = [[UILabel alloc] initWithFrame:CGRectMake(startx + msgCntBorderWidth, starty, msgCntWidth - msgCntBorderWidth, msgCntHeight - msgCntBorderWidth)];
    textcontent.text = _msginfo.content;
    textcontent.textColor = [UIColor whiteColor];
    textcontent.backgroundColor = [UIColor clearColor];
    textcontent.textAlignment = UITextAlignmentLeft;
    textcontent.font = [UIFont fontOfApp:16];
    textcontent.numberOfLines = MAX_RECEIVE_DISPLAY_LINES;
    
    // 更新发送信息内容显示的高度
    CGSize maxsize = CGSizeMake(300, 9000);
    CGSize stringSize = [textcontent.text sizeWithFont:textcontent.font constrainedToSize:maxsize];
    textcontent.frame = CGRectMake(startx + msgCntBorderWidth, starty + msgCntBorderWidth, msgCntWidth - msgCntBorderWidth, stringSize.height);
    [_messageContentView addSubview:textcontent];
    
    starty += msgCntHeight + 5;
    
    //更新按钮显示位置
    _messageContentView.lbtnSendSong.frame = CGRectMake(83, starty, 98, 30);
    _messageContentView.lbtnChat.frame = CGRectMake(189, starty, 98, 30);
    
    [self.view addSubview:_messageContentView];
    
    [self updateDisplayInfo];
    
    _miglabAPI = [[MigLabAPI alloc] init];
}

-(void)doSendSong:(id)sender {
    
    // 跳转到送歌页面
    FriendOfRecommendMusicViewController* recommandView = [[FriendOfRecommendMusicViewController alloc] initWithNibName:@"FriendOfRecommendMusicViewController" bundle:nil];
    recommandView.toUserInfo = _msginfo.userInfo;
    [self.navigationController pushViewController:recommandView animated:YES];
}

-(IBAction)checkUsrInfo:(id)sender {
    
    if (_msginfo) {
        
        MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
        personalPageViewController.userinfo = _msginfo.userInfo;
        personalPageViewController.isFriend = NO;
        
        [self.navigationController pushViewController:personalPageViewController animated:YES];
    }
}

-(void)doLoadChat:(id)sender {
    
    int currentUserId = [[UserSessionManager GetInstance].userid intValue];
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    //ChatViewController *chatController = [[ChatViewController alloc] init:nil uid:currentUserId tid:[_msginfo.userInfo.userid intValue]];
    
    ChatViewController *chatController = [[ChatViewController alloc] init:accesstoken uid:currentUserId name: _msginfo.userInfo.nickname tid:[_msginfo.userInfo.userid intValue]];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateDisplayInfo {
    
#if USE_NEW_AUDIO_PLAY
    
    PAudioStreamerPlayer *asMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AudioStreamerPlayer];
    
    if ([asMusicPlayer isMusicPlaying]) {
        
#else //USE_NEW_AUDIO_PLAY
        
    PAAMusicPlayer* aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
    
    if ([aaMusicPlayer isMusicPlaying]) {
        
#endif //USE_NEW_AUDIO_PLAY
        
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
    
    if (_isFirstPlay) {
        
        [[PPlayerManagerCenter GetInstance] doInsertPlay:_msginfo.song];
        _isFirstPlay = NO;
    }
    else {
        
        [[PPlayerManagerCenter GetInstance] doPlayOrPause];
    }
    
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
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
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
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}


#pragma mark - Notification
-(void)doCollectedSuccess:(NSNotification *)tNotification {
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    currentsong.like = @"1";
    
    [[PDatabaseManager GetInstance] updateSongInfoOfLike:currentsong.songid like:@"1"];
    
    UIImage* img = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
    [_musicCommentHeader.btnCollect setImage:img forState:UIControlStateNormal];
}

-(void)doCollectedFailed:(NSNotification *)tNotification {
    
    
}

-(void)doCancelSuccess:(NSNotification *)tNotification {
    
    Song *currentsong = [PPlayerManagerCenter GetInstance].currentSong;
    currentsong.like = @"0";
    
    [[PDatabaseManager GetInstance] updateSongInfoOfLike:currentsong.songid like:@"0"];
    
    UIImage* img = [UIImage imageWithName:@"music_menu_light_heart_nor" type:@"png"];
    [_musicCommentHeader.btnCollect setImage:img forState:UIControlStateNormal];
}

-(void)doCancelFailed:(NSNotification *)tNotification {
    
    
}
    
    
    -(void)playerStart:(NSNotification *)tNotification {
        
        UIImage *stopNorImage = [UIImage imageWithName:@"music_menu_stop_nor" type:@"png"];
        [_musicCommentHeader.btnPlayOrPause setImage:stopNorImage forState:UIControlStateNormal];
    }
    
    -(void)playerStop:(NSNotification *)tNotification {
        
        UIImage *playNorImage = [UIImage imageWithName:@"music_menu_play_nor" type:@"png"];
        [_musicCommentHeader.btnPlayOrPause setImage:playNorImage forState:UIControlStateNormal];
    }

@end
