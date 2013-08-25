//
//  MessageViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "PCustomNavigationBarView.h"

@interface MessageViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;

-(IBAction)doBack:(id)sender;

@end
