      //
//  ListenMyMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ListenMyMusicViewController.h"
#import "FriendInfoCell.h"
#import "MyFriendPersonalPageViewController.h"

NSString* szListenMyMusicRadius = @"10000";

@interface ListenMyMusicViewController ()

@end

@implementation ListenMyMusicViewController

@synthesize locationManager = _locationManager;
@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;
@synthesize isUpdatedLocation = _isUpdatedLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadListeningMyFavorateMusicSuccess:) name:NotificationNameGetSameMusicSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadListeningMyFavorateMusicFailed:) name:NotificationNameGetSameMusicFailed object:nil];
        
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetSameMusicSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetSameMusicFailed object:nil];
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
    self.navView.titleLabel.text = @"谁在听你爱的歌";
    
    
    //附近歌友
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - BOTTOM_PLAYER_HEIGHT - 44 - 10 - 10 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_dataTableView];
    
    //
    _dataList = [[NSMutableArray alloc] init];
    
    // gps init
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

-(void)loadData{
    
    [self loadNearFriendFromDatabase];
    //    [self loadNearFriendFromServer];
    
}
-(void)loadNearFriendFromDatabase{
    
    //test data
//    MessageInfo *testfriend = [[MessageInfo alloc] init];
//    testfriend.userInfo  = [[NearbyUser alloc] init];
//    testfriend.userInfo.nickname = @"lj_archer";
//    testfriend.userInfo.userid = @"123";
//    testfriend.userInfo.songname = @"非常好听的歌";
//    testfriend.userInfo.distance = 10;
//    testfriend.userInfo.sex = @"1";
//    [_dataList addObject:testfriend];
//
//    NearbyUser *testfriend1 = [[NearbyUser alloc] init];
//    testfriend.userid = @"456";
//    //    testfriend1.nickname = @"乐瑟乐瑟";
//    [_dataList addObject:testfriend1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadListeningMyFavorateMusic:(NSString *)location {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        //junliu fixed, for debug
        [self.miglabAPI doGetSameMusic:userid token:accesstoken radius:[NSString stringWithFormat:@"%d", SEARCH_DISTANCE] location:location];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:DEFAULT_UNLOGIN_REMINDING];
    }
}

#pragma notification

-(void)LoadListeningMyFavorateMusicSuccess:(NSNotification *)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NSMutableArray* nms = [result objectForKey:@"result"];
    
    [_dataList addObjectsFromArray:nms];
    [_dataTableView reloadData];
}

-(void)LoadListeningMyFavorateMusicFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"获取听你爱的歌失败了:("];
}

#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (_isUpdatedLocation) {
        
        return;
    }
    else {
    
        CLLocationCoordinate2D coord = newLocation.coordinate;
        CLLocationDegrees gLatitude = coord.latitude;
        CLLocationDegrees gLongitude = coord.longitude;
        
        NSString*  szCurLocation = [NSString stringWithFormat:@"%@,%@", [NSString stringWithFormat:@"%g", gLatitude], [NSString stringWithFormat:@"%g", gLongitude]];
        
        [_locationManager stopUpdatingLocation];
        
        [self LoadListeningMyFavorateMusic:szCurLocation];
     
        _isUpdatedLocation = YES;
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    
}

#pragma mark - UITableView delegate

// called after the user changes the selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NearbyUser* userinfo = (NearbyUser*)((MessageInfo*)[_dataList objectAtIndex:row]).userInfo;
    
    MyFriendPersonalPageViewController* friendPersonalView = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
    
    friendPersonalView.userinfo = userinfo;
    [self.navigationController pushViewController:friendPersonalView animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dataList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"FriendInfoCell";
    FriendInfoCell* cell = (FriendInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FriendInfoCell" owner:self options:nil];
        cell = (FriendInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    MessageInfo* nms = [_dataList objectAtIndex:indexPath.row];
    NearbyUser *tempfriend = nms.userInfo;
    [cell updateFriendInfoCellData:tempfriend];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

@end
