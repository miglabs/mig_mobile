//
//  FriendOfMusicListViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfMusicListViewController.h"
#import "MusicSongCell.h"
#import "Song.h"
#import "PDatabaseManager.h"
#import "MusicCommentViewController.h"

@interface FriendOfMusicListViewController ()

@end

@implementation FriendOfMusicListViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;
@synthesize userinfo = _userinfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMusicListFromServerSuccess:) name:NotificationNameGetCollectedSongsSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMusicListFromServerFailed:) name:NotificationNameGetCollectedSongsFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetCollectedSongsSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetCollectedSongsFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    NSString* thetitle = [NSString stringWithFormat:@"%@的歌单", _userinfo.nickname];
    
    //nav bar
    self.navView.titleLabel.text = thetitle;
    
    //body
    //body bg
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - BOTTOM_PLAYER_HEIGHT - 10 - 10 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //body head
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.frame = CGRectMake(16, 12, ORIGIN_WIDTH, 21);
    lblDesc.backgroundColor = [UIColor clearColor];
    lblDesc.font = [UIFont systemFontOfSize:15.0f];
    lblDesc.text = thetitle;
    lblDesc.textAlignment = kTextAlignmentLeft;
    lblDesc.textColor = [UIColor whiteColor];
    
    UIImageView *separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(4, 45, 290, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, 45);
    [headerView addSubview:lblDesc];
    [headerView addSubview:separatorImageView];
    [self.view addSubview:headerView];
    
    //photo table view
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(ORIGIN_X, posy + 10 + 45, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - BOTTOM_PLAYER_HEIGHT - 10 - 45 - 10 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_dataTableView];
    
    //
    _datalist = [[NSMutableArray alloc] init];
    
//    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
//    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
//    [_datalist addObjectsFromArray:tempSongInfoList];
    
    [self loaddata];
}

-(void)loaddata {
    
    [self LoadMusicListFromServer];
}

-(void)LoadMusicListFromServer {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString* touserid = _userinfo.userid;
        
        [self.miglabAPI doGetCollectedSongs:userid token:accesstoken taruid:touserid];

    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Notification
-(void)LoadMusicListFromServerFailed:(NSNotification *)tNotification {
    
    //[SVProgressHUD showErrorWithStatus:@"获取歌曲失败了"];
}

-(void)LoadMusicListFromServerSuccess:(NSNotification *)tNotification {
    
    NSDictionary* dicresult = (NSDictionary*)tNotification.userInfo;
    NSArray* songlist = [dicresult objectForKey:@"result"];
    //int songcount = [songlist count];
    
    [_datalist addObjectsFromArray:songlist];
    [_dataTableView reloadData];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 进入歌曲评论界面
    Song* tempsong = [_datalist objectAtIndex:indexPath.row];
    
    MusicCommentViewController *musicCommentViewController = [[MusicCommentViewController alloc] initWithNibName:@"MusicCommentViewController" bundle:nil];
    musicCommentViewController.song = tempsong;
    [self.navigationController pushViewController:musicCommentViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_datalist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicSongCell";
	MusicSongCell *cell = (MusicSongCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSongCell" owner:self options:nil];
        cell = (MusicSongCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    Song *tempsong = [_datalist objectAtIndex:indexPath.row];
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempsong.artist, tempsong.songtype==1?@"已缓存":@"未缓存"];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

@end
