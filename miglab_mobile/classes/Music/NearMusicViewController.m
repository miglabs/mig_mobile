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
    bodyBgImageView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //body head
    /*
    UILabel *lblDesc = [[UILabel alloc] init];
    lblDesc.frame = CGRectMake(16, 10, 140, 21);
    lblDesc.backgroundColor = [UIColor clearColor];
    lblDesc.font = [UIFont systemFontOfSize:15.0f];
    lblDesc.text = @"优先推荐以下歌曲";
    lblDesc.textAlignment = kTextAlignmentLeft;
    lblDesc.textColor = [UIColor whiteColor];
    
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    btnEdit.frame = CGRectMake(230, 8, 58, 28);
    UIImage *editNorImage = [UIImage imageWithName:@"music_source_edit" type:@"png"];
    [btnEdit setImage:editNorImage forState:UIControlStateNormal];
    
    UIImageView *separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(4, 45, 290, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(11.5, 45 + 10, 297, 45);
    [headerView addSubview:lblDesc];
    [headerView addSubview:btnEdit];
    [headerView addSubview:separatorImageView];
    [self.view addSubview:headerView];
    */
    
    //body head
    _bodyHeadMenuView = [[MusicBodyHeadMenuView alloc] initMusicBodyHeadMenuView];
    _bodyHeadMenuView.frame = CGRectMake(11.5, 44 + 10, 297, 45);
    [self.view addSubview:_bodyHeadMenuView];
    
    _bodyHeadMenuView.btnSort.hidden = YES;
    [_bodyHeadMenuView.btnEdit addTarget:self action:@selector(doEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    //song list
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, 45 + 10 + 45, 297, kMainScreenHeight - 45 - 10 - 45 - 10 - 73 - 10);
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
    
//    [self loadNearMusicFromDatabase];
    [self loadNearMusicFromServer];
    
}

-(void)loadNearMusicFromDatabase{
    
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
    [_dataList addObjectsFromArray:tempSongInfoList];
    
    [_dataTableView reloadData];
    
}

-(void)loadNearMusicFromServer{
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
//        [self.miglabAPI doGetNearbyUser:<#(NSString *)#> token:<#(NSString *)#> page:<#(int)#>];
        
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
    
    Song *tempsong = [_dataList objectAtIndex:indexPath.row];
    cell.btnIcon.tag = tempsong.songid;
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempsong.artist, @"未缓存"];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
