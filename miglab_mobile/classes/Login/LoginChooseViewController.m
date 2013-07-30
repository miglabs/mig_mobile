//
//  LoginChooseViewController.m
//  miglab_mobile
//
//  Created by pig on 13-7-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginChooseViewController.h"
#import "MigLabConfig.h"
#import "MigLabAPI.h"
#import "AppDelegate.h"
#import "DDMenuController.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"

@interface LoginChooseViewController ()

@end

@implementation LoginChooseViewController

@synthesize bgImageView = _bgImageView;
@synthesize btnTopMenu = _btnTopMenu;
@synthesize btnTopRegister = _btnTopRegister;
@synthesize btnSinaWeibo = _btnSinaWeibo;
@synthesize btnQQ = _btnQQ;
@synthesize btnDouBan = _btnDouBan;
@synthesize btnMiglab = _btnMiglab;

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
    
    _bgImageView.frame = kMainScreenFrame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doShowLeftMenu:(id)sender{
    
    PLog(@"doShowLeftMenu...");
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController showLeftController:YES];
    
}

-(IBAction)doGotoRegister:(id)sender{
    
    PLog(@"doGotoRegister...");
    
    RegisterViewController *registerViewController = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:registerViewController animated:YES];
    
}

-(IBAction)doSinaWeiboLogin:(id)sender{
    
    PLog(@"doSinaWeiboLogin...");
    
}

-(IBAction)doQQLogin:(id)sender{
    
    PLog(@"doQQLogin...");
    
}

-(IBAction)doDouBanLogin:(id)sender{
    
    PLog(@"doDouBanLogin...");
    
}

-(IBAction)doMiglabLogin:(id)sender{
    
    PLog(@"doMiglabLogin...");
    
    LoginViewController *loginViewController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
    
}

@end
