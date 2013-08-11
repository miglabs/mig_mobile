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
#import "DDMenuController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize miglabAPI = _miglabAPI;

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
    
    //login
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
    
    //user
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoFailed:) name:NotificationNameGetUserInfoFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoSuccess:) name:NotificationNameGetUserInfoSuccess object:nil];
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doLoginAction:(id)sender{
    
    PLog(@"doLoginAction...");
    
    NSString *strEMail = _emailTextField.text;
    NSString *strPassword = _passwordTextField.text;
    
    if (!strEMail || strEMail.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"邮箱不能为空噢～"];
        return;
    }
    
    if (!strPassword || strPassword.length < 1) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空噢～"];
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
    
    [SVProgressHUD showErrorWithStatus:@"登录失败，请稍后重试~"];
    
}

-(void)loginSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"loginSuccess...%@", result);
    
    NSString *accesstoken = [result objectForKey:@"AccessToken"];
    NSString *username = [UserSessionManager GetInstance].currentUser.username;
    
    [UserSessionManager GetInstance].accesstoken = accesstoken;
    
    [_miglabAPI doGetUserInfo:username accessToken:accesstoken];
    
}

//getUserInfo notification
-(void)getUserInfoFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    NSLog(@"getUserInfoFailed: %@", result);
    [SVProgressHUD showErrorWithStatus:@"用户信息获取失败:("];
    
}

-(void)getUserInfoSuccess:(NSNotification *)tNotification{
    
    NSDictionary* result = [tNotification userInfo];
    NSLog(@"getUserInfoSuccess...%@", result);
    
    PUser* user = [result objectForKey:@"result"];
    [user log];
    
    [SVProgressHUD showSuccessWithStatus:@"用户信息获取成功:)"];
    
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
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    [menuController setRootController:nav animated:YES];
    
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
