//
//  MusicCommentViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-21.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicCommentViewController.h"
#import "MusicCommentCell.h"
#import "SongComment.h"

@interface MusicCommentViewController ()

@end

@implementation MusicCommentViewController

@synthesize bodyView = _bodyView;

@synthesize commentPlayerView = _commentPlayerView;

@synthesize dataTableView = _dataTableView;
@synthesize dataList = _dataList;

@synthesize commentInputView = _commentInputView;

@synthesize song = _song;

@synthesize miglabAPI = _miglabAPI;

@synthesize pageIndex = _pageIndex;
@synthesize pageSize = _pageSize;
@synthesize isLoadMore = _isLoadMore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //getCommentList
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentListFailed:) name:NotificationNameGetCommentFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCommentListSuccess:) name:NotificationNameGetCommentSuccess object:nil];
        
        //监听键盘高度的变换
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif
        
    }
    return self;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetCommentFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetCommentSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav title
    self.navView.titleLabel.text = @"评论当前歌曲";
    
    posy += 10;
    
    //body
    _bodyView = [[UIView alloc] init];
    _bodyView.frame = CGRectMake(0, posy, kMainScreenWidth, kMainScreenHeight - posy - 10 - 49);
    _bodyView.backgroundColor = [UIColor clearColor];
    
    //player
    NSArray *commentPlayerNib = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentPlayerView" owner:self options:nil];
    for (id oneObject in commentPlayerNib){
        if ([oneObject isKindOfClass:[MusicCommentPlayerView class]]){
            _commentPlayerView = (MusicCommentPlayerView *)oneObject;
        }//if
    }//for
    _commentPlayerView.frame = CGRectMake(11.5, 0, ORIGIN_WIDTH, 110);
    [_bodyView addSubview:_commentPlayerView];
    
    _commentPlayerView.btnAvatar.layer.cornerRadius = 38;
    _commentPlayerView.btnAvatar.layer.masksToBounds = YES;
    _commentPlayerView.btnAvatar.layer.borderWidth = 2;
    _commentPlayerView.btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    _commentPlayerView.btnAvatar.imageURL = [NSURL URLWithString:_song.coverurl];
    _commentPlayerView.lblSongName.text = _song.songname;
    _commentPlayerView.lblSongName.font = [UIFont fontOfApp:17.0f];
    _commentPlayerView.lblSongArtist.text = _song.artist;
    _commentPlayerView.lblSongArtist.font = [UIFont fontOfApp:17.0f];
    [_commentPlayerView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_commentPlayerView.btnCollect addTarget:self action:@selector(doCollectedOrCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_commentPlayerView.btnDelete addTarget:self action:@selector(doHate:) forControlEvents:UIControlEventTouchUpInside];
    [_commentPlayerView.btnShare addTarget:self action:@selector(doShare:) forControlEvents:UIControlEventTouchUpInside];
    
    posy += 50;
    
    //song list
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, posy, ORIGIN_WIDTH, kMainScreenHeight - posy - 10 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = _dataTableView.frame;
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    
    [_bodyView addSubview:_dataTableView];
    
    [self.view insertSubview:_bodyView belowSubview:self.navView];
    
    //comment input view
    NSArray *commentinputNib = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentInputView" owner:self options:nil];
    for (id oneObject in commentinputNib){
        if ([oneObject isKindOfClass:[MusicCommentInputView class]]){
            _commentInputView = (MusicCommentInputView *)oneObject;
        }//if
    }//for
    _commentInputView.frame = CGRectMake(0, kMainScreenHeight - 29, kMainScreenWidth, 49);
    _commentInputView.commentTextField.delegate = self;
    [_commentInputView.btnSendComent addTarget:self action:@selector(doCommentSong:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentInputView];
    
    //data
    _dataList = [[NSMutableArray alloc] init];
    
    //
    _miglabAPI = [[MigLabAPI alloc] init];
    _pageIndex = 0;
    _pageSize = PAGE_SIZE;
    
    //data
    [self loadData];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    
    [self loadCommentListFromServer];
    
}

-(void)loadCommentListFromServer{
    
    NSString *userid = [UserSessionManager GetInstance].userid;
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    NSString *songid = [NSString stringWithFormat:@"%lld", _song.songid];
    NSString *strPageSize = [NSString stringWithFormat:@"%d", _pageSize];
    
    int commentcount = [_dataList count];
    SongComment *tempcomment = (commentcount > 0) ? [_dataList objectAtIndex:commentcount - 1] : nil;
    NSString *strFromId = (tempcomment) ? tempcomment.cid : @"0";
    
    _pageIndex = [strFromId intValue];
    
    [_miglabAPI doGetSongComment:userid token:accesstoken songid:songid count:strPageSize fromid:strFromId];
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    
    [[PPlayerManagerCenter GetInstance] doInsertPlay:_song];
    
}

-(IBAction)doCollectedOrCancel:(id)sender{
    
    PLog(@"doCollect...");
    /*
    UserSessionManager *userSessionManager = [UserSessionManager GetInstance];
    if (userSessionManager.isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *songid = [NSString stringWithFormat:@"%lld", currentSong.songid];
        NSString *moodid = [NSString stringWithFormat:@"%d", userSessionManager.currentUserGene.mood.typeid];
        NSString *typeid = [NSString stringWithFormat:@"%d", userSessionManager.currentUserGene.type.typeid];
        
        int isLike = [currentSong.like intValue];
        if (isLike > 0) {
            [_miglabAPI doDeleteCollectedSong:userid token:accesstoken songid:songid];
        } else {
            [_miglabAPI doCollectSong:userid token:accesstoken sid:songid modetype:moodid typeid:typeid];
        }
        
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    */
}

-(IBAction)doHate:(id)sender{
    
    PLog(@"doDelete...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        Song *currentSong = [PPlayerManagerCenter GetInstance].currentSong;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *userid = [UserSessionManager GetInstance].userid;
        [_miglabAPI doHateSong:userid token:accesstoken sid:currentSong.songid];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    
}

-(IBAction)doShare:(id)sender{
    
    PLog(@"doShare...");
    
}

-(IBAction)doCommentSong:(id)sender{
    
    NSString *commentcontent = _commentInputView.commentTextField.text;
    PLog(@"commentcontent: %@", commentcontent);
    
    if ([NSString checkDataIsNull:commentcontent] == nil) {
        [SVProgressHUD showErrorWithStatus:@"亲，您忘记输入内容咯～"];
        return;
    }
    
    if ([UserSessionManager GetInstance].isLoggedIn && commentcontent.length >= 1) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString *songid = [NSString stringWithFormat:@"%lld", _song.songid];
        
        
        [_miglabAPI doCommentSong:userid token:accesstoken songid:songid comment:commentcontent];
        
    }
    
    _commentInputView.commentTextField.text = @"";
    [_commentInputView.commentTextField resignFirstResponder];
    
}

-(IBAction)doHideKeyboard:(id)sender{
    
    [self autoMovekeyBoard:0];
    
}

#pragma notification

-(void)getCommentListFailed:(NSNotification *)tNotification{
    
    PLog(@"getCommentListFailed...");
    
    [SVProgressHUD showErrorWithStatus:@"歌曲评论信息获取失败:("];
    
}

-(void)getCommentListSuccess:(NSNotification *)tNotification{
    
    PLog(@"getCommentListSuccess...");
    
    NSDictionary *result = [tNotification userInfo];
    NSArray *commentlist = [result objectForKey:@"result"];
    int commentlistcount = [commentlist count];
    
    _isLoadMore = (commentlistcount == _pageSize);
    
    if (commentlistcount > 0) {
        
        for (int i=0; i<commentlistcount; i++) {
            
            SongComment *tempcomment = [commentlist objectAtIndex:i];
            [tempcomment log];
            
        }
        
        if (_pageIndex == 0) {
            [_dataList removeAllObjects];
        }
        
        [_dataList addObjectsFromArray:commentlist];
        [_dataTableView reloadData];
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
    
    static NSString *CellIdentifier = @"MusicCommentCell";
	MusicCommentCell *cell = (MusicCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentCell" owner:self options:nil];
        cell = (MusicCommentCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    SongComment *tempcomment = [_dataList objectAtIndex:indexPath.row];
    cell.btnAvatar.imageURL = [NSURL URLWithString:tempcomment.user.head];
    cell.lblNickname.text = tempcomment.user.nickname ? tempcomment.user.nickname: @"未知用户";
    cell.lblNickname.font = [UIFont fontOfApp:17.0f];
    
    NSString* tempnickname = cell.lblNickname.text;
    CGSize size = CGSizeMake(73, 21);
    CGRect orgPos = cell.lblNickname.frame;
    CGSize nicknamesize = [tempnickname sizeWithFont:cell.lblNickname.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    [cell.lblNickname setFrame:CGRectMake(orgPos.origin.x, orgPos.origin.y, nicknamesize.width, nicknamesize.height)];
    
    if (tempcomment.user.gender > 0) {
        cell.genderImageView.image = [UIImage imageWithName:@"user_gender_male" type:@"png"];
    } else {
        cell.genderImageView.image = [UIImage imageWithName:@"user_gender_female" type:@"png"];
    }
    cell.genderImageView.frame = CGRectMake(orgPos.origin.x + nicknamesize.width + 5, 12, 12, 12);
    
    cell.lblTime.text = tempcomment.createdtime;
    cell.lblTime.font = [UIFont fontOfApp:10.0f];
    cell.lblContent.text = tempcomment.text;
    cell.lblContent.font = [UIFont fontOfApp:13.0f];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        //textfield移动高度
        CGRect textFrame = textField.frame;
        float height = textFrame.origin.y - 49;
        
        //nav
        CGRect navViewFrame = self.navView.frame;
        float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
        CGRect bodyFrame = _bodyView.frame;
        bodyFrame.origin.y = posy + 10 - height;
        _bodyView.frame = bodyFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    [self scrollTableToFoot:YES];
}

-(IBAction)resiginTextField:(id)sender{
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    CGRect bodyFrame = _bodyView.frame;
    bodyFrame.origin.y = posy + 10;
    _bodyView.frame = bodyFrame;
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_dataTableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_dataTableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [_dataTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

#pragma mark -
#pragma mark Responding to keyboard events
- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self autoMovekeyBoard:keyboardRect.size.height];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    
    [self autoMovekeyBoard:0];
}

-(void) autoMovekeyBoard: (float) h{
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        //nav
        CGRect navViewFrame = self.navView.frame;
        float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
        CGRect bodyFrame = _bodyView.frame;
        bodyFrame.origin.y = posy + 10 - h;
        _bodyView.frame = bodyFrame;
        
        _commentInputView.frame = CGRectMake(0.0f, (float)(kMainScreenHeight-h-29), 320.0f, 49.0f);
        
    } completion:^(BOOL finished) {
        
    }];
    
    
    
}

@end
