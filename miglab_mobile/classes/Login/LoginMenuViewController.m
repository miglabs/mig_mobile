//
//  LoginMenuViewController.m
//  miglab_mobile
//
//  Created by apple on 13-10-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LoginMenuViewController.h"
#import "LoginMenuCell.h"

@interface LoginMenuViewController ()

@end

@implementation LoginMenuViewController

@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;

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
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"请登录";
    
    //search
    UIImage *searchImage = [UIImage imageWithName:@"music_button_search" type:@"png"];
    [self.navView.rightButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5 + self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    //附近歌友
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - 44 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_dataTableView];
    
    //
    NSMutableDictionary *dicEdit0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_online", @"EditName", @"在线推荐", @"MenuText", @"1", @"IsSelected", nil];
    NSMutableDictionary *dicEdit1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_like", @"EditName", @"我喜欢的", @"MenuText", @"0", @"IsSelected", nil];
    NSMutableDictionary *dicEdit2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_nearby", @"EditName", @"附近的好音乐", @"MenuText", @"1", @"IsSelected", nil];
    NSMutableDictionary *dicEdit3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_local", @"EditName", @"本地音乐", @"MenuText", @"1", @"IsSelected", nil];
    _dataList = [NSMutableArray arrayWithObjects:dicEdit0, dicEdit1, dicEdit2, dicEdit3, nil];
    
    
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LoginMenuCell";
	LoginMenuCell *cell = (LoginMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"LoginMenuCell" owner:self options:nil];
        cell = (LoginMenuCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSMutableDictionary *dicMenu = [_dataList objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageWithName:[dicMenu objectForKey:@"MenuImageName"]];
    cell.lblDesc.font = [UIFont fontOfApp:17.0f];
    cell.lblDesc.text = [dicMenu objectForKey:@"MenuText"];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

@end
