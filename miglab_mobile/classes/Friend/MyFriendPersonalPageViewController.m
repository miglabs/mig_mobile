//
//  MyFriendPersonalPageViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MyFriendPersonalPageViewController.h"

@interface MyFriendPersonalPageViewController ()

@end

@implementation MyFriendPersonalPageViewController

@synthesize navView = _navView;
@synthesize userHeadView = _userHeadView;

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
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"猫王爱淘汰" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(4, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //user head
    NSArray *userHeadNib = [[NSBundle mainBundle] loadNibNamed:@"FriendMessageUserHead" owner:self options:nil];
    for (id oneObject in userHeadNib){
        if ([oneObject isKindOfClass:[FriendMessageUserHead class]]){
            _userHeadView = (FriendMessageUserHead *)oneObject;
        }//if
    }//for
    _userHeadView.frame = CGRectMake(11.5, 45 + 10, 297, 129);
    [self.view addSubview:_userHeadView];
    
    //body menu
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
