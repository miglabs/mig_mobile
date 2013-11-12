//
//  FriendOfSendSongListViewController.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@protocol FriendOfSendSongListViewControllerDelegate <NSObject>

-(void)didChooseTheSong:(Song*)cursong;

@end

@interface FriendOfSendSongListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSObject<FriendOfSendSongListViewControllerDelegate>* delegate;
}

@property (nonatomic, retain) UITableView* songTableView;
@property (nonatomic, retain) NSMutableArray* songData;
@property (nonatomic, retain) Song* chosedSong;
@property (nonatomic, retain) MigLabAPI* miglabAPI;
@property (nonatomic, retain) NSObject<FriendOfSendSongListViewControllerDelegate>* delegate;

-(void)loadData;

-(void)LoadMyMusicFromServer;
-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification;
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification;

@end
