//
//  NearMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicBodyHeadMenuView.h"
#import <CoreLocation/CoreLocation.h>

//附近的好音乐
@interface NearMusicViewController : PlayerViewController<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

//gps定位
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) MusicBodyHeadMenuView *bodyHeadMenuView;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, assign) BOOL isLoadMore;
@property (nonatomic, retain) NSString *location;   //gps坐标

@property (nonatomic, assign) int dataStatus;       //1-normal，2-编辑
@property (nonatomic, assign) int isUpdateLocation;

@property (nonatomic, retain) NSMutableDictionary *dicSelectedSongId;

-(void)loadData;
-(void)loadNearMusicFromDatabase;
-(void)loadNearMusicFromServer:(NSString *)tLocation;

-(void)getNearMusicFailed:(NSNotification *)tNotification;
-(void)getNearMusicSuccess:(NSNotification *)tNotification;

-(IBAction)doSearch:(id)sender;

-(IBAction)doEdit:(id)sender;
-(IBAction)doSelectedIcon:(id)sender;

// 查看用户信息
-(IBAction)checkNearMusicUserInfo:(id)sender;

@end
