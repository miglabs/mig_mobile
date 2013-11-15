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
@synthesize chosedSong = _chosedSong;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _miglabAPI = [[MigLabAPI alloc] init];
    
    self.navView.titleLabel.text = @"选择您要赠送的歌曲";
    
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;
    
    _songTableView = [[UITableView alloc] init];
    _songTableView.frame = CGRectMake(ORIGIN_X, posy+10, ORIGIN_WIDTH, kMainScreenHeight+self.topDistance-posy-30);
    _songTableView.dataSource = self;
    _songTableView.delegate = self;
    _songTableView.backgroundColor = [UIColor clearColor];
    _songTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView* bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy+10, ORIGIN_WIDTH, kMainScreenHeight+self.topDistance-147);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _songTableView.backgroundView = bodyBgImageView;
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

-(void)loadData {
    
    [self LoadMyMusicFromServer];
}

-(void)LoadMyMusicFromServer {
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* token = [UserSessionManager GetInstance].accesstoken;
    
    [_miglabAPI doGetSongHistory:userid token:token fromid:@"0" count:@"10"];
}

#pragma mark - Notification
-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"获取歌曲列表失败:("];
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
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Song* song = [_songData objectAtIndex:indexPath.row];
    
    if (song) {
        
        [self.delegate didChooseTheSong:song];
        [self doBack:nil];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"请选择一首歌"];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

@end
