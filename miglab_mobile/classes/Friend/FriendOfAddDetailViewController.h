//
//  FriendOfAddDetailViewController.h
//  miglab_mobile
//
//  Created by pig on 13-9-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface FriendOfAddDetailViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;

@property (nonatomic, retain) NSString *addDetailTitle;
@property (nonatomic, assign) int addDetailType;        //1-手机，2-sina，3－tencent

@end
