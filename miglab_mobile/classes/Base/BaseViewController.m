//
//  BaseViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize topDistance = _topDistance;

@synthesize navView = _navView;

@synthesize bgImageView = _bgImageView;

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
    
    //适配ios7
    _topDistance = 0;
    long losVersion = [[UIDevice currentDevice].systemVersion floatValue] * 10000;
    if (losVersion >= 70000) {
        _topDistance = 20;
    }
    
    //bg
    UIImage *baseViewBg = [UIImage imageWithName:@"base_view_bg" type:@"png"];
    _bgImageView = [[EGOImageView alloc] initWithPlaceholderImage:baseViewBg];
    _bgImageView.frame = CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight + _topDistance);
    [self.view addSubview:_bgImageView];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initCustomNavigationBarView:@"Base View"];
    [self.view addSubview:_navView];
    
    //back
    UIImage *backImage = [UIImage imageWithName:@"base_back_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
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
