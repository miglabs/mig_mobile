//
//  ShareViewController.h
//  miglab_mobile
//
//  Created by pig on 13-10-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "ShareContentView.h"
#import "ShareMenuView.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ShareViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;

@property (nonatomic, retain) ShareContentView *shareContentView;

@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSArray *permissions;

@property (nonatomic, assign) BOOL isShare2SinaWeibo;
@property (nonatomic, assign) BOOL isShare2TencentWeibo;
@property (nonatomic, assign) BOOL isShare2QQZone;

-(IBAction)doShare:(id)sender;
-(void)doShare2SinaWeibo;
-(void)doShare2TencentWeibo;
-(void)doShare2QQZone;

-(IBAction)doHideKeyborad:(id)sender;
-(IBAction)doShowAt:(id)sender;

@end
