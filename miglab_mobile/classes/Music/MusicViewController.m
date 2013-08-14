//
//  MusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicViewController.h"
#import "UIImage+PImageCategory.h"
#import "MusicPlayerNavigationView.h"
#import "MusicPlayerMenuView.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

@synthesize navigationView = _navigationView;

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
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight);
    bgImageView.image = [UIImage imageWithName:@"view_bg" type:@"png"];
    [self.view addSubview:bgImageView];
    
    _navigationView = [[MusicPlayerNavigationView alloc] initMusicNavigationView:CGRectMake(0, 0, 320, 45)];
    [_navigationView.btnAvatar addTarget:self action:@selector(doNavigationAvatar:) forControlEvents:UIControlEventTouchUpInside];
    _navigationView.lblNickName.text = @"乐瑟啊乐瑟";
    [_navigationView.btnFirstMenu setTitle:@"歌单" forState:UIControlStateNormal];
    [_navigationView.btnFirstMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_navigationView.btnFirstMenu setTitleColor:[UIColor grayColor] forState:UIControlEventTouchDown];
    [_navigationView.btnFirstMenu addTarget:self action:@selector(doNavigationFirst:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView.btnSecondMenu setTitle:@"歌友" forState:UIControlStateNormal];
    [_navigationView.btnSecondMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_navigationView.btnSecondMenu setTitleColor:[UIColor grayColor] forState:UIControlEventTouchDown];
    [_navigationView.btnSecondMenu addTarget:self action:@selector(doNavigationSecond:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_navigationView];
    
    _playerMenuView = [[MusicPlayerMenuView alloc] initDefaultMenuView:CGRectMake(12, kMainScreenHeight - 73 - 10, kMainScreenWidth, 73)];
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

-(IBAction)doNavigationAvatar:(id)sender{
    
}

-(IBAction)doNavigationFirst:(id)sender{
    
}

-(IBAction)doNavigationSecond:(id)sender{
    
}


-(IBAction)doPlayerAvatar:(id)sender{
    
}

-(IBAction)doDelete:(id)sender{
    
}

-(IBAction)doCollect:(id)sender{
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
}

-(IBAction)doNext:(id)sender{
    
}

@end
