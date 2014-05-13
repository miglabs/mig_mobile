//
//  LoginViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginViewController.h"
#import "MigLabConfig.h"
#import "SVProgressHUD.h"
#import "GetPasswordViewController.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"
#import "MainMenuViewController.h"
#import "AppDelegate.h"
#import "PPlayerManagerCenter.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize textBgImageView = _textBgImageView;
@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize btnLogin = _btnLogin;
@synthesize btnForget = _btnForget;

@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //login
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
        
        //user
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameLoginSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetUserInfoSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav bar
    self.navView.titleLabel.text = @"咪呦账号登录";
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
    
    CGRect loginframe = _btnLogin.frame;
    loginframe.origin.y += self.topDistance;
    _btnLogin.frame = loginframe;
    
    CGRect forgetframe = _btnForget.frame;
    forgetframe.origin.y += self.topDistance;
    _btnForget.frame = forgetframe;
    _btnForget.hidden = YES;
    
    //
    _miglabAPI = [[MigLabAPI alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doLoginAction:(id)sender{
    
    PLog(@"doLoginAction...");
    
    NSString *strEMail = _emailTextField.text;
    NSString *strPassword = _passwordTextField.text;
    
    if (!strEMail || strEMail.length < 1) {
        [SVProgressHUD showErrorWithStatus:MIGTIP_EMPTY_EMAIL];
        return;
    }
    
    if (!strPassword || strPassword.length < 1) {
        [SVProgressHUD showErrorWithStatus:MIGTIP_EMPTY_PASSWORD];
        return;
    }
    
    if (strEMail && strPassword) {
        
        [_miglabAPI doAuthLogin:strEMail password:strPassword];
        
    }
    
}

//login notification
-(void)loginFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"loginFailed...%@", result);
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager deleteUserAccountByUserName:[UserSessionManager GetInstance].currentUser.username];
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
}

-(void)loginSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"loginSuccess...%@", result);
    
    NSString *accesstoken = [result objectForKey:@"token"];
    [UserSessionManager GetInstance].accesstoken = accesstoken;
    
    PUser* user = [PUser initWithNSDictionary:result];
    user.password = [UserSessionManager GetInstance].currentUser.password;
    user.source = SourceTypeMiglab;
    [user log];
    
    [UserSessionManager GetInstance].currentUser = user;
    [UserSessionManager GetInstance].userid = user.userid;
    [UserSessionManager GetInstance].isLoggedIn = YES;
    
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:0];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRegisterSuccess object:nil userInfo:nil];
}

//getUserInfo notification
-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getUserInfoFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"重新登陆试试哦~"];
    
}

-(void)getUserInfoSuccess:(NSNotification *)tNotification{
    
    NSDictionary* result = [tNotification userInfo];
    NSLog(@"getUserInfoSuccess...%@", result);
    
    PUser* user = [result objectForKey:@"result"];
    [user log];
    
    //[SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
    user.password = [UserSessionManager GetInstance].currentUser.password;
    [UserSessionManager GetInstance].currentUser = user;
    
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    NSString *password = [UserSessionManager GetInstance].currentUser.password;
    NSString *userid = [UserSessionManager GetInstance].currentUser.userid;
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertUserAccout:username password:password userid:userid accessToken:accesstoken accountType:0];
    
    //goto main view
    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainMenuViewController];
    [nav setNavigationBarHidden:YES];
    
}

-(IBAction)doForgetPassword:(id)sender{
    
    PLog(@"doForgetPassword...");
    
    GetPasswordViewController *getPasswordViewController = [[GetPasswordViewController alloc] initWithNibName:@"GetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:getPasswordViewController animated:YES];
    
}

-(IBAction)doHideKeyBoard:(id)sender{
    
    [_emailTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
}

#pragma UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _emailTextField) {
        
        [_passwordTextField becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
        
    }
    return YES;
}

@end
