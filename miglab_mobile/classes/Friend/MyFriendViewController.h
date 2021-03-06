//
//  MyFriendViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "FriendSearchView.h"
#import "EGORefreshTableHeaderView.h"

@interface MyFriendViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, EGORefreshTableHeaderDelegate>

@property (nonatomic, retain) FriendSearchView *searchView;
@property (nonatomic, retain) UITableView *friendTableView;
@property (nonatomic, retain) NSMutableArray *friendList;
@property (nonatomic, retain) EGORefreshTableHeaderView* refreshHeaderView;
@property (nonatomic, retain) EGORefreshTableHeaderView* refreshFooterView;

@property (nonatomic, assign) int friendCurStartIndex;
@property (nonatomic, assign) int totalFriendCount;
@property (nonatomic, assign) BOOL isLoadingFriend;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, assign) BOOL isHeaderLoading;

-(void)loadData;
-(void)loadMusicUserFromServer:(int)start size:(int)tsize;
-(void)loadMusicUserFromDatabase;

-(void)getMusicUserSuccess:(NSNotification*)tNotification;
-(void)getMusicUserFailed:(NSNotification *)tNotification;

-(IBAction)doAddFriend:(id)sender;

-(IBAction)doSearch:(id)sender;

@end
