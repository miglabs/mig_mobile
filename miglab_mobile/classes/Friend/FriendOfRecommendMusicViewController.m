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
@synthesize emptyTipsView = _emptyTipsView;

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
    self.bgImageView.hidden = YES;
    
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;
    
    _sendsongTableView = [[UITableView alloc] init];
    _sendsongTableView.frame = CGRectMake(11.5, posy+10, 297, kMainScreenHeight + self.topDistance - posy - 103);
    _sendsongTableView.dataSource = self;
    _sendsongTableView.delegate = self;
    _sendsongTableView.backgroundColor = [UIColor clearColor];
    _sendsongTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _sendsongData = [[NSMutableArray alloc] init];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self showOrHideEmptyTips];
    
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
    
//    [_sendsongData addObject:song1];
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
        }
        _emptyTipsView.hidden = NO;
        [self.view bringSubviewToFront:_emptyTipsView];
    } else {
        _emptyTipsView.hidden = YES;
        [self.view sendSubviewToBack:_emptyTipsView];
    }
    
}

-(void)SendMusicToUser:(NSString *)songid {
    
//    NSString* userid = [UserSessionManager GetInstance].userid;
//    NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
//    
//    _isSendingSong = YES;
//    [self.miglabAPI doPresentMusic:userid token:accesstoken touid:_toUserInfo.userid sid:songid];
}

#pragma mark - Notification center

-(void)SendMusicToUserFailed:(NSNotification *)tNotification {
    
    _isSendingSong = NO;
//    [SVProgressHUD showErrorWithStatus:@"赠送歌曲失败:("];
}

-(void)SendMusicToUserSuccess:(NSNotification *)tNotification {
    
    _isSendingSong = NO;
    
//    [SVProgressHUD showErrorWithStatus:@"赠送成功啦！Ta很快就会收到了"];
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
    
    if (_isSendingSong) {
        
        [SVProgressHUD showErrorWithStatus:@"正在赠送歌曲，清稍后"];
        return;
    }
    
    Song* song = (Song*)[_sendsongData objectAtIndex:indexPath.row];
    [self SendMusicToUser:[NSString stringWithFormat:@"%lld", song.songid]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
