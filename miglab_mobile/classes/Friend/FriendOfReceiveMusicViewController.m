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
}

-(void)doSendSong:(id)sender {
    
    // 跳转到送歌页面
    FriendOfRecommendMusicViewController* recommandView = [[FriendOfRecommendMusicViewController alloc] initWithNibName:@"FriendOfRecommendMusicViewController" bundle:nil];
    recommandView.toUserInfo = _msginfo.userInfo;
    [self.navigationController pushViewController:recommandView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
