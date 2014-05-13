//
//  SettingOfModifyNicknameViewController.m
//  miglab_mobile
//
//  Created by apple on 13-9-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfModifyNicknameViewController.h"
#import "UserSessionManager.h"
#import "SVProgressHUD.h"
#import "PDatabaseManager.h"
#import "RootViewController.h"

@interface SettingOfModifyNicknameViewController ()

@end

@implementation SettingOfModifyNicknameViewController

@synthesize textBgImageView = _textBgImageView;
@synthesize nicknameTextField = _nicknameTextField;
@synthesize lblErrorMessage = _lblErrorMessage;
@synthesize miglabApi = _miglabApi;
@synthesize updatedNickName = _updatedNickName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNicknameSuccess:) name:NotificationUpdateUserSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNickNameFailed:) name:NotificationUpdateUserFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateUserSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateUserFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav bar
    self.navView.titleLabel.text = @"修改昵称";
    self.bgImageView.hidden = YES;
    
    //body
    CGRect nicknameframe = _nicknameTextField.frame;
    nicknameframe.origin.y += self.topDistance;
    _nicknameTextField.frame = nicknameframe;
    _nicknameTextField.delegate = self;
    _nicknameTextField.returnKeyType = UIReturnKeyDone;
    _nicknameTextField.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    _nicknameTextField.text = [UserSessionManager GetInstance].currentUser.nickname;
    
    CGRect textbgframe = _nicknameTextField.frame;
    textbgframe.origin.x -= 10;
    textbgframe.size.width += 20;
    _textBgImageView.frame = textbgframe;
    
    //error
    CGRect errormessageframe = _lblErrorMessage.frame;
    errormessageframe.origin.y += self.topDistance;
    _lblErrorMessage.frame = errormessageframe;
    _lblErrorMessage.text = MIGTIP_CHANGE_NICKNAME_FAILED;
    _lblErrorMessage.hidden = YES;
    
    _miglabApi = [[MigLabAPI alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshUserInforDisplay:(NSString*)nickname birthday:(NSString*)tbirthday gender:(NSString*)tgender {
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    AccountOf3rdParty *lastAccount = [databaseManager getLastLoginUserAccount];
    
    int loginstatus = [databaseManager getLoginStatusInfo];
    
    if ( loginstatus >= 0 && lastAccount && lastAccount.accesstoken && lastAccount.accountid) {
        
        if (nickname) {
            
            [databaseManager updateNickname:nickname accountId:lastAccount.accountid];
        }
        
        if (tbirthday) {
            
            [databaseManager updateBirthday:tbirthday accountId:lastAccount.accountid];
        }
        
        if (tgender) {
            
            [databaseManager updateGender:tgender accountId:lastAccount.accountid];
        }
        
        PUser *tempuser = [databaseManager getUserInfoByAccountId:lastAccount.accountid];
        if (tempuser) {
            
            tempuser.password = lastAccount.password;
            
            [UserSessionManager GetInstance].currentUser = tempuser;
            [UserSessionManager GetInstance].userid = tempuser.userid;
            [UserSessionManager GetInstance].accesstoken = tempuser.token;
            [UserSessionManager GetInstance].accounttype = tempuser.source;
            [UserSessionManager GetInstance].isLoggedIn = YES;
        }
    }
}


-(IBAction)doSaveNickname:(id)sender{
    
    PLog(@"doSaveNickname...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeGradient ];
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        _updatedNickName = _nicknameTextField.text;
        
        [_miglabApi doUpdateUserInfoNickName:userid token:accesstoken nickname:_updatedNickName];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}

-(IBAction)doHideKeyBoard:(id)sender{
    
    PLog(@"doHideKeyBoard...");
    
    [_nicknameTextField resignFirstResponder];
    
}

-(void)ChangeNicknameSuccess:(NSNotification *)tNotification {
    
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_CHANGE_NICKNAME_SUCCESS];
    
    [self refreshUserInforDisplay:_updatedNickName birthday:nil gender:nil];
    
    RootViewController *rootViewController = [RootViewController sharedInstance];
    [self.navigationController popToViewController:rootViewController animated:YES];
    
}

-(void)ChangeNickNameFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD dismiss];
    
    _lblErrorMessage.hidden = NO;
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    _lblErrorMessage.hidden = YES;
    
    [self doSaveNickname:nil];
    
    return YES;
}

@end
