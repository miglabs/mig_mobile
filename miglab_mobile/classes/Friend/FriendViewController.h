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

// 是否更新了一次位置，防止位置一次更新多次调用回调函数（因为多次回调函数的精度不同）
@property (nonatomic, assign) BOOL isUpdateLocation;

// 是否首次载入该页面，防止ViewDidAppear多次调用更新数据
@property (nonatomic, assign) BOOL isFirstLoadView;

-(void)updateDisplayNumber;

-(void)updateLocation;

-(void)loadNumbersFromServer:(NSString*)tlocation;
-(void)getNumbersSuccess:(NSNotification*)tNotification;
-(void)getNumbersFailed:(NSNotification*)tNotification;

@end
