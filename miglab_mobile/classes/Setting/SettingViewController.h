//
//  SettingViewController.h
//  miglab_mobile
//
//  Created by pig on 13-9-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) UIDatePicker* datePicker;

-(IBAction)doLogout:(id)sender;

-(IBAction)popDatePicker:(id)sender;
-(IBAction)resetDatePicker:(id)sender;

@end
