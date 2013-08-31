//
//  NearMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicBodyHeadMenuView.h"

//附近的好音乐
@interface NearMusicViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) MusicBodyHeadMenuView *bodyHeadMenuView;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

@property (nonatomic, assign) int dataStatus;       //1-normal，2-编辑

@property (nonatomic, retain) NSMutableDictionary *dicSelectedSongId;

-(void)loadData;
-(void)loadNearMusicFromDatabase;
-(void)loadNearMusicFromServer;

-(void)getCollectedSongsFailed:(NSNotification *)tNotification;
-(void)getCollectedSongsSuccess:(NSNotification *)tNotification;

-(IBAction)doSearch:(id)sender;

-(IBAction)doEdit:(id)sender;
-(IBAction)doSelectedIcon:(id)sender;

@end
