//
//  SettingOfAddFriendViewController.h
//  miglab_mobile
//
//  Created by pig on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingOfAddFriendViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;

@end
