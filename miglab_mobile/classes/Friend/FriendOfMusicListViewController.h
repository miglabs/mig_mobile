//
//  FriendOfMusicListViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"

@interface FriendOfMusicListViewController : PlayerViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;

-(IBAction)doBack:(id)sender;

@end
