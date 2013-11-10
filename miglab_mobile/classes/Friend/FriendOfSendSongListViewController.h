//
//  FriendOfSendSongListViewController.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface FriendOfSendSongListViewController : PlayerViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* songTableView;
@property (nonatomic, retain) NSMutableArray* songData;

-(void)loadData;

-(void)LoadMyMusicFromServer;
-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification;
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification;

@end
