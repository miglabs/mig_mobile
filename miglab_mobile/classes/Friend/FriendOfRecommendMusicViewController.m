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
@synthesize curEditSong = _curEditSong;

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

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNamePresentMusicSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNamePresentMusicFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navView.titleLabel.text = @"填写或选择推荐歌曲";
    self.bgImageView.hidden = YES;
    _curEditSong = -1;
    
    UIImage* sureImage = [UIImage imageWithName:@"friend_sayhi_button_ok" type:@"png"];
    [self.navView.rightButton setBackgroundImage:sureImage forState:UIControlStateNormal];
    self.navView.rightButton.frame = CGRectMake(268, 7.5+self.topDistance, 48, 29);
    [self.navView.rightButton setHidden:NO];
    [self.navView.rightButton addTarget:self action:@selector(doSendSong:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;
    
    //已选歌曲列表
    _sendsongTableView = [[UITableView alloc] init];
    _sendsongTableView.frame = CGRectMake(ORIGIN_X, posy, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy);
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
    
    if (_isSendingSong == NO) {
        
        if ([UserSessionManager GetInstance].isLoggedIn) {
            
            NSString* userid = [UserSessionManager GetInstance].userid;
            NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
            
            /* 对所有歌曲遍历检查一遍，如果赠送歌曲的推荐语为空，则发送默认的推荐语 */
            int sendcount = [_sendsongData count];
            for (int i=0; i<sendcount; i++) {
                
                Song* tempSong = (Song*)[_sendsongData objectAtIndex:i];
                
                if (!tempSong.presentMsg) {
                    
                    tempSong.presentMsg = DEFAULT_RECOMMEND_MESSAGE;
                }
            }
            
            _isSendingSong = YES;
            
            [self.miglabAPI doPresentMusic:userid token:accesstoken touid:_toUserInfo.userid sid:_sendsongData];
        }
        else {
            
            [SVProgressHUD showErrorWithStatus:DEFAULT_UNLOGIN_REMINDING];
        }
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:DEFAULT_IS_SENDING_MESSAGE];
    }
}

#pragma mark - Notification center

-(void)SendMusicToUserFailed:(NSNotification *)tNotification {
    
    _isSendingSong = NO;
    [SVProgressHUD showErrorWithStatus:@"赠送歌曲失败:("];
}

-(void)SendMusicToUserSuccess:(NSNotification *)tNotification {
    
    _isSendingSong = NO;
    
    [SVProgressHUD showErrorWithStatus:@"赠送成功啦！Ta很快就会收到了"];
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    cell.tvRecommendContent.delegate = self;
    //cell.tvRecommendContent.text = @"点击添加推荐语";
    cell.tvRecommendContent.returnKeyType = UIReturnKeyDone;
    
    Song* song = (Song*)[_sendsongData objectAtIndex:indexPath.row];
    cell.lblSongInfo.text = [NSString stringWithFormat:@"%@/%@", song.songname, song.artist];
    cell.btnAvatar.imageURL = [NSURL URLWithString:song.coverurl];
    
    if (song.presentMsg) {
        
        cell.tvRecommendContent.text = song.presentMsg;
        [cell.lblPlaceHolder setHidden:YES];
    }
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return RECOMMAND_CELL_HEIGHT;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SongOfSendInfoCell* curCell = (SongOfSendInfoCell*)[self.sendsongTableView cellForRowAtIndexPath:indexPath];
    
    _curEditSong = indexPath.row;
    [curCell.lblPlaceHolder setHidden:YES];
    [curCell.tvRecommendContent becomeFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIImage *addImage = [UIImage imageWithName:@"send_song_of_add_button" type:@"png"];
    UIButton *btnSendSongOfAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSendSongOfAdd.frame = CGRectMake(165, 10, 118, 36);
    [btnSendSongOfAdd setImage:addImage forState:UIControlStateNormal];
    [btnSendSongOfAdd addTarget:self action:@selector(doGetSongList:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView* cell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 118, 36)];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    [cell addSubview:btnSendSongOfAdd];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 36;
}

#pragma mark - FriendOfSendSongList Delegate

-(BOOL)didChooseTheSong:(NSArray*)cursongs {
    
    /* If we already have this song, skip it */
    int curCount = [cursongs count];
    int haveCount = [_sendsongData count];
    
    if ((haveCount > MAX_PRESENT_SONG_COUNT)
        || (haveCount + curCount > MAX_PRESENT_SONG_COUNT)) {
        
        NSString* strExceed = [NSString stringWithFormat:@"对不起，最多只能送%d首歌哦~~~", MAX_PRESENT_SONG_COUNT];
        
        [SVProgressHUD showErrorWithStatus:strExceed];
        
        return NO;
    }
    
    if (haveCount <= 0) {
        
        [_sendsongData addObjectsFromArray:cursongs];
    }
    else {
        
        for (int i=0; i<curCount; i++) {
            
            Song* curSong = [cursongs objectAtIndex:i];
            BOOL addSong = YES;
            
            for (int j=0; j<haveCount; j++) {
                
                Song* haveSong = [_sendsongData objectAtIndex:j];
                
                if (curSong.songid == haveSong.songid) {
                    
                    addSong = NO;
                    break;
                }
            }
            
            if (addSong) {
                
                [_sendsongData addObject:curSong];
            }
        }
    }
    
    return YES;
}

#pragma mark - UITextView Delegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString* presentmsg = textView.text;
    
    Song* curSong = [_sendsongData objectAtIndex:_curEditSong];
    curSong.presentMsg = presentmsg;
    
    if ([text isEqualToString:@"\n"]) {
        
        if (_curEditSong > -1) {
            
            /* 如果没有写任何消息，将显示Placeholder */
            int msgsize = [presentmsg length];
            if (msgsize <= 0) {
                
                SongOfSendInfoCell* cell = (SongOfSendInfoCell*)[_sendsongTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_curEditSong inSection:0]];
                
                [cell.lblPlaceHolder setHidden:NO];
            }
            
            _curEditSong = -1;
        }
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}

@end
