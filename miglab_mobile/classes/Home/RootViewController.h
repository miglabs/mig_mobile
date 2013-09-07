//
//  RootViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "RootNavigationMenuView.h"
#import "MigLabAPI.h"
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : BaseViewController<CLLocationManagerDelegate>

//gps定位
@property (nonatomic, retain) CLLocationManager *locationManager;

//启动图标志
@property (assign) BOOL isFirstWillAppear;
@property (assign) BOOL isFirstDidAppear;

@property (nonatomic, retain) RootNavigationMenuView *rootNavMenuView;
@property (nonatomic, retain) NSMutableDictionary *dicViewControllerCache;
@property (nonatomic, assign) int currentShowViewTag;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)segmentAction:(id)sender;
-(void)doUpdateView:(int)viewtag;
-(UIViewController *)getControllerBySegIndex:(int)segindex;

//登录，获取用户资料
-(void)initUserData;
-(void)getGuestInfoFailed:(NSNotification *)tNotification;
-(void)getGuestInfoSuccess:(NSNotification *)tNotification;
-(void)loginFailed:(NSNotification *)tNotification;
-(void)loginSuccess:(NSNotification *)tNotification;
-(void)getUserInfoFailed:(NSNotification *)tNotification;
-(void)getUserInfoSuccess:(NSNotification *)tNotification;
-(void)getTypeSongsFailed:(NSNotification *)tNotification;
-(void)getTypeSongsSuccess:(NSNotification *)tNotification;

-(void)setUserPosFailed:(NSNotification *)tNotification;
-(void)setUserPosSuccess:(NSNotification *)tNotification;

@end
