//
//  FriendOfAddViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfAddViewController.h"
#import "FriendOfAddDetailViewController.h"

@interface FriendOfAddViewController ()

@end

@implementation FriendOfAddViewController

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
    self.navView.titleLabel.text = @"添加好友";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    NSArray *section0 = [NSArray arrayWithObjects:@"从手机通讯录里添加", nil];
    NSArray *section1 = [NSArray arrayWithObjects:@"从新浪微博添加好友", @"从腾讯微博添加好友", nil];
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
    
    FriendOfAddDetailViewController *addDetail = [[FriendOfAddDetailViewController alloc] initWithNibName:@"FriendOfAddDetailViewController" bundle:nil];
    
    
    if (indexPath.section == 0) {
        
        //todo
        addDetail.addDetailTitle = @"手机通讯录";
        addDetail.addDetailType = 1;
        
    } else if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            addDetail.addDetailTitle = @"新浪微博好友";
            addDetail.addDetailType = 2;
            
        } else if (indexPath.row == 1) {
            
            addDetail.addDetailTitle = @"腾讯微博好友";
            addDetail.addDetailType = 3;
            
        }
        
    }
    
    [self.navigationController pushViewController:addDetail animated:YES];
    
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
    
//    return [_datalist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    //desc
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 200, 24)];
    [lblDesc setBackgroundColor:[UIColor clearColor]];
    [lblDesc setTextAlignment:kTextAlignmentLeft];
    [lblDesc setFont:[UIFont systemFontOfSize:15]];
    [lblDesc setTextColor:[UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f]];
    [cell.contentView addSubview:lblDesc];
    
    //arrow
    UIImageView *arrowimage = [[UIImageView alloc] initWithFrame:CGRectMake(250, 16, 8, 12)];
    arrowimage.image = [UIImage imageNamed:@"friend_add_friend_arrow.png"];
    [cell.contentView addSubview:arrowimage];
    
    if (indexPath.section == 0) {
        
        NSArray *section0 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section0 objectAtIndex:indexPath.row];
        
    } else if (indexPath.section == 1) {
        
        NSArray *section1 = [_datalist objectAtIndex:indexPath.section];
        lblDesc.text = [section1 objectAtIndex:indexPath.row];
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
