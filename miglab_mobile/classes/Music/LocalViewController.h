//
//  LocalViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface LocalViewController : PlayerViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *dataList;

-(void)doRecordLocalSongInfo:(NSMutableArray *)datalist;

@end
