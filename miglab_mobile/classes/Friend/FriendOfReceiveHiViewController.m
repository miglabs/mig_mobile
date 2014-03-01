//
//  FriendOfReceiveHiViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfReceiveHiViewController.h"
#import "FriendOfRecommendMusicViewController.h"

@interface FriendOfReceiveHiViewController ()

@end

@implementation FriendOfReceiveHiViewController

@synthesize userHeadView = _userHeadView;
@synthesize msginfo = _msginfo;

@synthesize messageContentView = _messageContentView;

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
    
    //nav bar
    NSString* name = _msginfo.userInfo.nickname;
    
    self.navView.titleLabel.text = [NSString stringWithFormat:@"来自%@", name];
    
    //user head view
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    NearbyUser* user = _msginfo.userInfo;
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
            [_userHeadView updateFriendMessageUserHead:user];
            
            // 单独更新距离信息
            float fDistance = user.distance / 1000.0f;
            NSString* Location = user.location;
            _userHeadView.lblDistance.text = [NSString stringWithFormat:@"%.2fkm | %@", fDistance, Location];
        }//if
    }//for
    _userHeadView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, 129);
    [_userHeadView.btnSendSong setHidden:YES];
    [_userHeadView.btnSay setHidden:YES];
    [self.view addSubview:_userHeadView];
    
    posy += 139;
    
    // "对方送你一首歌"标识
    UILabel* lblComment = [[UILabel alloc] initWithFrame:CGRectMake(10 + 10, posy + 2, 180, 15)];
    lblComment.textColor = [UIColor grayColor];
    lblComment.backgroundColor = [UIColor clearColor];
    lblComment.textAlignment = UITextAlignmentLeft;
    lblComment.font = [UIFont fontOfApp:12];
    if (_msginfo.messagetype == 1) {
        
        lblComment.text = @"对方给你打了一个招呼";
    }
    else if (_msginfo.messagetype == 3) {
        
        lblComment.text = @"对方给你的歌曲评论";
    }
    else {
        
        lblComment.text = @"";
    }
    [self.view addSubview:lblComment];
    
    posy += 20;
    
    //message
    NSArray* msgContentNib = [[NSBundle mainBundle] loadNibNamed:@"FriendOfMessageContentView" owner:self options:nil];
    for (id oneObject in msgContentNib) {
        if ([oneObject isKindOfClass:[FriendOfMessageContentView class]]) {
            _messageContentView = (FriendOfMessageContentView*)oneObject;
        }//if
    }//for
    _messageContentView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - (10 + BOTTOM_PLAYER_HEIGHT + 10) );
    [_messageContentView.lbtnSendSong addTarget:self action:@selector(doSendSong:) forControlEvents:UIControlEventTouchUpInside];
    [_messageContentView.lbtnChat addTarget:self action:@selector(doLoadChar:) forControlEvents:UIControlEventTouchUpInside];
    
    // 打招呼显示框
    int startx = 10;
    int starty = 10;
    int msgCntWidth = 277;
    int msgCntHeight = 113;
    int msgCntBorderWidth = 10;
    _messageContentView.imgBorder.frame = CGRectMake(startx, starty, msgCntWidth, msgCntHeight);
    
    // 打招呼显示内容
    UILabel* textcontent = [[UILabel alloc] initWithFrame:CGRectMake(startx + msgCntBorderWidth, starty + msgCntBorderWidth, msgCntWidth - msgCntBorderWidth, msgCntHeight - msgCntBorderWidth)];
    textcontent.text = _msginfo.content;
    textcontent.textColor = [UIColor whiteColor];
    textcontent.backgroundColor = [UIColor clearColor];
    textcontent.textAlignment = UITextAlignmentLeft;
    textcontent.font = [UIFont fontOfApp:16];
    
    // 更新label显示的高度
    CGSize maxsize = CGSizeMake(300, 9000);
    CGSize stringSize = [textcontent.text sizeWithFont:textcontent.font constrainedToSize:maxsize];
    textcontent.frame = CGRectMake(startx + msgCntBorderWidth, starty + msgCntBorderWidth, msgCntWidth - msgCntBorderWidth, stringSize.height);
    [_messageContentView addSubview:textcontent];
    
    starty += msgCntHeight + 5;
    
    //更新按钮显示位置
    _messageContentView.lbtnSendSong.frame = CGRectMake(83, starty, 98, 30);
    _messageContentView.lbtnChat.frame = CGRectMake(189, starty, 98, 30);

    
    [self.view addSubview:_messageContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doSendSong:(id)sender {
    
    // 跳转到送歌页面
    FriendOfRecommendMusicViewController* recommandView = [[FriendOfRecommendMusicViewController alloc] initWithNibName:@"FriendOfRecommendMusicViewController" bundle:nil];
    recommandView.toUserInfo = _msginfo.userInfo;
    [self.navigationController pushViewController:recommandView animated:YES];
}

-(void)doLoadChar:(id)sender {
    
    [SVProgressHUD showErrorWithStatus:@"还没有聊天功能啊..."];
}


@end
