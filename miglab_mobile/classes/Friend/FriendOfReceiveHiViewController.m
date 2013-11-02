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
        self.navView.titleLabel.text = [NSString stringWithFormat:@"%@(收到消息)", name];
    }
    else if (_msginfo.messagetype == 3) {
        // 评论歌曲
        self.navView.titleLabel.text = [NSString stringWithFormat:@"%@(收到歌曲评论)", name];
    }
    
    //user head view
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    NearbyUser* user = _msginfo.userInfo;
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
            _userHeadView.userinfo = user;
        }//if
    }//for
    _userHeadView.frame = CGRectMake(11.5, posy + 10, 297, 129);
    [self.view addSubview:_userHeadView];
    
    //message
    _messageContentView.frame = CGRectMake(11.5, posy + 10 + 129 + 10, 297, kMainScreenHeight + self.topDistance - (posy + 10 + 129 + 10) - (10 + 73 + 10) );
    
//    [self.view addSubview:_messageContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
