//
//  FriendOfRecommendMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"

@interface FriendOfRecommendMusicViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* songTableView;
@property (nonatomic, retain) NSMutableArray* songData;

@property (nonatomic, retain) NearbyUser* toUserInfo;
@property (nonatomic, assign) BOOL isSendingSong;

-(IBAction)doBack:(id)sender;

-(void)loadData;

-(void)LoadMyMusicFromDatabase;

-(void)LoadMyMusicFromServer;
-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification;
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification;

-(void)SendMusicToUser:(NSString*)songid;
-(void)SendMusicToUserSuccess:(NSNotification*)tNotification;
-(void)SendMusicToUserFailed:(NSNotification*)tNotification;

@end
