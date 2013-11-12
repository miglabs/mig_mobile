//
//  FriendOfRecommendMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfRecommendMusicViewController.h"
#import "SendSongInfoCell.h"
#import "Song.h"

@interface FriendOfRecommendMusicViewController ()

@end

@implementation FriendOfRecommendMusicViewController

@synthesize toUserInfo = _toUserInfo;
@synthesize isSendingSong = _isSendingSong;
@synthesize sendsongTableView = _sendsongTableView;
@synthesize sendsongData = _sendsongData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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
    
    self.navView.titleLabel.text = @"填写或选择推荐歌曲";
    
    UIImage* sureImage = [UIImage imageWithName:@"friend_sayhi_button_ok" type:@"png"];
    [self.navView.rightButton setBackgroundImage:sureImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5+self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSendSong:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;
    
    _sendsongTableView = [[UITableView alloc] init];
    _sendsongTableView.frame = CGRectMake(11.5, posy+10, 297, kMainScreenHeight + self.topDistance - posy - 103);
    _sendsongTableView.dataSource = self;
    _sendsongTableView.delegate = self;
    _sendsongTableView.backgroundColor = [UIColor clearColor];
    _sendsongTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView* bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - 147);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _sendsongTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_sendsongTableView];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(11.5, 200, 100, 100);
    [btn setTitle:@"添加歌曲" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doGetSongList:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
    
    _sendsongData = [[NSMutableArray alloc] init];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    
    Song* song1 = [[Song alloc] init];
    song1.songname = @"liujun";
    song1.artist = @"archer";
    
    [_sendsongData addObject:song1];
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doGetSongList:(id)sender {
    
    FriendOfSendSongListViewController* sendsongView = [[FriendOfSendSongListViewController alloc] initWithNibName:@"FriendOfSendSongListViewController" bundle:nil];
    sendsongView.delegate = self;
    [self.navigationController pushViewController:sendsongView animated:YES];
}

-(void)doSendSong:(id)sender {
    
    [self SendMusicToUser];
}

-(void)SendMusicToUser {
    
    NSString* userid = [UserSessionManager GetInstance].userid;
    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
    
    _isSendingSong = YES;
    [self.miglabAPI doPresentMusic:userid token:accesstoken touid:_toUserInfo.userid sid:_sendsongData];
}

#pragma mark - Notification center

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
    
    return [_sendsongData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* CellIdentifier = @"SendSongInfoCell";
    SendSongInfoCell* cell = (SendSongInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"SendSongInfoCell" owner:self options:nil];
        cell = (SendSongInfoCell*)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 57;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (_isSendingSong) {
//        
//        [SVProgressHUD showErrorWithStatus:@"正在赠送歌曲，清稍后"];
//        return;
//    }
//    
//    Song* song = (Song*)[_sendsongData objectAtIndex:indexPath.row];
//    [self SendMusicToUser];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - FriendOfSendSongList Delegate

-(void)didChooseTheSong:(Song *)cursong {
    
    Song* getsong = cursong;
    getsong.presentMsg = @"董翔是鸭子";
    [_sendsongData addObject:getsong];
    
    [_sendsongTableView reloadData];
}

@end
