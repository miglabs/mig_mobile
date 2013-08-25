//
//  FriendOfReceiveHiViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"
#import "FriendMessageUserHead.h"

@interface FriendOfReceiveHiViewController : PlayerViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) FriendMessageUserHead *userHeadView;

@property (nonatomic, retain) IBOutlet UIView *messageContentView;

-(IBAction)doBack:(id)sender;

@end
