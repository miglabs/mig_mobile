//
//  LoginMenuViewController.h
//  miglab_mobile
//
//  Created by apple on 13-10-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "DoubanAuthorizeView.h"
#import "MigLabAPI.h"

@interface LoginMenuViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate, TencentSessionDelegate, DoubanAuthorizeViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

//tencent
@property (nonatomic, retain) TencentOAuth *tencentOAuth;
@property (nonatomic, retain) NSArray *permissions;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doGotoRegister:(id)sender;
-(IBAction)doSinaWeiboLogin:(id)sender;
-(IBAction)doQQLogin:(id)sender;
-(IBAction)doDouBanLogin:(id)sender;
-(IBAction)doMiglabLogin:(id)sender;

-(void)didFinishLogin;
-(void)didFinishLogout;
-(void)SendDeviceToken;

-(void)registerFailed:(NSNotification *)tNotification;
-(void)registerSuccess:(NSNotification *)tNotification;
-(void)getUserInfoFailed:(NSNotification *)tNotification;
-(void)getUserInfoSuccess:(NSNotification *)tNotification;

@end
