//
//  FriendOfSendSongListViewController.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "UserSessionManager.h"
#import "MigLabAPI.h"

@protocol FriendOfSendSongListViewControllerDelegate <NSObject>

-(void)didChooseTheSong:(Song*)cursong;

@end

@interface FriendOfSendSongListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* songTableView;
@property (nonatomic, retain) NSMutableArray* songData;
@property (nonatomic, retain) Song* chosedSong;

@property (nonatomic, assign) id<FriendOfSendSongListViewControllerDelegate> delegate;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(void)loadData;

-(void)LoadMyMusicFromServer;
-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification;
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification;

@end
