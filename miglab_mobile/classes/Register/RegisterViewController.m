//
//  RegisterViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RegisterViewController.h"
#import "MigLabConfig.h"
#import "MigLabAPI.h"
#import "SVProgressHUD.h"
#import "RegisterOfNickNameViewController.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"
#import "RootViewController.h"
#import "GeneViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize textBgImageView = _textBgImageView;
@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize btnRegister = _btnRegister;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //register
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationNameRegisterFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerSuccess:) name:NotificationNameRegisterSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameRegisterSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav bar
    self.navView.titleLabel.text = @"注册咪呦账号";
    self.bgImageView.hidden = YES;
    
    CGRect textbgframe = _textBgImageView.frame;
    textbgframe.origin.y += self.topDistance;
    _textBgImageView.frame = textbgframe;
    
    CGRect emailframe = _emailTextField.frame;
    emailframe.origin.y += self.topDistance;
    _emailTextField.frame = emailframe;
    
    CGRect passwordframe = _passwordTextField.frame;
    passwordframe.origin.y += self.topDistance;
    _passwordTextField.frame = passwordframe;
    //add by kerry 2014/04/13
    _passwordTextField.secureTextEntry = YES;
    
    
    CGRect registerframe = _btnRegister.frame;
    registerframe.origin.y += self.topDistance;
    _btnRegister.frame = registerframe;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doRegisterAction:(id)sender{
    
    NSString *strEMail = _emailTextField.text;
    NSString *strPassword = _passwordTextField.text;
    
    if (!strEMail) {
        [SVProgressHUD showErrorWithStatus:MIGTIP_EMPTY_EMAIL];
        return;
    }
    
    if (![strEMail rangeOfString:@"@"].length) {
        [SVProgressHUD showErrorWithStatus:MIGTIP_WRONG_EMAIL_FMT];
        return;
    }
    
    if (!strPassword) {
        [SVProgressHUD showErrorWithStatus:MIGTIP_EMPTY_PASSWORD];
        return;
    }
    
    if (strEMail && strPassword) {
        
        [UserSessionManager GetInstance].currentUser.username = strEMail;
        [UserSessionManager GetInstance].currentUser.password = strPassword;
        
        MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
        [miglabAPI doRegister:strEMail password:strPassword nickname:strEMail source:SourceTypeMiglab];
        
    }
    
}

//notification
-(void)registerFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"registerFailed: %@", result);
    
    NSString *msg = [result objectForKey:@"msg"];
    [SVProgressHUD showErrorWithStatus:msg];
    
}

-(void)registerSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"registerSuccess: %@", result);
    
    if (result == nil) {
        return;
    }
    
    PUser* user = [result objectForKey:@"result"];
    user.password = [UserSessionManager GetInstance].currentUser.password;
    user.source = SourceTypeMiglab;
    [user log];
    
    [UserSessionManager GetInstance].accesstoken = user.token;
    [UserSessionManager GetInstance].currentUser = user;
    [UserSessionManager GetInstance].userid = user.userid;
    [UserSessionManager GetInstance].isLoggedIn = YES;
    
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:0];
    
    //gene
    NSNumber *numGeneIndex = [NSNumber numberWithInt:100];
    RootViewController *rootViewController = ((AppDelegate *)[UIApplication sharedApplication].delegate).rootController;
    GeneViewController *tempGene = [rootViewController.dicViewControllerCache objectForKey:numGeneIndex];
    [tempGene loadSongsByGene];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
//    RegisterOfNickNameViewController *gotoNickNameView = [[RegisterOfNickNameViewController alloc] initWithNibName:@"RegisterOfNickNameViewController" bundle:nil];
//    [self.navigationController pushViewController:gotoNickNameView animated:YES];
}

@end
