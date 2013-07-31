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
#import "MigLabAPI.h"
#import "GetPasswordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    //register
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed:) name:NotificationNameLoginFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:NotificationNameLoginSuccess object:nil];
    
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
    
    if (!strEMail) {
        [SVProgressHUD showErrorWithStatus:@"邮箱不能为空噢～"];
        return;
    }
    
    if (!strPassword) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空噢～"];
        return;
    }
    
    if (strEMail && strPassword) {
        
        MigLabAPI *miglabAPI = [[MigLabAPI alloc] init];
        [miglabAPI doAuthLogin:strEMail password:strPassword];
        
    }
    
}

-(void)loginFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"loginFailed...%@", result);
    
}

-(void)loginSuccess:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"loginSuccess...%@", result);
    
}

-(IBAction)doForgetPassword:(id)sender{
    
    PLog(@"doForgetPassword...");
    
    GetPasswordViewController *getPasswordViewController = [[GetPasswordViewController alloc] initWithNibName:@"GetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:getPasswordViewController animated:YES];
    
}

@end
