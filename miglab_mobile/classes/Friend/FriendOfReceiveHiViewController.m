//
//  FriendOfReceiveHiViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfReceiveHiViewController.h"

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
    
    if (_msginfo.messagetype == 1) {
        // 打招呼
        self.navView.titleLabel.text = [NSString stringWithFormat:@"来自%@的消息", name];
    }
    else if (_msginfo.messagetype == 3) {
        // 评论歌曲
        self.navView.titleLabel.text = [NSString stringWithFormat:@"来自%@的歌曲评论", name];
    }
    
    //user head view
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    NearbyUser* user = _msginfo.userInfo;
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
            [_userHeadView updateFriendMessageUserHead:user];
        }//if
    }//for
    _userHeadView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, 129);
    [self.view addSubview:_userHeadView];
    
    //message
    NSArray* msgContentNib = [[NSBundle mainBundle] loadNibNamed:@"FriendOfMessageContentView" owner:self options:nil];
    for (id oneObject in msgContentNib) {
        if ([oneObject isKindOfClass:[FriendOfMessageContentView class]]) {
            _messageContentView = (FriendOfMessageContentView*)oneObject;
        }//if
    }//for
    _messageContentView.frame = CGRectMake(ORIGIN_X, posy + 10 + 129 + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - (posy + 10 + 129 + 10) - (10 + BOTTOM_PLAYER_HEIGHT + 10) );
    
    UILabel* contenttitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 227, 21)];
    if (_msginfo.messagetype == 1) {
        
        contenttitle.text = @"对方给你打了一个招呼";
    }
    else if (_msginfo.messagetype == 3) {
        
        contenttitle.text = @"对方给你的歌曲评论";
    }
    else {
        
        contenttitle.text = @"";
    }
    contenttitle.backgroundColor = [UIColor clearColor];
    contenttitle.textColor = [UIColor whiteColor];
    //[contenttitle setFont:[UIFont fontWithName:@"Arial" size:18.0]];
    contenttitle.textAlignment = UITextAlignmentLeft;
    [_messageContentView addSubview:contenttitle];
    
    UILabel* textcontent = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, 257, 80)];
    textcontent.text = _msginfo.content;
    textcontent.backgroundColor = [UIColor clearColor];
    textcontent.textAlignment = UITextAlignmentLeft;
    //[contenttitle setFont:[UIFont fontWithName:@"Arial" size:14.0]];
    [_messageContentView addSubview:textcontent];
    
    [self.view addSubview:_messageContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
