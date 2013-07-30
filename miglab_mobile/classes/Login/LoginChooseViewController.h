//
//  LoginChooseViewController.h
//  miglab_mobile
//
//  Created by pig on 13-7-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginChooseViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnTopMenu;
@property (nonatomic, retain) IBOutlet UIButton *btnTopRegister;
@property (nonatomic, retain) IBOutlet UIButton *btnSinaWeibo;
@property (nonatomic, retain) IBOutlet UIButton *btnQQ;
@property (nonatomic, retain) IBOutlet UIButton *btnDouBan;
@property (nonatomic, retain) IBOutlet UIButton *btnMiglab;

-(IBAction)doShowLeftMenu:(id)sender;
-(IBAction)doGotoRegister:(id)sender;
-(IBAction)doSinaWeiboLogin:(id)sender;
-(IBAction)doQQLogin:(id)sender;
-(IBAction)doDouBanLogin:(id)sender;
-(IBAction)doMiglabLogin:(id)sender;

@end
