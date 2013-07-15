//
//  RegisterViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

-(IBAction)doRegisterAction:(id)sender;
-(void)registerFailed:(NSNotification *)tNotification;
-(void)registerSuccess:(NSNotification *)tNotification;

@end
