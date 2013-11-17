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

@property (nonatomic, retain) MessageInfo* msginfo;
@property (nonatomic, retain) MusicCommentPlayerView* musicCommentHeader;
@property (nonatomic, retain) FriendOfMessageContentView* messageContentView;
@property (nonatomic, assign) BOOL isFriend;

-(IBAction)doSendSong:(id)sender;

@end
