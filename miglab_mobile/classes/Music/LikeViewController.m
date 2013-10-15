//
//  LikeViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LikeViewController.h"
#import "MusicSongCell.h"
#import "Song.h"
#import "PDatabaseManager.h"
#import "MusicCommentViewController.h"

@interface LikeViewController ()

@end

@implementation LikeViewController

@synthesize bodyHeadMenuView = _bodyHeadMenuView;
@synthesize sortMenuView = _sortMenuView;

@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;

@synthesize dataStatus = _dataStatus;

@synthesize dicSelectedSongId = _dicSelectedSongId;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //doGetCollectedSongs
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCollectedSongsFailed:) name:NotificationNameGetCollectedSongsFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCollectedSongsSuccess:) name:NotificationNameGetCollectedSongsSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetCollectedSongsFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetCollectedSongsSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav title
    self.navView.titleLabel.text = @"我喜欢的歌曲";
    
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
    
    [_bodyHeadMenuView.btnSort addTarget:self action:@selector(doSort:) forControlEvents:UIControlEventTouchUpInside];
    [_bodyHeadMenuView.btnEdit addTarget:self action:@selector(doEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    //sort menu
    _sortMenuView = [[MusicSortMenuView alloc] initMusicSortMenuView];
//    _sortMenuView.frame = CGRectMake(11.5, 44 + 10 + 45, 297, 45);
    _sortMenuView.frame = CGRectMake(11.5, posy + 10 + 45, 297, 0);
    [self.view addSubview:_sortMenuView];
    
    [_sortMenuView.btnSortFirst addTarget:self action:@selector(doSortMenu1:) forControlEvents:UIControlEventTouchUpInside];
    [_sortMenuView.btnSortSecond addTarget:self action:@selector(doSortMenu2:) forControlEvents:UIControlEventTouchUpInside];
    [_sortMenuView.btnSortThird addTarget:self action:@selector(doSortMenu3:) forControlEvents:UIControlEventTouchUpInside];
    _sortMenuView.alpha = 0.0f;
    _sortMenuView.hidden = YES;
    
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
    
    //
    [self loadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    
    [self loadMusicFromDatabase];
    [self loadMusicFromServer];
    
}

-(void)loadMusicFromDatabase{
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    NSMutableArray *tempSongInfoList = [databaseManager getLikeSongInfoList:200];
    
    [_dataList removeAllObjects];
    [_dataList addObjectsFromArray:tempSongInfoList];
    [_dataTableView reloadData];
    
}

-(void)loadMusicFromServer{
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doGetCollectedSongs:userid token:accesstoken taruid:userid];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
        
    }
    
}

#pragma notification

-(void)getCollectedSongsFailed:(NSNotification *)tNotification{
    
    PLog(@"getCollectedSongsFailed...");
    
    [SVProgressHUD showErrorWithStatus:@"收藏歌曲获取失败:("];
    
}

-(void)getCollectedSongsSuccess:(NSNotification *)tNotification{
    
    PLog(@"getCollectedSongsSuccess...");
    
    [SVProgressHUD showErrorWithStatus:@"收藏歌曲获取成功:)"];
    
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *songInfoList = [result objectForKey:@"result"];
    int songInfoCount = [songInfoList count];
    
    for (int i=0; i<songInfoCount; i++) {
        Song *collectedSong = [songInfoList objectAtIndex:i];
        collectedSong.like = @"1";
    }
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    [databaseManager insertSongInfoList:songInfoList];
    NSMutableArray *tempSongInfoList = [databaseManager getLikeSongInfoList:200];
    
    [_dataList removeAllObjects];
    [_dataList addObjectsFromArray:tempSongInfoList];
    [_dataTableView reloadData];
    
}

