//
//  SettingViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingOfModifyNicknameViewController.h"
#import "SettingOfPrivacyViewController.h"
#import "SettingOfFunctionViewController.h"
#import "UMFeedback.h"
#import "SettingOfAboutViewController.h"
#import "UserSessionManager.h"
#import "PDatabaseManager.h"
#import "SVProgressHUD.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;
@synthesize dateSheet = _dateSheet;
@synthesize miglabApi = _miglabApi;
@synthesize nChangeID = _nChangeID;
@synthesize updatedBirthday = _updatedBirthday;
@synthesize updatedGender = _updatedGender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeBirthdaySuccess:) name:NotificationUpdateUserSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doChangeBirthdayFailed:) name:NotificationUpdateUserFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateUserSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationUpdateUserFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _nChangeID = CHANGE_ID_NONE;
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"设置";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 10, 320, kMainScreenHeight + self.topDistance - posy - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = YES;
    [self.view addSubview:_dataTableView];
    
#if USE_NICKNAME_SETTING
    NSArray *section0 = [NSArray arrayWithObjects:@"昵称", @"生日", @"性别", nil];
#else
    NSArray *section0 = [NSArray arrayWithObjects:@"生日", @"性别", nil];
#endif
    
#if USE_PRIVATE && USE_FUNCTION_SETTING
    NSArray *section1 = [NSArray arrayWithObjects:@"隐私", @"功能", @"意见反馈", nil];
#elif USE_PRIVATE
    NSArray *section1 = [NSArray arrayWithObjects:@"隐私", @"向我吐槽", nil];
#elif USE_FUNCTION_SETTING
    NSArray *section1 = [NSArray arrayWithObjects:@"功能", @"向我吐槽", nil];
#else
    NSArray *section1 = [NSArray arrayWithObjects:@"向我吐槽", nil];
#endif
    
    NSArray *section2 = [NSArray arrayWithObjects:@"关于咪呦", nil];
    NSArray *section3 = [NSArray arrayWithObjects:@"退出登录", nil];
    _datalist = [NSMutableArray arrayWithObjects:section0, section1, section2, section3, nil];
    
    _miglabApi = [[MigLabAPI alloc] init];
}

-(void)refreshUserInforDisplay:(NSString*)nickname birthday:(NSString*)tbirthday gender:(NSString*)tgender {
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    AccountOf3rdParty *lastAccount = [databaseManager getLastLoginUserAccount];
    
    int loginstatus = [databaseManager getLoginStatusInfo];
    
    if ( loginstatus && lastAccount && lastAccount.accesstoken && lastAccount.accountid) {
        
        if (nickname) {
            
            [databaseManager updateNickname:nickname accountId:lastAccount.accountid];
        }
        
        if (tbirthday) {
            
            [databaseManager updateBirthday:tbirthday accountId:lastAccount.accountid];
        }
        
        if (tgender) {
            
            [databaseManager updateGender:tgender accountId:lastAccount.accountid];
        }
        
        PUser *tempuser = [databaseManager getUserInfoByAccountId:lastAccount.accountid];
        if (tempuser) {
            
            tempuser.password = lastAccount.password;
            
            [UserSessionManager GetInstance].currentUser = tempuser;
            [UserSessionManager GetInstance].userid = tempuser.userid;
            [UserSessionManager GetInstance].accesstoken = tempuser.token;
            [UserSessionManager GetInstance].accounttype = tempuser.source;
            [UserSessionManager GetInstance].isLoggedIn = YES;
        }
    }
}

-(IBAction)popDatePicker:(id)sender {
    
    NSString* title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n";
    
    _dateSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:MIGTIP_CANCEL destructiveButtonTitle:nil otherButtonTitles:MIGTIP_OK, nil];
    
    _dateSheet.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    
    [_dateSheet showInView:self.view];
    
    UIDatePicker* datepicker = [[UIDatePicker alloc] init];
    datepicker.datePickerMode = UIDatePickerModeDate;
    datepicker.tag = 101;
    
    [_dateSheet addSubview:datepicker];
}

