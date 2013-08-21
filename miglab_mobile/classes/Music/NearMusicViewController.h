//
//  NearMusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"
#import "MigLabAPI.h"

//附近的好音乐
@interface NearMusicViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) UITableView *songTableView;
@property (nonatomic, retain) NSMutableArray *songList;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doBack:(id)sender;
-(IBAction)doSearch:(id)sender;

@end
