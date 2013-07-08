//
//  PlayViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayViewController.h"
#import "PCommonUtil.h"


@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize topPlayerInfoView = _topPlayerInfoView;

@synthesize songInfoScrollView = _songInfoScrollView;

@synthesize bottomPlayerMenuView = _bottomPlayerMenuView;

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
    
    FRAMELOG(self.view);
    
    //screen height
    float height = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"height: %f", height);
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:_topPlayerInfoView];
    
    //song info
    _songInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, height - 20 - 44 - 85)];
    [self.view addSubview:_songInfoScrollView];
    
    //bottom
    _bottomPlayerMenuView = [[PCustomPlayerMenuView alloc] initPlayerMenuView:CGRectMake(0, height - 20 - 85, 320, 85)];
    [self.view addSubview:_bottomPlayerMenuView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
