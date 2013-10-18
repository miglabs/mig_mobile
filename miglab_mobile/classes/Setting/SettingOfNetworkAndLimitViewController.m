//
//  SettingOfNetworkAndLimitViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfNetworkAndLimitViewController.h"
#import "SettingOfLimitViewController.h"

@interface SettingOfNetworkAndLimitViewController ()

@end

@implementation SettingOfNetworkAndLimitViewController

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
    self.navView.titleLabel.text = @"设定网络与流量限额";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 10, 320, kMainScreenHeight + self.topDistance - posy - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    NSArray *section0 = [NSArray arrayWithObjects:@"仅在wifi下使用在线推荐", @"所有网络下均使用在线推荐", nil];
    NSArray *section1 = [NSArray arrayWithObjects:@"流量限额指定", nil];
    _datalist = [NSMutableArray arrayWithObjects:section0, section1, nil];
    
    
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
        if (indexPath.row == 0) {
            
            SettingOfLimitViewController *limit = [[SettingOfLimitViewController alloc] initWithNibName:@"SettingOfLimitViewController" bundle:nil];
            [self.navigationController pushViewController:limit animated:YES];
            
        }
        
    }
    
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
        
        //arrow
        UIImageView *arrowimage = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 8, 12)];
        arrowimage.image = [UIImage imageNamed:@"friend_add_friend_arrow.png"];
        [cell.contentView addSubview:arrowimage];
        
        NSArray *section2 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section2 objectAtIndex:indexPath.row];
        
        //content
        UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 255, 24)];
        [lblContent setBackgroundColor:[UIColor clearColor]];
        [lblContent setTextAlignment:kTextAlignmentRight];
        [lblContent setFont:[UIFont systemFontOfSize:13]];
        [lblContent setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblContent];
        
        if (indexPath.row == 0) {
            
            lblContent.text = @"未设定";
            
        }
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
