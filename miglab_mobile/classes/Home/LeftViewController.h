//
//  LeftViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, retain) NSArray *tableTitles;

@end
