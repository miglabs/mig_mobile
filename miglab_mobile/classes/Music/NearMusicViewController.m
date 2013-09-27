//
//  NearMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearMusicViewController.h"
#import "MusicSongCell.h"
#import "Song.h"
#import "PDatabaseManager.h"

@interface NearMusicViewController ()

@end

@implementation NearMusicViewController

@synthesize locationManager = _locationManager;

@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize isLoadMore = _isLoadMore;
@synthesize location = _location;

@synthesize dataStatus = _dataStatus;

@synthesize dicSelectedSongId = _dicSelectedSongId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearMusicFailed:) name:NotificationNameGetNearMusicFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearMusicSuccess:) name:NotificationNameGetNearMusicSuccess object:nil];
        
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetNearMusicFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetNearMusicSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"附近的好音乐";
    
    //search
    UIImage *searchImage = [UIImage imageWithName:@"music_button_search" type:@"png"];
    [self.navView.rightButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    //body
    //body bg
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight - posy - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //body head
    _bodyHeadMenuView = [[MusicBodyHeadMenuView alloc] initMusicBodyHeadMenuView];
    _bodyHeadMenuView.frame = CGRectMake(11.5, posy + 10, 297, 45);
    [self.view addSubview:_bodyHeadMenuView];
    
    _bodyHeadMenuView.btnSort.hidden = YES;
    [_bodyHeadMenuView.btnEdit addTarget:self action:@selector(doEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    //song list
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, posy + 10 + 45, 297, kMainScreenHeight - posy - 10 - 45 - 10 - 73 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_dataTableView];
    
    //data
    _dataList = [[NSMutableArray alloc] init];
    _dataStatus = 1;
    _dicSelectedSongId = [[NSMutableDictionary alloc] init];
    
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
    
//    [self loadNearMusicFromDatabase];
//    [self loadNearMusicFromServer:<#(NSString *)#>];
    
}

-(void)loadNearMusicFromDatabase{
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
    [_dataList addObjectsFromArray:tempSongInfoList];
    
    [_dataTableView reloadData];
    
}

-(void)loadNearMusicFromServer:(NSString *)tLocation{
    
    if (!tLocation) {
        return;
    }
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        _pageIndex = (_isLoadMore) ? _pageIndex++ : 0;
        
        [self.miglabAPI doGetNearMusic:userid token:accesstoken radius:@"1000" pageindex:[NSString stringWithFormat:@"%d", _pageIndex] pagesize:[NSString stringWithFormat:@"%d", _pageSize] location:tLocation];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
        
    }
    
}

#pragma notification


-(IBAction)doSearch:(id)sender{
    
    PLog(@"doSearch...");
    
}

-(IBAction)doEdit:(id)sender{
    
    PLog(@"doEdit...");
    
    //todo edit
    if (_dataStatus == 2) {
        
        //delete
        NSArray *selectedSongList = [_dicSelectedSongId allKeys];
        int selectedSongCount = [selectedSongList count];
        for (int i=0; i<selectedSongCount; i++) {
            
            NSString *tempsongid = [selectedSongList objectAtIndex:i];
            [[PDatabaseManager GetInstance] deleteSongInfo:[tempsongid longLongValue]];
            
        }
        
        _dataStatus = 1;
        [_dataTableView reloadData];
        
    } else {
        
        _dataStatus = 2;
        [_dataTableView reloadData];
        
    }
    
    [_dicSelectedSongId removeAllObjects];
    
}

