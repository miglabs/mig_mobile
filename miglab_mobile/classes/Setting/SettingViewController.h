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
//适配IOS8
@property (nonatomic, retain) UIAlertController* dataContorller;

@property (nonatomic, retain) MigLabAPI* miglabApi;
@property (nonatomic, assign) CHANGE_ID nChangeID; // 0:birthday, 1:gender
@property (nonatomic, retain) NSString* updatedBirthday;
@property (nonatomic, retain) NSString* updatedGender;

-(IBAction)doLogout:(id)sender;

/* 修改生日 */
-(IBAction)popDatePicker:(id)sender;
-(void)resetDatePicker;

/* 修改性别 */
-(IBAction)popGenderPicker:(id)sender;
-(void)resetGenderPicker:(int)tgender;

/* 修改生日，性别和昵称后，刷新当前显示内容 */
-(void)refreshUserInforDisplay:(NSString*)nickname birthday:(NSString*)tbirthday gender:(NSString*)tgender;


-(void)doChangeBirthdaySuccess:(NSNotification*)tNotification;
-(void)doChangeBirthdayFailed:(NSNotification*)tNotification;

@end
