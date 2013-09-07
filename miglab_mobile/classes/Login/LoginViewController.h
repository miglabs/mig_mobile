//
//  LoginViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "MigLabAPI.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doLoginAction:(id)sender;
-(void)loginFailed:(NSNotification *)tNotification;
-(void)loginSuccess:(NSNotification *)tNotification;
-(void)getUserInfoFailed:(NSNotification *)tNotification;
-(void)getUserInfoSuccess:(NSNotification *)tNotification;
-(IBAction)doForgetPassword:(id)sender;
-(IBAction)doHideKeyBoard:(id)sender;

@end