//选中歌曲删除
-(IBAction)doSelectedIcon:(id)sender{
    
    UIButton *tempBtnIcon = sender;
    PLog(@"doSelectedIcon...%d", tempBtnIcon.tag);
    
    //非编辑状态
    if (_dataStatus != 2) {
        return;
    }
    
    NSString *key = [NSString stringWithFormat:@"%d", tempBtnIcon.tag];
    if ([_dicSelectedSongId objectForKey:key]) {
        
        UIImage *iconimage = [UIImage imageWithName:@"music_song_unsel" type:@"png"];
        [tempBtnIcon setImage:iconimage forState:UIControlStateNormal];
        [_dicSelectedSongId removeObjectForKey:key];
        
    } else {
        
        UIImage *iconimage = [UIImage imageWithName:@"music_song_sel" type:@"png"];
        [tempBtnIcon setImage:iconimage forState:UIControlStateNormal];
        [_dicSelectedSongId setObject:key forKey:key];
        
    }
    
}

#pragma CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    PLog(@"[newLocation description]: %@", [newLocation description]);
    
    //取得经纬度
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    CLLocationDegrees gLatitude = coordinate.latitude;
    CLLocationDegrees GLongitude = coordinate.longitude;
    NSString *strLatitude = [NSString stringWithFormat:@"%g", gLatitude];
    NSString *strLongitude = [NSString stringWithFormat:@"%g", GLongitude];
    NSLog(@"strLatitude: %@, strLongitude: %@", strLatitude, strLongitude);
    
    [_locationManager stopUpdatingLocation];
    
    //
    _location = [NSString stringWithFormat:@"%@,%@", strLatitude, strLongitude];
    [self loadNearMusicFromServer:_location];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    PLog(@"locationManager didFailWithError: %@", [error localizedDescription]);
}

#pragma notification

-(void)getNearMusicFailed:(NSNotification *)tNotification{
    
    PLog(@"getNearMusicFailed...");
    
    [SVProgressHUD showErrorWithStatus:@"附近的好音乐获取失败:("];
    
}

-(void)getNearMusicSuccess:(NSNotification *)tNotification{
    
    PLog(@"getNearMusicSuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *nearbyUserInfoList = [result objectForKey:@"result"];
    int nearbyusercount = [nearbyUserInfoList count];
    
    _isLoadMore = (nearbyusercount == _pageSize);
    
    if (nearbyusercount > 0) {
        
        for (int i=0; i<nearbyusercount; i++) {
            
            NearMusicState *nms = [nearbyUserInfoList objectAtIndex:i];
            [nms log];
            
        }
        
        if (_pageIndex == 0) {
            [_dataList removeAllObjects];
        }
        [_dataList addObjectsFromArray:nearbyUserInfoList];
        [_dataTableView reloadData];
        
    }
    
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
    
    static NSString *CellIdentifier = @"MusicSongCell";
	MusicSongCell *cell = (MusicSongCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSongCell" owner:self options:nil];
        cell = (MusicSongCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell.btnIcon addTarget:self action:@selector(doSelectedIcon:) forControlEvents:UIControlEventTouchUpInside];
	}
    
    //1-排序，2-编辑
    if (_dataStatus == 2) {
        UIImage *iconimage = [UIImage imageWithName:@"music_song_unsel" type:@"png"];
        [cell.btnIcon setImage:iconimage forState:UIControlStateNormal];
    } else {
        UIImage *iconimage = [UIImage imageWithName:@"music_song_listening" type:@"png"];
        [cell.btnIcon setImage:iconimage forState:UIControlStateNormal];
    }
    
    NearMusicState *nms = [_dataList objectAtIndex:indexPath.row];
    Song *tempsong = nms.song;
    
    cell.btnIcon.tag = tempsong.songid;
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongName.font = [UIFont fontOfApp:15.0f];
    
    NSString *tempartist = tempsong.artist ? tempsong.artist : @"未知演唱者";
    NSString *songDesc = @"未缓存";
    long long filesize = [[SongDownloadManager GetInstance] getSongLocalSize:tempsong];
    if (filesize > 0) {
        songDesc = [NSString stringWithFormat:@"%.2fMB", (float)filesize / 1000000];
    }
    cell.lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempartist, songDesc];
    cell.lblSongArtistAndDesc.font = [UIFont fontOfApp:10.0f];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
