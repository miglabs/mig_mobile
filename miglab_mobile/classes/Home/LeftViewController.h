//
//  LeftViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface LeftViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;

@property (nonatomic, retain) IBOutlet UIView *topUserInfoView;
@property (nonatomic, retain) IBOutlet EGOImageButton *btnUserAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblUserNickName;
@property (nonatomic, retain) IBOutlet UIImageView *userGenderImageView;

@property (nonatomic, retain) UITableView *menuTableView;
@property (nonatomic, retain) NSArray *tableTitles;

@end
