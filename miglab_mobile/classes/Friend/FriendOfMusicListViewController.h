//
//  FriendOfMusicListViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface FriendOfMusicListViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) NearbyUser* userinfo;

-(void)loaddata;

-(void)LoadMusicListFromServer;
-(void)LoadMusicListFromServerSuccess:(NSNotification*)tNotification;
-(void)LoadMusicListFromServerFailed:(NSNotification *)tNotification;

@end