-(void)resetDatePicker {
    
    UIDatePicker* datepicker = (UIDatePicker*)[_dateSheet viewWithTag:101];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    _updatedBirthday = [formatter stringFromDate:datepicker.date];
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeGradient];
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* token = [UserSessionManager GetInstance].accesstoken;
        
        [_miglabApi doUpdateUserInfoBirthday:userid token:token birthday:_updatedBirthday];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}

-(void)popGenderPicker:(id)sender {
    
    _dateSheet = [[UIActionSheet alloc] initWithTitle:@"请选择性别" delegate:self cancelButtonTitle:MIGTIP_CANCEL destructiveButtonTitle:nil otherButtonTitles:@"女", @"男", nil];
    
    _dateSheet.actionSheetStyle = self.navigationController.navigationBar.barStyle;
    
    [_dateSheet showInView:self.view];
}

-(void)resetGenderPicker:(int)tgender {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeGradient];
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* token = [UserSessionManager GetInstance].accesstoken;
        _updatedGender = [NSString stringWithFormat:@"%d", tgender];
        
        [_miglabApi doUpdateUserInfoGender:userid token:token gender:_updatedGender];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doLogout:(id)sender{
    
    PLog(@"doLogout...");
    
    UIAlertView *tempAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [tempAlertView show];
    
}

