//
//  SettingOfFunctionViewController.m
//  miglab_mobile
//
//  Created by apple on 13-9-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfFunctionViewController.h"
#import "SettingOfNewMessageViewController.h"
#import "SettingOfNetworkAndLimitViewController.h"

@interface SettingOfFunctionViewController ()

@end

@implementation SettingOfFunctionViewController

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
    self.navView.titleLabel.text = @"功能设置";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 10, 320, kMainScreenHeight + self.topDistance - posy - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    _datalist = [NSMutableArray arrayWithObjects:@"新消息提醒", @"设定网络与流量限额", @"定时收听", @"定时停止收听", @"缓存歌曲数设定", @"耳机线控操作", @"已过滤歌曲", nil];
    
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
    
    if (indexPath.row == 0) {
        
        SettingOfNewMessageViewController *newMessage = [[SettingOfNewMessageViewController alloc] initWithNibName:@"SettingOfNewMessageViewController" bundle:nil];
        [self.navigationController pushViewController:newMessage animated:YES];
        
    } else if (indexPath.row == 1) {
        
        SettingOfNetworkAndLimitViewController *networkAndLimit = [[SettingOfNetworkAndLimitViewController alloc] initWithNibName:@"SettingOfNetworkAndLimitViewController" bundle:nil];
        [self.navigationController pushViewController:networkAndLimit animated:YES];
        
    }
    
    //
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datalist count];
    
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
    
    //desc
    lblDesc.text = [_datalist objectAtIndex:indexPath.row];
    
    if (indexPath.row > 1 && indexPath.row < 5) {
        
        //content
        UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 255, 24)];
        [lblContent setBackgroundColor:[UIColor clearColor]];
        [lblContent setTextAlignment:kTextAlignmentRight];
        [lblContent setFont:[UIFont systemFontOfSize:13]];
        [lblContent setTextColor:[UIColor grayColor]];
        [cell.contentView addSubview:lblContent];
        
        if (indexPath.row == 2) {
            
            lblContent.text = @"未设定";
            
        } else if (indexPath.row == 3) {
            
            lblContent.text = @"60分钟后";
            
        } else if (indexPath.row == 4) {
            
            lblContent.text = @"1/200";
            
        }
        
    }
    
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
