//
//  FriendViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendViewController.h"
#import "MusicSourceMenuCell.h"

#import "MyFriendViewController.h"
#import "ListenMyMusicViewController.h"
#import "NearFriendViewController.h"
#import "MessageViewController.h"
#import "GlobalDataManager.h"
#import "PoiManager.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

@synthesize bodyTableView = _bodyTableView;
@synthesize tableTitles = _tableTitles;
@synthesize tipNumber = _tipNumber;
//@synthesize locationMng = _locationMng;
@synthesize isUpdateLocation = _isUpdateLocation;
@synthesize isFirstLoadView = _isFirstLoadView;
@synthesize totalFriendCount = _totalFriendCount;
@synthesize totalNearFriendCount = _totalNearFriendCount;
@synthesize totalNearMusicCount = _totalNearMusicCount;
@synthesize totalMsgCount = _totalMsgCount;
@synthesize btnNewMsg = _btnNewMsg;
@synthesize imgNewMsgBg = _imgNewMsgBg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNumbersSuccess:) name:NotificationNameGetMyNearMusicMsgNumSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNumbersFailed:) name:NotificationNameGetMyNearMusicMsgNumFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetMyNearMusicMsgNumSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetMyNearMusicMsgNumFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* friends = @"0";
    NSString* nearfriends = @"0";
    NSString* listen = @"0";
    NSString* messages = @"0";
    
    _tipNumber = [[NSMutableArray alloc] initWithObjects:friends, listen, nearfriends, messages, nil];
    
    _isUpdateLocation = NO;
    _isFirstLoadView = YES;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-44, ios7-64
    
    //body
    _bodyTableView = [[UITableView alloc] init];
    _bodyTableView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    _bodyTableView.dataSource = self;
    _bodyTableView.delegate = self;
    _bodyTableView.backgroundColor = [UIColor clearColor];
    _bodyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bodyTableView.scrollEnabled = NO;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _bodyTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_bodyTableView];
    
    _imgNewMsgBg = [[UIImageView alloc] init];
    _imgNewMsgBg.frame = CGRectMake(238, 200, NEW_MSG_BG_SIZE, NEW_MSG_BG_SIZE);
    _imgNewMsgBg.image = [UIImage imageWithName:@"message_tip_bg_x24" type:@"png"];
    //[self.view addSubview:_imgNewMsgBg];
    [_imgNewMsgBg setHidden:YES];
    
    NSDictionary *dicMenu0 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_myfriend_tip", @"MenuImageName", @"我的歌友", @"MenuText", nil];
    NSDictionary *dicMenu1 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_listening_tip", @"MenuImageName", @"谁在听你爱的歌", @"MenuText", nil];
    NSDictionary *dicMenu2 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_nearby_tip", @"MenuImageName", @"附近的歌友", @"MenuText", nil];
    NSDictionary *dicMenu3 = [NSDictionary dictionaryWithObjectsAndKeys:@"friend_message_tip", @"MenuImageName", @"消息", @"MenuText", nil];
    _tableTitles = [NSArray arrayWithObjects:dicMenu0, dicMenu1, dicMenu2, dicMenu3, nil];
    
    /* 载入gps */
    /*if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        
        _locationMng = [[CLLocationManager alloc] init];
        if ([CLLocationManager locationServicesEnabled]) {
            
            [_locationMng setDelegate:self];
            [_locationMng setDistanceFilter:kCLDistanceFilterNone];
            [_locationMng setDesiredAccuracy:kCLLocationAccuracyBest];
            [_locationMng startUpdatingLocation];
            //IOS8问题
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
                [_locationMng requestWhenInUseAuthorization];
        }
    }
    else {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"" message:MIGTIP_LOCATION_CLOSE delegate:nil cancelButtonTitle:MIGTIP_OK otherButtonTitles:nil, nil];
        [alert show];
    }*/
    
    // 主动更新一次底部显示
    [super updateSongInfo];
}

-(void)viewDidAppear:(BOOL)animated {
    //[[MigPoiManager GetInstance] ViewPoi:FRINED_VIEW_TYPE];
    [[MigPoiManager GetInstance] startUpdatingLocation];
    /*if (!_isFirstLoadView) {
        
        _isUpdateLocation = NO;
        [[MigPoiManager GetInstance] ViewPoi:FRINED_VIEW_TYPE];
        [[MigPoiManager GetInstance] startUpdatingLocation];
    }
    else {
        
        _isFirstLoadView = NO;
    }*/
}

/*-(void)loadNumbersFromServer:(NSString*)tlocation {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeNone];
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doGetMyNearMusicMsgNumber:userid token:accesstoken radius:[NSString stringWithFormat:@"%d", SEARCH_DISTANCE] location:tlocation];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}*/

