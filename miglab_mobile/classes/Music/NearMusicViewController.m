//
//  NearMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearMusicViewController.h"
#import "NearMusicSongCell.h"
#import "Song.h"
#import "PDatabaseManager.h"
#import "MusicCommentViewController.h"
#import "MyFriendPersonalPageViewController.h"

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
@synthesize isUpdateLocation = _isUpdateLocation;

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
    
    _isUpdateLocation = NO;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"附近的好音乐";
    
    //search
    UIImage *searchImage = [UIImage imageWithName:@"music_button_search" type:@"png"];
    [self.navView.rightButton setBackgroundImage:searchImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5 + self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
    
    //body
    //body bg
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
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
    _dataTableView.frame = CGRectMake(11.5, posy + 10 + 45, 297, kMainScreenHeight + self.topDistance - posy - 10 - 45 - 10 - 73 - 10);
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
        
        [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeGradient];
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        _pageIndex = (_isLoadMore) ? _pageIndex++ : 0;
        
        [self.miglabAPI doGetNearMusic:userid token:accesstoken radius:@"1000" pageindex:[NSString stringWithFormat:@"%d", _pageIndex] pagesize:[NSString stringWithFormat:@"%d", _pageSize] location:tLocation];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
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
    
    if (_isUpdateLocation) {
        return;
    }
    
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
    _isUpdateLocation = YES;
    [self loadNearMusicFromServer:_location];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    PLog(@"locationManager didFailWithError: %@", [error localizedDescription]);
}

#pragma notification

-(void)getNearMusicFailed:(NSNotification *)tNotification{
    
    PLog(@"getNearMusicFailed...");
    
    [SVProgressHUD dismiss];
    
    [SVProgressHUD showErrorWithStatus:MIGTIP_GET_NEAR_SONG_FAILED];
}

-(void)getNearMusicSuccess:(NSNotification *)tNotification{
    
    PLog(@"getNearMusicSuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *nearbyUserInfoList = [result objectForKey:@"result"];
    int nearbyusercount = [nearbyUserInfoList count];
    
    _isLoadMore = (nearbyusercount == _pageSize);
    
    if (nearbyusercount > 0) {
        
        for (int i=0; i<nearbyusercount; i++) {
            
            MessageInfo *nms = [nearbyUserInfoList objectAtIndex:i];
            [nms log];
        }
        
        if (_pageIndex == 0) {
            [_dataList removeAllObjects];
        }
        [_dataList addObjectsFromArray:nearbyUserInfoList];
        [_dataTableView reloadData];
        
    }
    
    [SVProgressHUD dismiss];
}

-(IBAction)checkNearMusicUserInfo:(id)sender; {
    
    int row = ((UIButton*)sender).tag - 77;
    PLog(@"row %d", row);
    
    if (row < [_dataList count]) {
        
        MessageInfo* curMsgInfo = [_dataList objectAtIndex:row];
        NearbyUser* user = curMsgInfo.userInfo;
        
        if (user) {
            
            MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
            personalPageViewController.userinfo = user;
            personalPageViewController.isFriend = NO;
            
            [self.navigationController pushViewController:personalPageViewController animated:YES];
        }
    }
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    if (_dataStatus == 1) {
        
        //只有在正常模式下才能进去歌曲评论界面
        MessageInfo* curMsgInfo = [_dataList objectAtIndex:indexPath.row];
        Song *tempsong = curMsgInfo.song;
        
        MusicCommentViewController *musicCommentViewController = [[MusicCommentViewController alloc] initWithNibName:@"MusicCommentViewController" bundle:nil];
        musicCommentViewController.song = tempsong;
        [self.navigationController pushViewController:musicCommentViewController animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NearMusicSongCell";
	NearMusicSongCell *cell = (NearMusicSongCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"NearMusicSongCell" owner:self options:nil];
        cell = (NearMusicSongCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
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
    
    MessageInfo *nms = [_dataList objectAtIndex:indexPath.row];
    Song *tempsong = nms.song;
    
    cell.btnIcon.tag = tempsong.songid;
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongName.font = [UIFont fontOfApp:15.0f];
    
    long distance = nms.userInfo.distance;
    int favornum = tempsong.commentnum;
    NSString* imageurl = nms.userInfo.headurl;
    NSString* szFavor = [NSString stringWithFormat:@"%d", favornum];
    if (favornum > 999) {
        
        szFavor = @"999+";
    }
    
    if (distance < 1000) {
        
        cell.lblDistance.text = [NSString stringWithFormat:@"%@ | %ldm内", szFavor, distance];
    }
    else {
        
        cell.lblDistance.text = [NSString stringWithFormat:@"%@ | %ldkm", szFavor, distance / 1000];
    }
    cell.lblDistance.textAlignment = UITextAlignmentRight;
    
    CGSize distancesize = [cell.lblDistance.text sizeWithFont:cell.lblDistance.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGRect distanceRect = cell.lblDistance.frame;
    CGRect tipRect = cell.imgMsgTips.frame;
    tipRect.origin.x = distanceRect.origin.x + distanceRect.size.width - distancesize.width - 5 - tipRect.size.width;
    cell.imgMsgTips.frame = tipRect;
    
    if (imageurl) {
        
        cell.btnAvatar.imageURL = [NSURL URLWithString:imageurl];
    }
    else {
        
        cell.btnAvatar.imageURL = [NSURL URLWithString:URL_DEFAULT_HEADER_IMAGE];
    }
    cell.btnAvatar.layer.cornerRadius = cell.btnAvatar.frame.size.width / 2;
    cell.btnAvatar.layer.masksToBounds = YES;
    cell.btnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
    cell.btnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;
    cell.btnAvatar.tag = indexPath.row + 77;
    [cell.btnAvatar addTarget:self action:@selector(checkNearMusicUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.contentView addSubview:cell.btnAvatar];
    
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