-(IBAction)doSort:(id)sender{
    
    PLog(@"doSort...");
    
    _sortMenuView.hidden = NO;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _sortMenuView.alpha = 1.0f;
        _sortMenuView.frame = CGRectMake(11.5, 44 + 10 + 45, 297, 45);
        _dataTableView.frame = CGRectMake(11.5, 44 + 10 + 45 + 45, 297, kMainScreenHeight - 44 - 10 - 45 - 45 - 10 - 73 - 10);
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(IBAction)doEdit:(id)sender{
    
    PLog(@"doEdit...");
    
    [self doSortCollectedData:0];
    
    //todo edit
    if (_dataStatus == 2) {
        
        //delete
        NSMutableString *selectedSongId = [[NSMutableString alloc] init];
        NSArray *selectedSongList = [_dicSelectedSongId allKeys];
        int selectedSongCount = [selectedSongList count];
        for (int i=0; i<selectedSongCount; i++) {
            
            NSString *tempsongid = [selectedSongList objectAtIndex:i];
            [[PDatabaseManager GetInstance] deleteSongInfo:[tempsongid longLongValue]];
            
            [selectedSongId appendFormat:@"%@,", tempsongid];
        }
        
        //do delete
        if (selectedSongId.length > 0) {
            NSString *tempSongId = [selectedSongId substringToIndex:selectedSongId.length - 1];
            [self deleteSelectedLikeSongs:tempSongId];
        }
        
        _dataStatus = 1;
        [self loadMusicFromDatabase];
        
    } else {
        
        _dataStatus = 2;
        [_dataTableView reloadData];
        
    }
    
    [_dicSelectedSongId removeAllObjects];
    
}

//批量删除收藏歌曲
-(void)deleteSelectedLikeSongs:(NSString *)tSelectedSongs{
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doDeleteCollectedSong:userid token:accesstoken songid:tSelectedSongs];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    
}

-(IBAction)doSortMenu1:(id)sender{
    
    NSArray *sortByCollectedNum = [_dataList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        Song *tsong1 = obj1;
        Song *tsong2 = obj2;
        if (tsong1.collectnum > tsong2.collectnum) {
            return NSOrderedAscending;
        } else if (tsong1.collectnum < tsong2.collectnum) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    }];
    
    @synchronized(_dataList){
        [_dataList removeAllObjects];
        [_dataList addObjectsFromArray:sortByCollectedNum];
        [_dataTableView reloadData];
    }
    
    [self doSortCollectedData:1];
    
}

-(IBAction)doSortMenu2:(id)sender{
    
    NSArray *sortByHotNum = [_dataList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        Song *tsong1 = obj1;
        Song *tsong2 = obj2;
        if (tsong1.hot > tsong2.hot) {
            return NSOrderedAscending;
        } else if (tsong1.hot < tsong2.hot) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
        
    }];
    
    @synchronized(_dataList){
        [_dataList removeAllObjects];
        [_dataList addObjectsFromArray:sortByHotNum];
        [_dataTableView reloadData];
    }
    
    [self doSortCollectedData:2];
    
}

-(IBAction)doSortMenu3:(id)sender{
    
    NSArray *sortByPinYin = [_dataList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        Song *tsong1 = obj1;
        Song *tsong2 = obj2;
        
        return [tsong1.pinyin compare:tsong2.pinyin];
        
    }];
    
    @synchronized(_dataList){
        
        [_dataList removeAllObjects];
        [_dataList addObjectsFromArray:sortByPinYin];
        [_dataTableView reloadData];
    }
    
    [self doSortCollectedData:3];
    
}

-(void)doSortCollectedData:(int)tSortType{
    
    PLog(@"doSortCollectedData: %d", tSortType);
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _sortMenuView.alpha = 0.0f;
        _sortMenuView.frame = CGRectMake(11.5, 44 + 10 + 45, 297, 0);
        _dataTableView.frame = CGRectMake(11.5, 44 + 10 + 45, 297, kMainScreenHeight - 44 - 10 - 45 - 10 - 73 - 10);
        
    } completion:^(BOOL finished) {
        _sortMenuView.hidden = YES;
    }];
    
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

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    Song *tempsong = [_dataList objectAtIndex:indexPath.row];
    
    MusicCommentViewController *musicCommentViewController = [[MusicCommentViewController alloc] initWithNibName:@"MusicCommentViewController" bundle:nil];
    musicCommentViewController.song = tempsong;
    [self.navigationController pushViewController:musicCommentViewController animated:YES];
    
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
    
    Song *tempsong = [_dataList objectAtIndex:indexPath.row];
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
