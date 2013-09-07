//
//  SettingOfAddFriendViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfAddFriendViewController.h"

@interface SettingOfAddFriendViewController ()

@end

@implementation SettingOfAddFriendViewController

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
    
    //nav bar
    self.navView.titleLabel.text = @"加好友权限设置";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 + 10, 320, kMainScreenHeight - 45 - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    NSArray *section0 = [NSArray arrayWithObjects:@"加我为好友时需要验证", nil];
    NSArray *section1 = [NSArray arrayWithObjects:@"回复歌友自动添加对方为好友", nil];
    _datalist = [NSArray arrayWithObjects:section0, section1, nil];
    
    
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
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PLog(@"section: %d", section);
    NSArray *sectionMenu = [_datalist objectAtIndex:section];
    return sectionMenu.count;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        return @"需要通过你验证后才能成为好友";
    } else if (section == 1) {
        return @"关闭后仅仅只是对话";
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
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
