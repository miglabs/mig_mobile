//
//  LoginChooseViewController.h
//  miglab_mobile
//
//  Created by pig on 13-7-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <libDoubanAPIEngine/DOUService.h>
#import "MigLabAPI.h"

@interface LoginChooseViewController : UIViewController<SinaWeiboDelegate, SinaWeiboRequestDelegate, TencentSessionDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnTopMenu;
@property (nonatomic, retain) IBOutlet UIButton *btnTopRegister;
@property (nonatomic, retain) IBOutlet UIButton *btnSinaWeibo;
@property (nonatomic, retain) IBOutlet UIButton *btnQQ;
@property (nonatomic, retain) IBOutlet UIButton *btnDouBan;
@property (nonatomic, retain) IBOutlet UIButton *btnMiglab;

//tencent
@property (nonatomic, retain) TencentOAuth *tencentOAuth;
@property (nonatomic, retain) NSMutableArray *permissions;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doShowLeftMenu:(id)sender;
-(IBAction)doGotoRegister:(id)sender;
-(IBAction)doSinaWeiboLogin:(id)sender;
-(IBAction)doQQLogin:(id)sender;
-(IBAction)doDouBanLogin:(id)sender;
-(IBAction)doMiglabLogin:(id)sender;
-(void)doGotoMainMenuView;

-(void)registerFailed:(NSNotification *)tNotification;
-(void)registerSuccess:(NSNotification *)tNotification;
-(void)getUserInfoFailed:(NSNotification *)tNotification;
-(void)getUserInfoSuccess:(NSNotification *)tNotification;

@end
