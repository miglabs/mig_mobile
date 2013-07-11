//
//  PlayViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayViewController.h"
#import "UIImage+PImageCategory.h"
#import "PCommonUtil.h"
#import "AppDelegate.h"

@interface PlayViewController ()

@end

@implementation PlayViewController

@synthesize backgroundEGOImageView = _backgroundEGOImageView;
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
    
    UIImage *defaultBackgroundImage = [UIImage imageWithName:@"cd_pic_0" type:@"png"];
    _backgroundEGOImageView = [[EGOImageView alloc] initWithPlaceholderImage:defaultBackgroundImage];
    _backgroundEGOImageView.frame = CGRectMake(0, -20, 320, height + 20);
    [self.view addSubview:_backgroundEGOImageView];
    
    //top
    _topPlayerInfoView = [[PCustomPlayerNavigationView alloc] initPlayerNavigationView:CGRectMake(0, -20, 320, 44)];
    [_topPlayerInfoView.btnMenu addTarget:self action:@selector(doShowLeftViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topPlayerInfoView.btnShare addTarget:self action:@selector(doShareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_topPlayerInfoView];
    
    //song info
    _songInfoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, height - 20 - 44 - 90)];
    [self.view addSubview:_songInfoScrollView];
    
    //bottom
    _bottomPlayerMenuView = [[PCustomPlayerMenuView alloc] initPlayerMenuView:CGRectMake(0, height - 20 - 90, 320, 90)];
    [_bottomPlayerMenuView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomPlayerMenuView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomPlayerMenuView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doShowLeftViewAction:(id)sender{
    
    NSLog(@"doShowLeftViewAction...");
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] menuController] showLeftController:YES];
    
}

-(IBAction)doShareAction:(id)sender{
    
    NSLog(@"doShareAction...");
    
}

-(IBAction)doRemoveAction:(id)sender{
    
    NSLog(@"doRemoveAction...");
    
}

-(IBAction)doLikeAction:(id)sender{
    
    NSLog(@"doLikeAction...");
    
}

-(IBAction)doNextAction:(id)sender{
    
    NSLog(@"doNextAction...");
    
}

@end
