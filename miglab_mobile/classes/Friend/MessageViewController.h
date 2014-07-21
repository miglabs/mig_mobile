//
//  MessageViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface MessageViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) NearbyUser* userinfo;
@property (nonatomic, retain) EGORefreshTableHeaderView* refreshHeaderView;
@property (nonatomic, retain) EGORefreshTableHeaderView* refreshFooterView;

@property (nonatomic, assign) int msgCurStartIndex;
@property (nonatomic, assign) int totalMsgCount;
@property (nonatomic, assign) BOOL isLoadingMsg;
@property (nonatomic, assign) BOOL reloading;

-(void)loadData;
-(void)loadMessageFromDatabase;
-(void)loadMessageFromServer:(int)startindex size:(int)tsize;

-(void)loadMessageFailed:(NSNotification *)tNotification;
-(void)loadMessageSuccess:(NSNotification *)tNotification;

@end
