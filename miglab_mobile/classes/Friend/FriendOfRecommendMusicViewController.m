//
//  FriendOfRecommendMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfRecommendMusicViewController.h"
#import "MusicSongCell.h"
#import "Song.h"

@interface FriendOfRecommendMusicViewController ()

@end

@implementation FriendOfRecommendMusicViewController

@synthesize songTableView = _songTableView;
@synthesize songData = _songData;
@synthesize toUserInfo = _toUserInfo;
@synthesize isSendingSong = _isSendingSong;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMyMusicFromServerSuccess:) name:NotificationNameGetSongHistorySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoadMyMusicFromServerFailed:) name:NotificationNameGetSongHistoryFailed object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendMusicToUserSuccess:) name:NotificationNamePresentMusicSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SendMusicToUserFailed:) name:NotificationNamePresentMusicFailed object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isSendingSong = NO;
    
    CGRect navframe = self.navView.frame;
    float posy = navframe.origin.y + navframe.size.height;
    self.navView.titleLabel.text = @"想赠送哪首歌呢?";
    
    _songTableView = [[UITableView alloc] init];
    _songTableView.frame = CGRectMake(11.5, posy+10, 297, kMainScreenHeight + self.topDistance - posy - 103);
    _songTableView.dataSource = self;
    _songTableView.delegate = self;
    _songTableView.backgroundColor = [UIColor clearColor];
    _songTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView* bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy+10, 297, kMainScreenHeight + self.topDistance - 147);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _songTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_songTableView];
    
    _songData = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    
    [self LoadMyMusicFromDatabase];
    [self LoadMyMusicFromServer];
}

-(void)LoadMyMusicFromDatabase {
    
//    //test
//    Song* song = [[Song alloc] init];
//    song.artist = @"liujun";
//    song.songname = @"hehe";
//    [_songData addObject:song];
}

-(void)LoadMyMusicFromServer {
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* token = [UserSessionManager GetInstance].accesstoken;
    
    [self.miglabAPI doGetSongHistory:userid token:token fromid:@"0" count:@"10"];
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)SendMusicToUser:(NSString *)songid {
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    
    _isSendingSong = YES;
    [self.miglabAPI doPresentMusic:userid token:accesstoken touid:_toUserInfo.userid sid:songid];
}

#pragma mark - Notification center

-(void)LoadMyMusicFromServerFailed:(NSNotification*)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"获取歌曲列表失败:("];
}

-(void)LoadMyMusicFromServerSuccess:(NSNotification*)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NSMutableArray* songs = [result objectForKey:@"result"];
    
    [_songData addObjectsFromArray:songs];
    [_songTableView reloadData];
}

-(void)SendMusicToUserFailed:(NSNotification *)tNotification {
    
    _isSendingSong = NO;
    [SVProgressHUD showErrorWithStatus:@"赠送歌曲失败:("];
}

-(void)SendMusicToUserSuccess:(NSNotification *)tNotification {
    
    _isSendingSong = NO;
    
    [SVProgressHUD showErrorWithStatus:@"赠送成功啦！Ta很快就会收到了"];
}

#pragma mark - table view delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_songData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicSongCell";
	MusicSongCell *cell = (MusicSongCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicSongCell" owner:self options:nil];
        cell = (MusicSongCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    Song *tempsong = [_songData objectAtIndex:indexPath.row];
    cell.lblSongName.text = tempsong.songname;
    cell.lblSongArtistAndDesc.text = [NSString stringWithFormat:@"%@ | %@", tempsong.artist, tempsong.songtype==1?@"已缓存":@"未缓存"];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isSendingSong) {
        
        [SVProgressHUD showErrorWithStatus:@"正在赠送歌曲，清稍后"];
        return;
    }
    
    Song* song = (Song*)[_songData objectAtIndex:indexPath.row];
    [self SendMusicToUser:[NSString stringWithFormat:@"%lld", song.songid]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