-(void)updateDisplayNumber {
    
    [_bodyTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
-(IBAction)doPlayerAvatar:(id)sender{
    
    [super doPlayerAvatar:sender];
    PLog(@"gene doPlayerAvatar...");
    
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    if (indexPath.row == 0) {
        
        MyFriendViewController *myFriendViewController = [[MyFriendViewController alloc] initWithNibName:@"MyFriendViewController" bundle:nil];
        myFriendViewController.totalFriendCount = _totalFriendCount;
        [self.topViewcontroller.navigationController pushViewController:myFriendViewController animated:YES];
        
    } else if (indexPath.row == 1) {
        
        ListenMyMusicViewController *listenMyMusicViewController = [[ListenMyMusicViewController alloc] initWithNibName:@"ListenMyMusicViewController" bundle:nil];
        //listenMyMusicViewController
        [self.topViewcontroller.navigationController pushViewController:listenMyMusicViewController animated:YES];
        
    } else if (indexPath.row == 2) {
        
        NearFriendViewController *nearFriendViewController = [[NearFriendViewController alloc] initWithNibName:@"NearFriendViewController" bundle:nil];
        //nearFriendViewController
        [self.topViewcontroller.navigationController pushViewController:nearFriendViewController animated:YES];
        
    } else if (indexPath.row == 3) {
        
        /* 清除新消息显示 */
        [GlobalDataManager GetInstance].nNewArrivalMsg = 0;
        [_imgNewMsgBg setHidden:YES];
        
        MessageViewController *messageViewController = [[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        messageViewController.totalMsgCount = _totalMsgCount;
        [self.topViewcontroller.navigationController pushViewController:messageViewController animated:YES];
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
    
    NSDictionary *dicMenu = [_tableTitles objectAtIndex:indexPath.row];
    cell.menuImageView.image = [UIImage imageWithName:[dicMenu objectForKey:@"MenuImageName"]];
    cell.lblMenu.text = [dicMenu objectForKey:@"MenuText"];
    
    int number = [[_tipNumber objectAtIndex:indexPath.row] intValue];
    
    if (number > 99) {
        cell.lblTipNum.text = [NSString stringWithFormat:@"99+"];
    }else if (number == 0){
        cell.lblTipNum.hidden = true;
    }else {
        cell.lblTipNum.text = [NSString stringWithFormat:@"%d", number];
    }
    
    int curRow = indexPath.row;
    
    /* 第4行消息的数量显示需要特殊处理 */
    if (curRow == 3) {
        
        int newMsg = [GlobalDataManager GetInstance].nNewArrivalMsg;
        
        if (newMsg > 0) {
            
            BOOL needAddView = YES;
            for (UIView* view in cell.subviews) {
                
                if (view == _imgNewMsgBg) {
                    
                    needAddView = NO;
                }
            }
            
            if (needAddView) {
                [cell addSubview:_imgNewMsgBg];
            }
            
            [_imgNewMsgBg setHidden:NO];
            _imgNewMsgBg.frame = cell.lblTipNum.frame;
            cell.lblTipNum.backgroundColor = [UIColor clearColor];
            [cell bringSubviewToFront:cell.lblTipNum];
            
            if (newMsg > 99) {
                cell.lblTipNum.text = [NSString stringWithFormat:@"99+"];
            }
            else {
                cell.lblTipNum.text = [NSString stringWithFormat:@"%d", [GlobalDataManager GetInstance].nNewArrivalMsg];
            }
        }
        else{
        
            [_imgNewMsgBg setHidden:YES];
        }
    }
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

#pragma mark - Notification

-(void)getNumbersSuccess:(NSNotification *)tNotification {
    
    NSDictionary* dicResult = (NSDictionary*)tNotification.userInfo;
    NSMutableArray* numbers = [dicResult objectForKey:@"result"];
    int count = [numbers count];
    
    _totalFriendCount = [[numbers objectAtIndex:0] intValue];
    _totalNearMusicCount = [[numbers objectAtIndex:1] intValue];
    _totalNearFriendCount = [[numbers objectAtIndex:2] intValue];
    _totalMsgCount = [[numbers objectAtIndex:3] intValue];
    [GlobalDataManager GetInstance].nNewArrivalMsg = [[numbers objectAtIndex:4] intValue];
    
    for (int i=0; i<count - 1; i++) {
        
        [_tipNumber replaceObjectAtIndex:i withObject:[numbers objectAtIndex:i]];
    }
    
    [self updateDisplayNumber];
    
    [SVProgressHUD dismiss];
}

-(void)getNumbersFailed:(NSNotification *)tNotification {
    
    PLog(@"get numbers failed");
    [SVProgressHUD dismiss];
}

/*
#pragma mark - Location delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    if (_isUpdateLocation) {
        
        return;
    }
    else {
        
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        CLLocationDegrees gLatitude = coordinate.latitude;
        CLLocationDegrees gLongitude = coordinate.longitude;
        NSString* strlatitude = [NSString stringWithFormat:@"%g", gLatitude];
        NSString* strlongtitude = [NSString stringWithFormat:@"%g", gLongitude];
        
        [_locationMng stopUpdatingLocation];
        
        NSString* location = [NSString stringWithFormat:@"%@,%@", strlatitude, strlongtitude];
        
        [self loadNumbersFromServer:location];
        
        _isUpdateLocation = YES;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (_isUpdateLocation) {
        
        return;
    }
    else {
        
        NSString *location = @"0,0";
        [self loadNumbersFromServer:location];
        _isUpdateLocation = YES;
    }
    
    PLog(@"update location failed");
}
*/
@end
