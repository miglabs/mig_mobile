//
//  SettingViewController.h
//  miglab_mobile
//
//  Created by pig on 13-9-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

typedef enum _CHANGE_ID {
    
    CHANGE_ID_NONE = 0,
    CHANGE_ID_BIRTHDAY,
    CHANGE_ID_GENDER,
    
} CHANGE_ID;

@property (nonatomic, retain) UITableView *dataTableView;
@property (nonatomic, retain) NSMutableArray *datalist;
@property (nonatomic, retain) UIActionSheet* dateSheet;
@property (nonatomic, retain) MigLabAPI* miglabApi;
@property (nonatomic, assign) CHANGE_ID nChangeID; // 0:birthday, 1:gender

-(IBAction)doLogout:(id)sender;

-(IBAction)popDatePicker:(id)sender;
-(void)resetDatePicker;

-(IBAction)popGenderPicker:(id)sender;
-(void)resetGenderPicker:(int)tgender;

-(void)doChangeBirthdaySuccess:(NSNotification*)tNotification;
-(void)doChangeBirthdayFailed:(NSNotification*)tNotification;

@end
