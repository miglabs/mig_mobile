//
//  SettingOfNewMessageViewController.m
//  miglab_mobile
//
//  Created by pig on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingOfNewMessageViewController.h"

@interface SettingOfNewMessageViewController ()

@end

@implementation SettingOfNewMessageViewController

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
    self.navView.titleLabel.text = @"新消息设置";
    self.bgImageView.hidden = YES;
    
    //body
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, posy + 10, 320, kMainScreenHeight + self.topDistance - posy - 10) style:UITableViewStyleGrouped];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _dataTableView.scrollEnabled = NO;
    [self.view addSubview:_dataTableView];
    
    _datalist = [NSMutableArray arrayWithObjects:@"开启消息提醒", @"声音", @"震动", nil];
    
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellAccessoryDisclosureIndicator reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    //desc
    UILabel *lblDesc = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 24)];
    [lblDesc setBackgroundColor:[UIColor clearColor]];
    [lblDesc setTextAlignment:kTextAlignmentLeft];
    [lblDesc setFont:[UIFont systemFontOfSize:15]];
    [lblDesc setTextColor:[UIColor colorWithRed:61.0f/255.0f green:61.0f/255.0f blue:61.0f/255.0f alpha:1.0f]];
    [cell.contentView addSubview:lblDesc];
    
    //
    lblDesc.text = [_datalist objectAtIndex:indexPath.row];
    
    //switch
    UISwitch *dataSwitch = [[UISwitch alloc] init];
    CGRect switchframe = dataSwitch.frame;
    switchframe.origin.x = 290 - switchframe.size.width;
    switchframe.origin.y = (44 - switchframe.size.height) / 2;
    dataSwitch.frame = switchframe;
    [cell.contentView addSubview:dataSwitch];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

@end
