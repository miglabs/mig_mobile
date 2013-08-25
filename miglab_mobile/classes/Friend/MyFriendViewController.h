//
//  MyFriendViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"
#import "FriendSearchView.h"

@interface MyFriendViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) FriendSearchView *searchView;

@property (nonatomic, retain) UITableView *friendTableView;
@property (nonatomic, retain) NSMutableArray *friendList;

-(IBAction)doBack:(id)sender;
-(IBAction)doAddFriend:(id)sender;

-(IBAction)doSearch:(id)sender;

@end
