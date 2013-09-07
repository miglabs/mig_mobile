//
//  SettingOfFunctionViewController.h
//  miglab_mobile
//
//  Created by apple on 13-9-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingOfFunctionViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;

@end
