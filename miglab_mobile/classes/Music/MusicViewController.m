//
//  MusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicViewController.h"
#import "MusicSourceMenuCell.h"
#import "CollectNum.h"

#import "OnlineViewController.h"
#import "LikeViewController.h"
#import "NearMusicViewController.h"
#import "LocalViewController.h"

@interface MusicViewController ()

@end

@implementation MusicViewController

@synthesize sourceEditMenuView = _sourceEditMenuView;
@synthesize sourceEditData = _sourceEditData;

@synthesize bodyTableView = _bodyTableView;
@synthesize tableTitles = _tableTitles;

@synthesize locationManager = _locationManager;
@synthesize collectNum = _collectNum;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCollectAndNearNumFailed:) name:NotificationNameCollectAndNearNumFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCollectAndNearNumSuccess:) name:NotificationNameCollectAndNearNumSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectAndNearNumFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameCollectAndNearNumSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-44, ios7-64
    
    //edit menu
    NSArray *sourceEditMenuNib = [[NSBundle mainBundle] loadNibNamed:@"MusicSourceEditMenuView" owner:self options:nil];
    for (id oneObject in sourceEditMenuNib){
        if ([oneObject isKindOfClass:[MusicSourceEditMenuView class]]){
            _sourceEditMenuView = (MusicSourceEditMenuView *)oneObject;
        }//if
    }//for
    _sourceEditMenuView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    [_sourceEditMenuView.btnBack addTarget:self action:@selector(doBackFromSourceEdit:) forControlEvents:UIControlEventTouchUpInside];
    _sourceEditMenuView.btnOnline.tag = 0;
    [_sourceEditMenuView.btnOnline addTarget:self action:@selector(doEditSelected:) forControlEvents:UIControlEventTouchUpInside];
    _sourceEditMenuView.btnCollected.tag = 1;
    [_sourceEditMenuView.btnCollected addTarget:self action:@selector(doEditSelected:) forControlEvents:UIControlEventTouchUpInside];
    _sourceEditMenuView.btnNearby.tag = 2;
    [_sourceEditMenuView.btnNearby addTarget:self action:@selector(doEditSelected:) forControlEvents:UIControlEventTouchUpInside];
    _sourceEditMenuView.btnIPod.tag = 3;
    [_sourceEditMenuView.btnIPod addTarget:self action:@selector(doEditSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sourceEditMenuView];
    _sourceEditMenuView.hidden = YES;
    
    NSMutableDictionary *dicEdit0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_online", @"EditName", @"在线推荐", @"MenuText", @"1", @"IsSelected", nil];
    NSMutableDictionary *dicEdit1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_like", @"EditName", @"我喜欢的", @"MenuText", @"0", @"IsSelected", nil];
    NSMutableDictionary *dicEdit2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_nearby", @"EditName", @"附近的好音乐", @"MenuText", @"0", @"IsSelected", nil];
    NSMutableDictionary *dicEdit3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_local", @"EditName", @"本地音乐", @"MenuText", @"0", @"IsSelected", nil];
    _sourceEditData = [NSArray arrayWithObjects:dicEdit0, dicEdit1, dicEdit2, dicEdit3, nil];
    
    //body
    _bodyTableView = [[UITableView alloc] init];
    _bodyTableView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    _bodyTableView.dataSource = self;
    _bodyTableView.delegate = self;
    _bodyTableView.backgroundColor = [UIColor clearColor];
    _bodyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyTableView.scrollEnabled = NO;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = _bodyTableView.frame;
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _bodyTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_bodyTableView];
    
    NSMutableDictionary *dicMenu0 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_online", @"MenuImageName", @"在线推荐", @"MenuText", @"已经消耗0MB流量", @"MenuTip", nil];
    NSMutableDictionary *dicMenu1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_like", @"MenuImageName", @"我喜欢的", @"MenuText", @"0", @"MenuTip", nil];
    NSMutableDictionary *dicMenu2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_nearby", @"MenuImageName", @"附近的好音乐", @"MenuText", @"0", @"MenuTip", nil];
    NSMutableDictionary *dicMenu3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"music_source_menu_local", @"MenuImageName", @"本地音乐", @"MenuText", @"0", @"MenuTip", nil];
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    //gps
    _locationManager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager setDelegate:self];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//        [_locationManager startUpdatingLocation];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [_locationManager startUpdatingLocation];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [_locationManager stopUpdatingLocation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadCollectedAndNearNumFromServer:(NSString *)tLocation{
    
    PLog(@"loadCollectedAndNearNumFromServer...");
    
    if ([UserSessionManager GetInstance].isLoggedIn && tLocation) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doCollectAndNearNum:userid token:accesstoken taruid:userid radius:@"1000" pageindex:@"0" pagesize:@"10" location:tLocation];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
        
    }
    
}

