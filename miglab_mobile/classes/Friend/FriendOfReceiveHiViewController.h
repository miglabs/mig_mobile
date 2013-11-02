//
//  FriendOfReceiveHiViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "FriendMessageUserHead.h"

@interface FriendOfReceiveHiViewController : PlayerViewController

@property (nonatomic, retain) FriendMessageUserHead *userHeadView;
@property (nonatomic, retain) MessageInfo* msginfo;

@property (nonatomic, retain) IBOutlet UIView *messageContentView;

@end
