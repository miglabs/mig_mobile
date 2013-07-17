//
//  MainMenuViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PCommonUtil.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize playerBoradView = _playerBoradView;

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
    PLog(@"height: %f", height);
    
    //bottom
    _playerBoradView = [[PCustomPlayerBoradView alloc] initPlayerBoradView:CGRectMake(0, height - 20 - 60, 320, 60)];
    [_playerBoradView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerBoradView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
