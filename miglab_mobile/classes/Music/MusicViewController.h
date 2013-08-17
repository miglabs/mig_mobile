//
//  MusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "MusicPlayerNavigationView.h"

@interface MusicViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) MusicPlayerNavigationView *navView;

@property (nonatomic, retain) UITableView *bodyTableView;
@property (nonatomic, retain) NSArray *tableTitles;



-(IBAction)doNavigationAvatar:(id)sender;
-(IBAction)doNavigationFirst:(id)sender;
-(IBAction)doNavigationSecond:(id)sender;


@end
