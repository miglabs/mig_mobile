//
//  FriendOfAddDetailViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-3.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfAddDetailViewController.h"

@interface FriendOfAddDetailViewController ()

@end

@implementation FriendOfAddDetailViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;

@synthesize addDetailTitle = _addDetailTitle;
@synthesize addDetailType = _addDetailType;

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
    self.navView.titleLabel.text = _addDetailTitle;
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, 44 + 10, 297, kMainScreenHeight - 44 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_dataTableView];
    
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datalist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"TableViewCell";
	UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:CellIdentifier];
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
        NSDictionary *dicMenu = [section0 objectAtIndex:indexPath.row];
        lblDesc.text = [dicMenu objectForKey:@"MenuText"];
        
    } else if (indexPath.section == 1) {
        
        NSArray *section1 = [_datalist objectAtIndex:indexPath.section];
        NSDictionary *dicMenu = [section1 objectAtIndex:indexPath.row];
        lblDesc.text = [dicMenu objectForKey:@"MenuText"];
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
