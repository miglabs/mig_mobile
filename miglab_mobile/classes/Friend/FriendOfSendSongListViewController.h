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

-(BOOL)didChooseTheSong:(NSArray*)cursongs;

@end

@interface FriendOfSendSongListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView* songTableView;
@property (nonatomic, retain) NSMutableArray* songData;

@property (nonatomic, assign) id<FriendOfSendSongListViewControllerDelegate> delegate;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(void)loadData;

-(void)LoadMyMusicFromServer;
-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification;
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification;

-(IBAction)finishChooseSongs:(id)sender;

@end
