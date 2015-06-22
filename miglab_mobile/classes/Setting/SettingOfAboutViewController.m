//
//  SettingOfAboutViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfAboutViewController.h"

@interface SettingOfAboutViewController ()

@end

@implementation SettingOfAboutViewController

@synthesize iconImageView = _iconImageView;
@synthesize lblVersion = _lblVersion;

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
    self.navView.titleLabel.text = @"关于咪哟";
    self.bgImageView.hidden = YES;
    
    //icon
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.frame = CGRectMake((kMainScreenWidth - 86) / 2, posy + 55, 85.5f, 85.5f);
    _iconImageView.image = [UIImage imageWithName:@"about_icon" type:@"png"];
    [self.view addSubview:_iconImageView];
    
    //version
    NSString *strVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    _lblVersion = [[UILabel alloc] init];
    _lblVersion.frame = CGRectMake(10, posy + 55 + 85 + 15, 300, 25);
    _lblVersion.backgroundColor = [UIColor clearColor];
    _lblVersion.text = [NSString stringWithFormat:@"咪哟 V%@", strVersion];
    _lblVersion.textColor = [UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    _lblVersion.font = [UIFont fontOfSystem:15.0f];
    _lblVersion.textAlignment = kTextAlignmentCenter;
    [self.view addSubview:_lblVersion];
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 55 + 85 + 15 + 25 + 50, 320, 150) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = YES;
    [self.view addSubview:_dataTableView];
    
    _datalist = [NSMutableArray arrayWithObjects:@"检查新版本", @"使用条款与隐私政策", nil];
    
    
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
        
//        SettingOfNetworkAndLimitViewController *networkAndLimit = [[SettingOfNetworkAndLimitViewController alloc] initWithNibName:@"SettingOfNetworkAndLimitViewController" bundle:nil];
//        [self.navigationController pushViewController:networkAndLimit animated:YES];
        
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
    
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
