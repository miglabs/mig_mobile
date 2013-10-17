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
    self.navView.titleLabel.text = @"猫王爱淘汰(收到消息)";
    
    //user head view
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
        }//if
    }//for
    _userHeadView.frame = CGRectMake(11.5, posy + 10, 297, 129);
    [self.view addSubview:_userHeadView];
    
    //message
    _messageContentView.frame = CGRectMake(11.5, posy + 10 + 129 + 10, 297, kMainScreenHeight + self.topDistance - (posy + 10 + 129 + 10) - (10 + 73 + 10) );
    [self.view addSubview:_messageContentView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
