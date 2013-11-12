//
//  FriendOfRecommendMusicViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendOfRecommendMusicViewController.h"
#import "SongOfSendInfoCell.h"
#import "Song.h"

@interface FriendOfRecommendMusicViewController ()

@end

@implementation FriendOfRecommendMusicViewController

@synthesize toUserInfo = _toUserInfo;
@synthesize isSendingSong = _isSendingSong;
@synthesize sendsongTableView = _sendsongTableView;
@synthesize sendsongData = _sendsongData;
@synthesize emptyTipsView = _emptyTipsView;
@synthesize miglabAPI = _miglabAPI;

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
    
    self.navView.titleLabel.text = @"填写或选择推荐歌曲";
    self.bgImageView.hidden = YES;
    
    UIImage* sureImage = [UIImage imageWithName:@"friend_sayhi_button_ok" type:@"png"];
    [self.navView.rightButton setBackgroundImage:sureImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5+self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSendSong:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;
    
    //已选歌曲列表
    _sendsongTableView = [[UITableView alloc] init];
    _sendsongTableView.frame = CGRectMake(11.5, posy+10, 297, kMainScreenHeight + self.topDistance - posy - 103);
    _sendsongTableView.dataSource = self;
    _sendsongTableView.delegate = self;
    _sendsongTableView.backgroundColor = [UIColor clearColor];
    _sendsongTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_sendsongTableView];
    
    //待送歌列表
    _sendsongData = [[NSMutableArray alloc] init];
    
    _isSendingSong = NO;
    _miglabAPI = [[MigLabAPI alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self doUpdateView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doUpdateView{
    
    [_sendsongTableView reloadData];
    [self showOrHideEmptyTips];
    
}

-(void)showOrHideEmptyTips{
    
    if (_sendsongData.count == 0) {
        if (_emptyTipsView == nil) {
            
            NSArray *emptiTipsNib = [[NSBundle mainBundle] loadNibNamed:@"SongOfSendEmptyTipsView" owner:self options:nil];
            for (id oneObject in emptiTipsNib) {
                if ([oneObject isKindOfClass:[SongOfSendEmptyTipsView class]]) {
                    _emptyTipsView = (SongOfSendEmptyTipsView *)oneObject;
                }//if
            }//for
            _emptyTipsView.frame = CGRectMake(50, 200, 220, 99);
            [self.view addSubview:_emptyTipsView];
            
            //添加歌曲
            [_emptyTipsView.btnSendSongOfAdd addTarget:self action:@selector(doGetSongList:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        _emptyTipsView.hidden = NO;
        [self.view bringSubviewToFront:_emptyTipsView];
        _sendsongTableView.hidden = YES;
    } else {
        _emptyTipsView.hidden = YES;
        [self.view sendSubviewToBack:_emptyTipsView];
        _sendsongTableView.hidden = NO;
    }
    
}

-(void)doGetSongList:(id)sender {
    
    FriendOfSendSongListViewController* sendsongView = [[FriendOfSendSongListViewController alloc] initWithNibName:@"FriendOfSendSongListViewController" bundle:nil];
    sendsongView.delegate = self;
    [self presentModalViewController:sendsongView animated:YES];
    
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
    
    static NSString* CellIdentifier = @"SongOfSendInfoCell";
    SongOfSendInfoCell* cell = (SongOfSendInfoCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        NSArray* nibContents = [[NSBundle mainBundle] loadNibNamed:@"SongOfSendInfoCell" owner:self options:nil];
        cell = (SongOfSendInfoCell*)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Song* song = (Song*)[_sendsongData objectAtIndex:indexPath.row];
    cell.lblSongInfo.text = [NSString stringWithFormat:@"%@/%@", song.songname, song.artist];
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 125;
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImage *addImage = [UIImage imageWithName:@"send_song_of_add_button" type:@"png"];
    UIButton *btnSendSongOfAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSendSongOfAdd.frame = CGRectMake(200, 10, 118, 36);
    [btnSendSongOfAdd setImage:addImage forState:UIControlStateNormal];
    [btnSendSongOfAdd addTarget:self action:@selector(doGetSongList:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnSendSongOfAdd;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 57;
}

#pragma mark - FriendOfSendSongList Delegate

-(void)didChooseTheSong:(Song *)cursong {
    
    Song* getsong = cursong;
    getsong.presentMsg = @"董翔是鸭子";
    [_sendsongData addObject:getsong];
    
}

@end
