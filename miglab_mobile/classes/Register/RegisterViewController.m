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

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationNameRegisterFailed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerFailed:) name:NotificationNameRegisterSuccess object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(IBAction)doRegisterAction:(id)sender{
    
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
        [miglabAPI doRegister:strEMail password:strPassword nickname:strEMail source:0];
        
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
    
    RegisterOfNickNameViewController *gotoNickNameView = [[RegisterOfNickNameViewController alloc] initWithNibName:@"RegisterOfNickNameViewController" bundle:nil];
    [self.navigationController pushViewController:gotoNickNameView animated:YES];
    
}

@end