-(void)doChangeBirthdaySuccess:(NSNotification *)tNotification {
    
    [SVProgressHUD dismiss];
    
    if (_nChangeID == CHANGE_ID_BIRTHDAY) {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_CHANGE_BIRTHDAY_SUCCESS];
        
        [self refreshUserInforDisplay:nil birthday:_updatedBirthday gender:nil];
    }
    else if(_nChangeID == CHANGE_ID_GENDER) {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_CHANGE_GENDER_SUCCESS];
        
        [self refreshUserInforDisplay:nil birthday:nil gender:_updatedGender];
    }
    
    _nChangeID = CHANGE_ID_NONE;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doChangeBirthdayFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD dismiss];
    
    if (_nChangeID == CHANGE_ID_BIRTHDAY) {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_CHANGE_BIRTHDAY_FAILED];
    }
    else if(_nChangeID == CHANGE_ID_GENDER) {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_CHANGE_GENDER_FAILED];
    }
    
    _nChangeID = CHANGE_ID_NONE;
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        [[UserSessionManager GetInstance] doLogout];
        [[PDatabaseManager GetInstance] setLoginStatusInfo:0];
        
        [self doBack:nil];
        
    }
    
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            SettingOfModifyNicknameViewController *modifyNickname = [[SettingOfModifyNicknameViewController alloc] initWithNibName:@"SettingOfModifyNicknameViewController" bundle:nil];
            [self.navigationController pushViewController:modifyNickname animated:YES];
            
        }
        else if(indexPath.row == 1) {
            
            _nChangeID = CHANGE_ID_BIRTHDAY;
            
            [self popDatePicker:nil];
        }
        else if(indexPath.row == 2) {
            
            _nChangeID = CHANGE_ID_GENDER;
            
            [self popGenderPicker:nil];
        }
        
    } else if (indexPath.section == 1) {
        
        int curRow = indexPath.row;
        
#if USE_PRIVATE && USE_FUNCTION_SETTING
        
        // do nothing
        
#elif USE_PRIVATE
        
        if (curRow == 1) {
            
            curRow = 2;
        }
        
#elif USE_FUNCTION_SETTING
        
        curRow += 1;
        
#else 
        curRow = 2;
        
#endif
        if (curRow == 0) {
            
            SettingOfPrivacyViewController *privacy = [[SettingOfPrivacyViewController alloc] initWithNibName:@"SettingOfPrivacyViewController" bundle:nil];
            [self.navigationController pushViewController:privacy animated:YES];
            
        } else if (curRow == 1) {
            
            SettingOfFunctionViewController *function = [[SettingOfFunctionViewController alloc] initWithNibName:@"SettingOfFunctionViewController" bundle:nil];
            [self.navigationController pushViewController:function animated:YES];
            
        } else if (curRow == 2) {
            
            //反馈加入用户昵称
            NSString *userid = [UserSessionManager GetInstance].userid;
            NSString *nickname = [UserSessionManager GetInstance].currentUser.nickname;
            userid = userid ? userid : @"UserIdIsNull";
            nickname = nickname ? nickname : @"NickNameIsNull";
            NSString *strUserInfo = [NSString stringWithFormat:@"%@(%@)", nickname, userid];
            NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:strUserInfo, @"USER_INFO", nil];
            [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY dictionary:dicUserInfo];
            
//            [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY];
//            [UMFeedback showFeedback:self withAppkey:UMENG_APPKEY dictionary:[NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:@"a", @"b", @"c", nil] forKey:@"hello"]];
            
        }
        
    } else if (indexPath.section == 2) {
        
        //todo
        SettingOfAboutViewController *about = [[SettingOfAboutViewController alloc] initWithNibName:@"SettingOfAboutViewController" bundle:nil];
        [self.navigationController pushViewController:about animated:YES];
        
    } else if (indexPath.section == 3) {
        
        //todo
        [self doLogout:nil];
        
    }
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PLog(@"section: %d", section);
    NSArray *sectionMenu = [_datalist objectAtIndex:section];
    return sectionMenu.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    //desc
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 24)];
    [lblDesc setBackgroundColor:[UIColor clearColor]];
    [lblDesc setTextAlignment:kTextAlignmentLeft];
    [lblDesc setFont:[UIFont systemFontOfSize:15]];
    [lblDesc setTextColor:[UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f]];
    [cell.contentView addSubview:lblDesc];
    
    //arrow
    UIImageView *arrowimage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 8, 12)];
    arrowimage.image = [UIImage imageNamed:@"friend_add_friend_arrow.png"];
    [cell.contentView addSubview:arrowimage];
    
    if (indexPath.section == 0) {
        
        NSArray *section0 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section0 objectAtIndex:indexPath.row];
        
        //content
        UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 255, 24)];
        [lblContent setBackgroundColor:[UIColor clearColor]];
        [lblContent setTextAlignment:kTextAlignmentRight];
        [lblContent setFont:[UIFont systemFontOfSize:15]];
        [lblContent setTextColor:[UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f]];
        [cell.contentView addSubview:lblContent];
        
        if (indexPath.row == 0) {
            lblContent.text = [UserSessionManager GetInstance].currentUser.nickname;
        } else if (indexPath.row == 1) {
            lblContent.text = [UserSessionManager GetInstance].currentUser.birthday;
        } else if (indexPath.row == 2) {
            lblContent.text = [UserSessionManager GetInstance].currentUser.gender ? @"男" : @"女";
        }
        
    } else if (indexPath.section == 1) {
        
        NSArray *section1 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section1 objectAtIndex:indexPath.row];
        
    } else if (indexPath.section == 2) {
        
        NSArray *section2 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section2 objectAtIndex:indexPath.row];
        
    } else if (indexPath.section == 3) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *section3 = [_datalist objectAtIndex:indexPath.section];
        NSString *desc = [section3 objectAtIndex:indexPath.row];
        
        UIImage *logoutImage = [UIImage imageWithName:@"setting_button_logout_bg" type:@"png"];
        UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLogout setBackgroundImage:logoutImage forState:UIControlStateNormal];
        [btnLogout setTitle:desc forState:UIControlStateNormal];
        
        cell.backgroundView = btnLogout;
        
        arrowimage.hidden = NO;
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (_nChangeID == CHANGE_ID_BIRTHDAY) {
        
        if (buttonIndex == 0) {
            
            [self resetDatePicker];
        }
    }
    else if (_nChangeID == CHANGE_ID_GENDER) {
        
        if (buttonIndex == 0) {
            
            [self resetGenderPicker:0];
        }
        else if(buttonIndex == 1) {
            
            [self resetGenderPicker:1];
        }
    }
}

@end
