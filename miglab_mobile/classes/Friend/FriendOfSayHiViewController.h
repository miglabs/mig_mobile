//
//  FriendOfSayHiViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"

@interface FriendOfSayHiViewController : PlayerViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;

-(IBAction)doBack:(id)sender;

@end