#pragma notification

-(void)getCollectAndNearNumFailed:(NSNotification *)tNotification{
    
    PLog(@"getCollectAndNearNumFailed...");
    
    long long filesize = [[SongDownloadManager GetInstance] getSongCacheFileSize];
    NSString *strDownloadDataDesc = [NSString stringWithFormat:@"已消耗%lldMB流量", filesize/1000000];
    
    //download song
    NSMutableDictionary *dicMenu0 = [_tableTitles objectAtIndex:0];
    [dicMenu0 setValue:strDownloadDataDesc forKey:@"MenuTip"];
    
    [_bodyTableView reloadData];
    
}

-(void)getCollectAndNearNumSuccess:(NSNotification *)tNotification{
    
    PLog(@"getCollectAndNearNumSuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    _collectNum = [result objectForKey:@"result"];
    
    long long filesize = [[SongDownloadManager GetInstance] getSongCacheFileSize];
    NSString *strDownloadDataDesc = [NSString stringWithFormat:@"已消耗%lldMB流量", filesize/1000000];
    NSString *strCollectNum = [NSString stringWithFormat:@"%d", _collectNum.mynum];
    NSString *strNearNum = [NSString stringWithFormat:@"%d", _collectNum.nearnum];
    int ipodNum = [[PDatabaseManager GetInstance] getIPodSongCount];
    NSString *strIPodNum = [NSString stringWithFormat:@"%d", ipodNum];
    
    //download song
    NSMutableDictionary *dicMenu0 = [_tableTitles objectAtIndex:0];
    [dicMenu0 setValue:strDownloadDataDesc forKey:@"MenuTip"];
    
    //collected
    NSMutableDictionary *dicMenu1 = [_tableTitles objectAtIndex:1];
    [dicMenu1 setValue:strCollectNum forKey:@"MenuTip"];
    
    //near
    NSMutableDictionary *dicMenu2 = [_tableTitles objectAtIndex:2];
    [dicMenu2 setValue:strNearNum forKey:@"MenuTip"];
    
    //ipod
    NSMutableDictionary *dicMenu3 = [_tableTitles objectAtIndex:3];
    [dicMenu3 setValue:strIPodNum forKey:@"MenuTip"];
    
    [_bodyTableView reloadData];
    
}

-(IBAction)doShowSourceEdit:(id)sender{
    
    PLog(@"doShowSourceEdit...");
    
    _sourceEditMenuView.alpha = 0.0f;
    _sourceEditMenuView.hidden = NO;
    _bodyTableView.alpha = 1.0f;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _sourceEditMenuView.alpha = 1.0f;
        _bodyTableView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        _bodyTableView.hidden = YES;
        
    }];
    
}

-(IBAction)doBackFromSourceEdit:(id)sender{
    
    PLog(@"doBackFromSourceEdit...");
    
    _sourceEditMenuView.alpha = 1.0f;
    _bodyTableView.alpha = 0.0f;
    _bodyTableView.hidden = NO;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _sourceEditMenuView.alpha = 0.0f;
        _bodyTableView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        _sourceEditMenuView.hidden = YES;
        
    }];
    
    //todo edit data
    
    
}

