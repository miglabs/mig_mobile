//
//  LocalViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LocalViewController.h"
#import "UIImage+PImageCategory.h"

@interface LocalViewController ()

@end

@implementation LocalViewController

@synthesize navView = _navView;

@synthesize playerMenuView = _playerMenuView;

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
    
    //bg
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    bgImageView.image = [UIImage imageWithName:@"view_bg" type:@"png"];
    [self.view addSubview:bgImageView];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"本地音乐" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(6, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //menu
    _playerMenuView = [[MusicPlayerMenuView alloc] initDefaultMenuView:CGRectMake(11.5, kMainScreenHeight - 73 - 10, 297, 73)];
    [_playerMenuView.btnAvatar addTarget:self action:@selector(doPlayerAvatar:) forControlEvents:UIControlEventTouchUpInside];
    _playerMenuView.lblSongInfo.text = @"迷宫仙曲－乐瑟";
    [_playerMenuView.btnDelete addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnCollect addTarget:self action:@selector(doCollect:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_playerMenuView.btnNext addTarget:self action:@selector(doNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerMenuView];
    
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
