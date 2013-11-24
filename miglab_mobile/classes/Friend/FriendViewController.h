//
//  FriendViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface FriendViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) UITableView *bodyTableView;
@property (nonatomic, retain) NSArray *tableTitles;
@property (nonatomic, retain) NSMutableArray* tipNumber;
@property (nonatomic, retain) CLLocationManager* locationMng;
@property (nonatomic, assign) BOOL isUpdateLocation;

-(void)updateDisplayNumber;

-(void)updateLocation;

-(void)loadNumbersFromServer:(NSString*)tlocation;
-(void)getNumbersSuccess:(NSNotification*)tNotification;
-(void)getNumbersFailed:(NSNotification*)tNotification;

@end
