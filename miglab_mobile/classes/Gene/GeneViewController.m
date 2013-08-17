//
//  GeneViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GeneViewController.h"
#import "LoginChooseViewController.h"
#import "PlayViewController.h"

@interface GeneViewController ()

@end

@implementation GeneViewController

@synthesize topViewcontroller = _topViewcontroller;

@synthesize btnAvatar = _btnAvatar;

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
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //avatar
    UIImage *avatarNorImage = [UIImage imageWithName:@"music_default_avatar" type:@"png"];
    _btnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:avatarNorImage];
    _btnAvatar.frame = CGRectMake(10 + 13, 45 + 10 + 13, 36, 36);
    _btnAvatar.layer.cornerRadius = 18;
    _btnAvatar.layer.masksToBounds = YES;
    _btnAvatar.layer.borderWidth = 2;
    _btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    [_btnAvatar setImage:avatarNorImage forState:UIControlStateNormal];
    [_btnAvatar addTarget:self action:@selector(doAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnAvatar];
    
//    self.playerMenuView.frame = CGRectMake(11.5, kMainScreenHeight - 45 - 73 - 10, 297, 73);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doAvatar:(id)sender{
    
    PLog(@"gene doAvatar...");
    
    LoginChooseViewController *loginChooseViewController = [[LoginChooseViewController alloc] initWithNibName:@"LoginChooseViewController" bundle:nil];
    [_topViewcontroller.navigationController pushViewController:loginChooseViewController animated:YES];
    
}

//override
-(IBAction)doPlayerAvatar:(id)sender{
    
    [super doPlayerAvatar:sender];
    PLog(@"gene doPlayerAvatar...");
    
    PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    [self.navigationController presentModalViewController:playViewController animated:YES];
    [_topViewcontroller.navigationController presentModalViewController:playViewController animated:YES];
    
}

@end
