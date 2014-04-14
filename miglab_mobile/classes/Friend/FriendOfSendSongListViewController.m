//
//  FriendOfSendSongListViewController.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfSendSongListViewController.h"
#import "MusicSongCell.h"
#import "ChooseSongInfoCell.h"

@interface FriendOfSendSongListViewController ()

@end

@implementation FriendOfSendSongListViewController

@synthesize songTableView = _songTableView;
@synthesize songData = _songData;
@synthesize delegate = _delegate;
@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMyMusicFromServerSuccess:) name:NotificationNameGetSongHistorySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMyMusicFromServerFailed:) name:NotificationNameGetSongHistoryFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetSongHistorySuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetSongHistoryFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
    self.navView.titleLabel.text = @"选择推荐歌曲";
    
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;
    
    posy += 10;
    
    UIImageView* bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - 85);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    /* Header view */
    UILabel* lblDesc = [[UILabel alloc] init];
    lblDesc.frame = CGRectMake(16, 12, ORIGIN_WIDTH - 80, 21);
    lblDesc.backgroundColor = [UIColor clearColor];
    lblDesc.font = [UIFont systemFontOfSize:15.0f];
    lblDesc.text = @"选择以下歌曲";
    lblDesc.textAlignment = kTextAlignmentLeft;
    lblDesc.textColor= [UIColor whiteColor];
    
    UIImageView* separatorImageView = [[UIImageView alloc] init];
    separatorImageView.frame = CGRectMake(0, 45, ORIGIN_WIDTH, 1);
    separatorImageView.image = [UIImage imageWithName:@"music_source_separator" type:@"png"];
    
    UIButton* sureButton = [[UIButton alloc] init];
    sureButton.frame = CGRectMake(ORIGIN_WIDTH - 70, 5, 60, 35);
    [sureButton setBackgroundImage:[UIImage imageWithName:@"friend_sayhi_button_ok" type:@"png"] forState:UIControlStateNormal];
    [sureButton setHidden:NO];
    [sureButton addTarget:self action:@selector(finishChooseSongs:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, 45);
    [headerView addSubview:lblDesc];
    [headerView addSubview:separatorImageView];
    [headerView addSubview:sureButton];
    [self.view addSubview:headerView];
    
    posy += 45;
    
    _songTableView = [[UITableView alloc] init];
    _songTableView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 13);
    _songTableView.dataSource = self;
    _songTableView.delegate = self;
    _songTableView.backgroundColor = [UIColor clearColor];
    _songTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_songTableView];
    
    _songData = [[NSMutableArray alloc] init];
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doBack:(id)sender{
    
    [super doBack:sender];
    [self dismissModalViewControllerAnimated:YES];
    
}

-(IBAction)finishChooseSongs:(id)sender {
    
    int songcount = [_songData count];
    NSMutableArray* chosedSongs = [[NSMutableArray alloc] init];
    
    for (int i=0; i<songcount; i++) {
        
        Song* song = [_songData objectAtIndex:i];
        
        if (song.isChosed) {
            
            [chosedSongs addObject:song];
        }
    }
    
    if([self.delegate didChooseTheSong:chosedSongs]) {
        
        [self dismissModalViewControllerAnimated:YES];
    }
}


-(void)loadData {
    
    [self LoadMyMusicFromServer];
}

-(void)LoadMyMusicFromServer {
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* token = [UserSessionManager GetInstance].accesstoken;
        
        [_miglabAPI doGetSongHistory:userid token:token fromid:@"0" count:@"10"];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}

#pragma mark - Notification
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification {
    
    //[SVProgressHUD showErrorWithStatus:@"获取歌曲列表失败:("];
}

-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NSMutableArray* songs = [result objectForKey:@"result"];
    
    [_songData addObjectsFromArray:songs];
    [_songTableView reloadData];
}

#pragma mark - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_songData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChooseSongInfoCell";
	ChooseSongInfoCell *cell = (ChooseSongInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"ChooseSongInfoCell" owner:self options:nil];
        cell = (ChooseSongInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    Song *tempsong = [_songData objectAtIndex:indexPath.row];
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongInfo.text = [NSString stringWithFormat:@"%@ | %@", tempsong.artist, @"2.5mb"];
    cell.lblListenNumber.text = [NSString stringWithFormat:@"%lld", tempsong.hot > 0 ? tempsong.hot : 0];
    cell.lblCommentNumber.text = [NSString stringWithFormat:@"%d", tempsong.commentnum > 0 ? tempsong.commentnum : 0];
    cell.isCheckButton = NO;
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Song* song = [_songData objectAtIndex:indexPath.row];
    
    if (song) {
        
        /* Check the song flag and change the display icon */
        ChooseSongInfoCell* cell = (ChooseSongInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        cell.isCheckButton = !cell.isCheckButton;
        
        if (cell.isCheckButton) {
            
            cell.lbiCheck.image = [UIImage imageNamed:@"music_song_sel"];
        }
        else {
            
            cell.lbiCheck.image = [UIImage imageNamed:@"music_song_unsel"];
        }
        
        song.isChosed = cell.isCheckButton;
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"请选择一首歌"];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
