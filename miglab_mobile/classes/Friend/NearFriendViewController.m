//
//  NearFriendViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearFriendViewController.h"
#import "FriendInfoCell.h"
#import "NearbyUser.h"
#import "MyFriendPersonalPageViewController.h"

@interface NearFriendViewController ()

@end

@implementation NearFriendViewController

@synthesize locationManager = _locationManager;

@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;
@synthesize isUpdatedLocation = _isUpdatedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNearbyFailed:) name:NotificationNameGetNearUserFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchNearbySuccess:) name:NotificationNameGetNearUserSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameSearchNearbyFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameSearchNearbySuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isUpdatedLocation = NO;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"附近的歌友";
    
    //search
    UIImage *searchImage = [UIImage imageWithName:@"music_button_search" type:@"png"];
    [self.navView.rightButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5 + self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    //附近歌友
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - 44 - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_dataTableView];
    
    //
    _dataList = [[NSMutableArray alloc] init];
    
    //gps
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager startUpdatingLocation];
    }
    
    //
    [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    
    [self loadNearFriendFromDatabase];
    //[self loadNearFriendFromServer];
    
}
-(void)loadNearFriendFromDatabase{
    
//    //test data
//    NearbyUser *testfriend = [[NearbyUser alloc] init];
//    testfriend.userid = @"123";
//    testfriend.nickname = @"猫王爱淘汰1";
//    testfriend.distance = 20000;
//    testfriend.sex = @"0";
//    testfriend.songname = @"黑色星期一";
//    [_dataList addObject:testfriend];
//    
//    NearbyUser *testfriend1 = [[NearbyUser alloc] init];
//    testfriend1.userid = @"456";
//    testfriend1.nickname = @"乐瑟乐瑟2";
//    testfriend1.distance = 543453;
//    testfriend1.sex = @"1";
//    testfriend1.songname = @"正常的歌曲";
//    [_dataList addObject:testfriend1];
    
}

-(void)loadNearFriendFromServer:(NSString *)tLocation{
    
    if ([UserSessionManager GetInstance].isLoggedIn && tLocation) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doGetNearUser:userid token:accesstoken radius:[NSString stringWithFormat:@"%d", SEARCH_DISTANCE] location:tLocation];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
        
    }
    
}

#pragma notification

-(void)searchNearbyFailed:(NSNotification *)tNotification{
    
    PLog(@"searchNearbyFailed...");
    
    [SVProgressHUD showErrorWithStatus:@"附近的歌友获取失败:("];
    
}

-(void)searchNearbySuccess:(NSNotification *)tNotification{
    
    PLog(@"searchNearbySuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *nearbyUserInfoList = [result objectForKey:@"result"];
    
    [_dataList addObjectsFromArray:nearbyUserInfoList];
    [_dataTableView reloadData];
    
}

-(IBAction)doSearch:(id)sender{
    
    PLog(@"doSearch...");
    
}

#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    if (_isUpdatedLocation) {
        
        return;
    }
    else {
    
        PLog(@"[newLocation description]: %@", [newLocation description]);
        
        //取得经纬度
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        CLLocationDegrees gLatitude = coordinate.latitude;
        CLLocationDegrees GLongitude = coordinate.longitude;
        NSString *strLatitude = [NSString stringWithFormat:@"%g", gLatitude];
        NSString *strLongitude = [NSString stringWithFormat:@"%g", GLongitude];
        NSLog(@"strLatitude: %@, strLongitude: %@", strLatitude, strLongitude);
        
        [_locationManager stopUpdatingLocation];
        
        NSString *strLocation = [NSString stringWithFormat:@"%@,%@", strLatitude, strLongitude];
        
        //
        [self loadNearFriendFromServer:strLocation];
        
        _isUpdatedLocation = YES;
    
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    PLog(@"locationManager didFailWithError: %@", [error localizedDescription]);
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
    
    NSInteger row = indexPath.row;
    MessageInfo* msginfo = (MessageInfo*)[_dataList objectAtIndex:row];
    personalPageViewController.userinfo = msginfo.userInfo;
    personalPageViewController.isFriend = NO;
    [self.navigationController pushViewController:personalPageViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FriendInfoCell";
	FriendInfoCell *cell = (FriendInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FriendInfoCell" owner:self options:nil];
        cell = (FriendInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    MessageInfo *msginfo = [_dataList objectAtIndex:indexPath.row];
    NearbyUser* userinfo = msginfo.userInfo;
    [cell updateFriendInfoCellData:userinfo];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

@end
