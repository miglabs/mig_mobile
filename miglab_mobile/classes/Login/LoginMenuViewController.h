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
@property (nonatomic, retain) NSMutableArray *permissions;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

@end
