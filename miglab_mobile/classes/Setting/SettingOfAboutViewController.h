//
//  SettingOfAboutViewController.h
//  miglab_mobile
//
//  Created by pig on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingOfAboutViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *lblVersion;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;

@end
