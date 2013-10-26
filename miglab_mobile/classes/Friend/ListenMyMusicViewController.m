//
//  ListenMyMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ListenMyMusicViewController.h"
#import "FriendInfoCell.h"
#include "NearMusicState.h"

NSString* szListenMyMusicRadius = @"500";

@interface ListenMyMusicViewController ()

@end

@implementation ListenMyMusicViewController

@synthesize locationManager = _locationManager;
@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"谁在听你爱的歌";
    
    
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
    NearbyUser *testfriend = [[NearbyUser alloc] init];
    testfriend.userid = @"123";
    //    testfriend.nickname = @"猫王爱淘汰";
    [_dataList addObject:testfriend];
    
    NearbyUser *testfriend1 = [[NearbyUser alloc] init];
    testfriend.userid = @"456";
    //    testfriend1.nickname = @"乐瑟乐瑟";
    [_dataList addObject:testfriend1];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoadListeningMyFavorateMusic:(NSString *)location {
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    
    [self.miglabAPI doGetSameMusic:userid token:accesstoken radius:szListenMyMusicRadius location:location];
}

#pragma notification

-(void)LoadListeningMyFavorateMusicSuccess:(NSNotification *)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NearMusicState* nms = [result objectForKey:@"result"];
    
    [_dataList addObjectsFromArray:nms.nearuser];
    [_dataTableView reloadData];
}

-(void)LoadListeningMyFavorateMusicFailed:(NSNotification *)tNotification {
    
    
}

#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocationCoordinate2D coord = newLocation.coordinate;
    CLLocationDegrees gLatitude = coord.latitude;
    CLLocationDegrees gLongitude = coord.longitude;
    
    NSString*  szCurLocation = [NSString stringWithFormat:@"%@,%@", [NSString stringWithFormat:@"%g", gLatitude], [NSString stringWithFormat:@"%g", gLongitude]];
    
    [_locationManager stopUpdatingLocation];
    
    [self LoadListeningMyFavorateMusic:szCurLocation];
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    
}

#pragma mark - UITableView delegate

// called after the user changes the selection
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
    
    NearbyUser *tempfriend = [_dataList objectAtIndex:indexPath.row];
    float tdistance = (float)tempfriend.distance / 1000;
    cell.lblNickName.text = tempfriend.userid;
    cell.lblUserInfo.text = [NSString stringWithFormat:@"%.2f km | 正在听 - %d", tdistance, tempfriend.cur_music];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57;
}

@end
