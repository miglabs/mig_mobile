//
//  FriendOfReceiveMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "MusicCommentViewController.h"
#import "FriendOfMessageContentView.h"

@interface FriendOfReceiveMusicViewController : BaseViewController

@property (nonatomic, retain) MigLabAPI* miglabAPI;
@property (nonatomic, retain) MessageInfo* msginfo;
@property (nonatomic, retain) MusicCommentPlayerView* musicCommentHeader;
@property (nonatomic, retain) FriendOfMessageContentView* messageContentView;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) BOOL isFirstPlay;

-(IBAction)doSendSong:(id)sender;
-(IBAction)doLoadChat:(id)sender;
-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doCollectedOrCancel:(id)sender;
-(IBAction)doHate:(id)sender;

-(void)updateDisplayInfo;

-(void)doCollectedSuccess:(NSNotification*)tNotification;
-(void)doCollectedFailed:(NSNotification*)tNotification;

-(void)doCancelSuccess:(NSNotification*)tNotification;
-(void)doCancelFailed:(NSNotification*)tNotification;

@end
