//
//  RegisterOfNickNameViewController.h
//  miglab_mobile
//
//  Created by pig on 13-7-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterOfNickNameViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *nicknameTextField;

-(IBAction)doBack:(id)sender;
-(IBAction)doRegisterFinish:(id)sender;

@end
