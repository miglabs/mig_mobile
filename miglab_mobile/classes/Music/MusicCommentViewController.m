//
//  MusicCommentViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-21.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicCommentViewController.h"
#import "MusicCommentCell.h"

@interface MusicCommentViewController ()

@end

@implementation MusicCommentViewController

@synthesize navView = _navView;
@synthesize commentPlayerView = _commentPlayerView;

@synthesize commentTableView = _commentTableView;
@synthesize commentList = _commentList;

@synthesize commentInputView = _commentInputView;

@synthesize song = _song;

@synthesize miglabAPI = _miglabAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"当前评论歌曲" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(4, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //body
    //player
    NSArray *commentPlayerNib = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentPlayerView" owner:self options:nil];
    for (id oneObject in commentPlayerNib){
        if ([oneObject isKindOfClass:[MusicCommentPlayerView class]]){
            _commentPlayerView = (MusicCommentPlayerView *)oneObject;
        }//if
    }//for
    _commentPlayerView.frame = CGRectMake(11.5, 45 + 10, 297, 110);
    [self.view addSubview:_commentPlayerView];
    
    _commentPlayerView.btnAvatar.layer.cornerRadius = 38;
    _commentPlayerView.btnAvatar.layer.masksToBounds = YES;
    _commentPlayerView.btnAvatar.imageURL = [NSURL URLWithString:_song.coverurl];
    _commentPlayerView.lblSongName.text = _song.songname;
    _commentPlayerView.lblSongArtist.text = _song.artist;
    [_commentPlayerView.btnPlayOrPause addTarget:self action:@selector(doPlayOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [_commentPlayerView.btnCollect addTarget:self action:@selector(doCollectedOrCancel:) forControlEvents:UIControlEventTouchUpInside];
    [_commentPlayerView.btnDelete addTarget:self action:@selector(doHate:) forControlEvents:UIControlEventTouchUpInside];
    [_commentPlayerView.btnShare addTarget:self action:@selector(doShare:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //song list
    _commentTableView = [[UITableView alloc] init];
    _commentTableView.frame = CGRectMake(11.5, 45 + 10 + 110 + 10, 297, kMainScreenHeight - 45 - 10 - 110 - 10 - 10 - 49);
    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    _commentTableView.backgroundColor = [UIColor clearColor];
    _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = _commentTableView.frame;
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _commentTableView.backgroundView = bodyBgImageView;
    
    [self.view addSubview:_commentTableView];
    
    
    //comment input view
    NSArray *commentinputNib = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentInputView" owner:self options:nil];
    for (id oneObject in commentinputNib){
        if ([oneObject isKindOfClass:[MusicCommentInputView class]]){
            _commentInputView = (MusicCommentInputView *)oneObject;
        }//if
    }//for
    _commentInputView.frame = CGRectMake(0, kMainScreenHeight - 49, kMainScreenWidth, 49);
    _commentInputView.commentTextField.delegate = self;
    [self.view addSubview:_commentInputView];
    
    //
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doPlayOrPause:(id)sender{
    
    PLog(@"doPlayOrPause...");
    
    [[PPlayerManagerCenter GetInstance] doInsertPlay:_song];
    
}

-(IBAction)doCollectedOrCancel:(id)sender{
    
    PLog(@"doCollect...");
    
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

-(IBAction)doHideKeyboard:(id)sender{
    
    [self autoMovekeyBoard:0];
    
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_commentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicCommentCell";
	MusicCommentCell *cell = (MusicCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MusicCommentCell" owner:self options:nil];
        cell = (MusicCommentCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    _commentTableView.frame = CGRectMake(0, 0, 320, kMainScreenHeight - 210);
    [self scrollTableToFoot:YES];
}

-(IBAction)resiginTextField:(id)sender{
    _commentTableView.frame = CGRectMake(0, 20, 320, kMainScreenHeight);
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_commentTableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_commentTableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [_commentTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
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
    
	_commentInputView.frame = CGRectMake(0.0f, (float)(kMainScreenHeight-h-49), 320.0f, 49.0f);
	_commentTableView.frame = CGRectMake(0.0f, 44.0f, 320.0f,(float)(kMainScreenHeight-h-44-49));
    
}

@end
