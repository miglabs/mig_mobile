//
//  OnlineViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicBodyHeadMenuView.h"
#import "MusicSortMenuView.h"

@interface OnlineViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) MusicBodyHeadMenuView *bodyHeadMenuView;
@property (nonatomic, retain) MusicSortMenuView *sortMenuView;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

@property (nonatomic, assign) int dataStatus;       //1-normal，2-编辑

@property (nonatomic, retain) NSMutableDictionary *dicSelectedSongId;

-(void)loadData;
-(void)loadOnlineMusicFromDatabase;

-(void)getTypeSongsFailed:(NSNotification *)tNotification;
-(void)getTypeSongsSuccess:(NSNotification *)tNotification;

-(IBAction)doSort:(id)sender;
-(IBAction)doEdit:(id)sender;

-(IBAction)doSortMenu1:(id)sender;
-(IBAction)doSortMenu2:(id)sender;
-(IBAction)doSortMenu3:(id)sender;
-(void)doSortOnlinedData:(int)tSortType;

-(IBAction)doSelectedIcon:(id)sender;

@end
