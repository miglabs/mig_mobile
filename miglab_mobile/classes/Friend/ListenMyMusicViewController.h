//
//  ListenMyMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ListenMyMusicViewController : PlayerViewController <UITableViewDataSource, UITableViewDelegate>

//gps 定位
//@property (nonatomic, retain) CLLocationManager* locationManager;

@property (nonatomic, retain) UITableView* dataTableView;
@property (nonatomic, retain) NSMutableArray* dataList;
@property (nonatomic, assign) BOOL isUpdatedLocation;

-(void)loadData;
-(void)loadNearFriendFromDatabase;
-(void)LoadListeningMyFavorateMusic:(NSString*)location;

-(void)LoadListeningMyFavorateMusicSuccess:(NSNotification*)tNotification;
-(void)LoadListeningMyFavorateMusicFailed:(NSNotification*)tNotification;

@end
