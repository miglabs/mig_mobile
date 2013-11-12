//
//  FriendOfRecommendMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"
#import "FriendOfSendSongListViewController.h"

@interface FriendOfRecommendMusicViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate, FriendOfSendSongListViewControllerDelegate>

@property (nonatomic, retain) UITableView* sendsongTableView;
@property (nonatomic, retain) NSMutableArray* sendsongData;

@property (nonatomic, retain) NearbyUser* toUserInfo;
@property (nonatomic, assign) BOOL isSendingSong;

-(IBAction)doBack:(id)sender;

-(void)doGetSongList:(id)sender;

-(void)loadData;

-(void)SendMusicToUser:(NSString*)songid;
-(void)SendMusicToUserSuccess:(NSNotification*)tNotification;
-(void)SendMusicToUserFailed:(NSNotification*)tNotification;

@end
