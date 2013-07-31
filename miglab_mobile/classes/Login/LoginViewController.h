//
//  LoginViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *passwordTextField;

-(IBAction)doBack:(id)sender;
-(IBAction)doLoginAction:(id)sender;
-(void)loginFailed:(NSNotification *)tNotification;
-(void)loginSuccess:(NSNotification *)tNotification;

@end
