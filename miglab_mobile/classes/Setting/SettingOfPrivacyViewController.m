//
//  SettingOfPrivacyViewController.m
//  miglab_mobile
//
//  Created by apple on 13-9-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfPrivacyViewController.h"
#import "SettingOfAddFriendViewController.h"
#import "SettingOfFriendManagerViewController.h"

@interface SettingOfPrivacyViewController ()

@end

@implementation SettingOfPrivacyViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:241.0f/255.0f blue:237.0f/255.0f alpha:1.0f];
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"隐私设置";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 10, 320, kMainScreenHeight + self.topDistance - posy - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    NSArray *section0 = [NSArray arrayWithObjects:@"歌单共享", nil];
    NSArray *section1 = [NSArray arrayWithObjects:@"定位服务", nil];
    NSArray *section2 = [NSArray arrayWithObjects:@"加好友权限", @"黑名单管理", nil];
    _datalist = [NSMutableArray arrayWithObjects:section0, section1, section2, nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    if (indexPath.section == 0) {
        
        //
        
    } else if (indexPath.section == 1) {
        
        //
        
    } else if (indexPath.section == 2) {
        
        //todo
        if (indexPath.row == 0) {
            
            SettingOfAddFriendViewController *settingOfAddFriend = [[SettingOfAddFriendViewController alloc] initWithNibName:@"SettingOfAddFriendViewController" bundle:nil];
            [self.navigationController pushViewController:settingOfAddFriend animated:YES];
            
        } else if (indexPath.row == 1) {
            
            SettingOfFriendManagerViewController *friendManager = [[SettingOfFriendManagerViewController alloc] initWithNibName:@"SettingOfFriendManagerViewController" bundle:nil];
            [self.navigationController pushViewController:friendManager animated:YES];
            
        }
        
    }
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PLog(@"section: %d", section);
    NSArray *sectionMenu = [_datalist objectAtIndex:section];
    return sectionMenu.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return @"允许歌友们借用我的歌单播放歌曲";
    } else if (section == 1) {
        return @"可以查看附近的歌友并显示彼此的距离";
    }
    
    return nil;
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
    
    if (indexPath.section == 0) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *section0 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section0 objectAtIndex:indexPath.row];
        
        //switch
        UISwitch *dataSwitch = [[UISwitch alloc] init];
        CGRect switchframe = dataSwitch.frame;
        switchframe.origin.x = 290 - switchframe.size.width;
        switchframe.origin.y = (44 - switchframe.size.height) / 2;
        dataSwitch.frame = switchframe;
        [cell.contentView addSubview:dataSwitch];
        
    } else if (indexPath.section == 1) {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *section1 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section1 objectAtIndex:indexPath.row];
        
        UISwitch *dataSwitch = [[UISwitch alloc] init];
        CGRect switchframe = dataSwitch.frame;
        switchframe.origin.x = 290 - switchframe.size.width;
        switchframe.origin.y = (44 - switchframe.size.height) / 2;
        dataSwitch.frame = switchframe;
        [cell.contentView addSubview:dataSwitch];
        
    } else if (indexPath.section == 2) {
        
        //arrow
        UIImageView *arrowimage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 8, 12)];
        arrowimage.image = [UIImage imageNamed:@"friend_add_friend_arrow.png"];
        [cell.contentView addSubview:arrowimage];
        
        NSArray *section2 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section2 objectAtIndex:indexPath.row];
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
