//
//  MessageViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface MessageViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) NearbyUser* userinfo;

@property (nonatomic, assign) int msgCurStartIndex;
@property (nonatomic, assign) int totalMsgCount;
@property (nonatomic, assign) BOOL isLoadingMsg;

-(void)loadData;
-(void)loadMessageFromDatabase;
-(void)loadMessageFromServer:(int)startindex size:(int)tsize;

-(void)loadMessageFailed:(NSNotification *)tNotification;
-(void)loadMessageSuccess:(NSNotification *)tNotification;


@end
