//
//  LoginViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@interface LoginViewController : UIViewController<SinaWeiboDelegate, SinaWeiboRequestDelegate>

-(IBAction)doLoginAction:(id)sender;
-(IBAction)doGotoRegisterAction:(id)sender;
-(IBAction)doSinaLoginAction:(id)sender;

@end
