//
//  NearFriendViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface NearFriendViewController : PlayerViewController<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

//gps定位
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

-(void)loadData;
-(void)loadNearFriendFromDatabase;
-(void)loadNearFriendFromServer:(NSString *)tLocation;

-(void)searchNearbyFailed:(NSNotification *)tNotification;
-(void)searchNearbySuccess:(NSNotification *)tNotification;

-(IBAction)doSearch:(id)sender;

@end