-(IBAction)doEditSelected:(id)sender{
    
    UIButton *btnEdit = sender;
    
    PLog(@"doSelected: %d", btnEdit.tag);
    
    NSMutableDictionary *dicEdit = [_sourceEditData objectAtIndex:btnEdit.tag];
    NSString *strIsSelected = [dicEdit objectForKey:@"IsSelected"];
    if ([strIsSelected intValue] > 0) {
        [dicEdit setValue:@"0" forKey:@"IsSelected"];
        UIImage *iconUnSelImage = [UIImage imageWithName:@"music_song_unsel" type:@"png"];
        [btnEdit setImage:iconUnSelImage forState:UIControlStateNormal];
    } else {
        [dicEdit setValue:@"1" forKey:@"IsSelected"];
        UIImage *iconSelImage = [UIImage imageWithName:@"music_song_sel" type:@"png"];
        [btnEdit setImage:iconSelImage forState:UIControlStateNormal];
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
    
    NSString *strLocation = [NSString stringWithFormat:@"%@,%@", strLatitude, strLongitude];
    
    //
    [self loadCollectedAndNearNumFromServer:strLocation];
    
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    PLog(@"locationManager didFailWithError: %@", [error localizedDescription]);
}

#pragma mark - UITableView delegate

// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(230, 8, 58, 28);
    UIImage *editNorImage = [UIImage imageWithName:@"music_source_edit" type:@"png"];
    [btnEdit setImage:editNorImage forState:UIControlStateNormal];
    [btnEdit addTarget:self action:@selector(doShowSourceEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(4, 45, 290, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, 297, 45);
    [headerView addSubview:btnEdit];
    [headerView addSubview:separatorImageView];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    if (indexPath.row == 0) {
        
        /*
        OnlineViewController *onlineViewController = [[OnlineViewController alloc] initWithNibName:@"OnlineViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:onlineViewController animated:YES];
        */
        
    } else if (indexPath.row == 1) {
        
        LikeViewController *likeViewController = [[LikeViewController alloc] initWithNibName:@"LikeViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:likeViewController animated:YES];
        
    } else if (indexPath.row == 2) {
        
        NearMusicViewController *nearMusicViewController = [[NearMusicViewController alloc] initWithNibName:@"NearMusicViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:nearMusicViewController animated:YES];
        
    } else if (indexPath.row == 3) {
        
        LocalViewController *localViewController = [[LocalViewController alloc] initWithNibName:@"LocalViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:localViewController animated:YES];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicSourceMenuCell";
	MusicSourceMenuCell *cell = (MusicSourceMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSourceMenuCell" owner:self options:nil];
        cell = (MusicSourceMenuCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSMutableDictionary *dicMenu = [_tableTitles objectAtIndex:indexPath.row];
    cell.menuImageView.image = [UIImage imageWithName:[dicMenu objectForKey:@"MenuImageName"]];
    cell.lblMenu.font = [UIFont fontOfApp:17.0f];
    cell.lblMenu.text = [dicMenu objectForKey:@"MenuText"];
    
    if (indexPath.row == 0) {
        
        cell.lblTipNum.font = [UIFont fontOfApp:10.0f];
        cell.lblTipNum.text = [dicMenu objectForKey:@"MenuTip"];
        CGRect tipframe = cell.lblTipNum.frame;
        tipframe.origin.x += 15.0f;
        cell.lblTipNum.frame = tipframe;
        cell.arrowImageView.hidden = YES;
        
    } else {
        
        int nMenuTip = [[dicMenu objectForKey:@"MenuTip"] intValue];
        if (nMenuTip > 0) {
            cell.lblTipNum.font = [UIFont fontOfApp:10.0f];
            cell.lblTipNum.text = [NSString stringWithFormat:@"%d", nMenuTip];
            cell.lblTipNum.hidden = NO;
        } else {
            cell.lblTipNum.hidden = YES;
        }
        
    }
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
