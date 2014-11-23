//
//  MyFriendViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MyFriendViewController.h"
#import "FriendInfoCell.h"
#import "PUser.h"
#import "FriendOfAddViewController.h"
#import "MyFriendPersonalPageViewController.h"

@interface MyFriendViewController ()

@end

@implementation MyFriendViewController

@synthesize searchView = _searchView;
@synthesize friendTableView = _friendTableView;
@synthesize friendList = _friendList;
@synthesize friendCurStartIndex = _friendCurStartIndex;
@synthesize isLoadingFriend = _isLoadingFriend;
@synthesize totalFriendCount = _totalFriendCount;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize refreshFooterView = _refreshFooterView;
@synthesize reloading = _reloading;
@synthesize isHeaderLoading = _isHeaderLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMusicUserSuccess:) name:NotificationNameGetMusicUserSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMusicUserFailed:) name:NotificationNameGetMusicUserFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetMusicUserSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetMusicUserFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _friendCurStartIndex = 0;
    _isLoadingFriend = NO;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"我的歌友";
    
//    UIImage *addFriendImage = [UIImage imageWithName:@"friend_button_add" type:@"png"];
//    [self.navView.rightButton setBackgroundImage:addFriendImage forState:UIControlStateNormal];
//    self.navView.rightButton.frame = CGRectMake(268, 7.5 + self.topDistance, 48, 29);
//    [self.navView.rightButton setHidden:NO];
//    [self.navView.rightButton addTarget:self action:@selector(doAddFriend:) forControlEvents:UIControlEventTouchUpInside];
//    
//    //search view
//    NSArray *searchNib = [[NSBundle mainBundle] loadNibNamed:@"FriendSearchView" owner:self options:nil];
//    for (id oneObject in searchNib){
//        if ([oneObject isKindOfClass:[FriendSearchView class]]){
//            _searchView = (FriendSearchView *)oneObject;
//        }//if
//    }//for
//    _searchView.frame = CGRectMake(11.5, posy + 10, 297, 44);
//    _searchView.searchTextField.delegate = self;
//    [_searchView.btnSearch addTarget:self action:@selector(doSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_searchView];
//    
    //search result view
    _friendTableView = [[UITableView alloc] init];
    _friendTableView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    _friendTableView.dataSource = self;
    _friendTableView.delegate = self;
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10 + 44 + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 44 - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _friendTableView.backgroundView = bodyBgImageView;
    
    // 初始化Headerview
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height) IsHeader:YES];
    _refreshHeaderView.delegate = self;
    [_friendTableView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    
    // 初始化footerView
    _refreshFooterView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -1000, self.view.bounds.size.width, self.view.bounds.size.height) IsHeader:NO];
    _refreshFooterView.delegate = self;
    [_friendTableView addSubview:_refreshFooterView];
    [self putFooterToEnd];
    
    [self.view addSubview:_friendTableView];
    
    //
    _friendList = [[NSMutableArray alloc] init];
    
    [self loadData];
    
}

-(void)loadData {
    
    [self loadMusicUserFromDatabase];
    [self loadMusicUserFromServer:_friendCurStartIndex size:FRIEND_DISPLAY_COUNT];
}

-(void)loadMusicUserFromDatabase {
//    
//    //test data
//    NearbyUser *testfriend = [[NearbyUser alloc] init];
//    testfriend.nickname = @"猫王爱淘汰";
//    testfriend.songname = @"机器猫";
//    testfriend.sex = @"1";
//    testfriend.distance = 423472;
//    [_friendList addObject:testfriend];
//    
//    NearbyUser *testfriend1 = [[NearbyUser alloc] init];
//    testfriend1.nickname = @"乐瑟乐瑟";
//    testfriend1.distance = 90;
//    testfriend1.sex = @"0";
//    testfriend1.songname = @"真的想睡觉";
//    [_friendList addObject:testfriend1];
}

-(void)loadMusicUserFromServer:(int)start size:(int)tsize {
    
    if ([UserSessionManager GetInstance].isLoggedIn && !_isLoadingFriend) {
        
        if (!_reloading) {
            
            [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeGradient];
        }
        
        _isLoadingFriend = YES;
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString* szstart = [NSString stringWithFormat:@"%d", start];
        NSString* szsize = [NSString stringWithFormat:@"%d", tsize];
        
        [self.miglabAPI doGetMusicUser:userid token:accesstoken fromid:szstart count:szsize];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}

#pragma mark - notification

-(void)getMusicUserFailed:(NSNotification *)tNotification {
    
    PLog(@"get music user failed");
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:MIGTIP_NO_FRIENDS];
    _isLoadingFriend = NO;
    
    if (_reloading) {
        
        if (_isHeaderLoading) {
            
            [self finishLoadMoreHeaderData];
        }
        else {
            
            [self finishLoadMoreFooterData];
        }
    }
}

-(void)getMusicUserSuccess:(NSNotification *)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NSMutableArray* userList = [result objectForKey:@"result"];
    
    int userlistcount = [userList count];
    
    if (_friendCurStartIndex == 0) {
        
        [_friendList removeAllObjects];
    }
    
    if (userlistcount > 0) {
        
        for (int i=0; i<userlistcount; i++) {
            
            MessageInfo* nms = [userList objectAtIndex:i];
            NearbyUser* user = nms.userInfo;
            user.songname = nms.song.songname;
            
            [_friendList addObject:user];
        }
        
        _friendCurStartIndex += userlistcount;
        
        [_friendTableView reloadData];
    }
    
    _isLoadingFriend = NO;
    
    if (_reloading) {
        
        if (_isHeaderLoading) {
            
            [self finishLoadMoreHeaderData];
        }
        else {
            
            [self finishLoadMoreFooterData];
        }
    }
    
    [self putFooterToEnd];
    
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doAddFriend:(id)sender{
    
    PLog(@"doAddFriend...");
    
    FriendOfAddViewController *addViewController = [[FriendOfAddViewController alloc] initWithNibName:@"FriendOfAddViewController" bundle:nil];
    [self.navigationController pushViewController:addViewController animated:YES];
    
}

-(IBAction)doSearch:(id)sender{
    
    PLog(@"doSearch...");
    
    [_searchView.btnSearch resignFirstResponder];
    
}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    PLog(@"textFieldDidBeginEditing...");
    
}

#pragma mark - UITableView delegate

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    NearbyUser* user = [_friendList objectAtIndex:indexPath.row];
    
    MyFriendPersonalPageViewController *personalPageViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
    personalPageViewController.userinfo = user;
    personalPageViewController.isFriend = YES;
    [self.navigationController pushViewController:personalPageViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FriendInfoCell";
	FriendInfoCell *cell = (FriendInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FriendInfoCell" owner:self options:nil];
        cell = (FriendInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    NearbyUser *tempfriend = [_friendList objectAtIndex:indexPath.row];
    [cell updateFriendInfoCellData:tempfriend];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
#if USE_NEW_LOAD
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
    if (_friendCurStartIndex >= _totalFriendCount - 1) {
        return;
    }
    
    [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    
#else
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        
        if (!_isLoadingFriend && (_friendCurStartIndex < _totalFriendCount)) {
            
            _friendCurStartIndex += FRIEND_DISPLAY_COUNT;
            [self loadMusicUserFromServer:_friendCurStartIndex size:FRIEND_DISPLAY_COUNT];
        }
    }
    else if(scrollView.contentOffset.y < 0) {
        
        if (!_isLoadingFriend) {
            
            _friendCurStartIndex = 0;
            [self loadMusicUserFromServer:_friendCurStartIndex size:FRIEND_DISPLAY_COUNT];
        }
    }
#endif
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
#if USE_NEW_LOAD
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    if (_friendCurStartIndex >= _totalFriendCount - 1) {
        return;
    }
    [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
#endif
}

#if USE_NEW_LOAD

-(void)putFooterToEnd {
    
    CGRect footerFrame = _refreshFooterView.frame;
    CGRect r = CGRectMake(footerFrame.origin.x, _friendTableView.contentSize.height, _friendTableView.frame.size.width, footerFrame.size.height);
    
    if (r.origin.y < _friendTableView.frame.size.height) {
        
        r.origin.y = _friendTableView.frame.size.height;
    }
    
    _refreshFooterView.frame = r;
}

-(void)reloadTableViewHeaderDataSource {
    
    if (!_isLoadingFriend) {
        
        _reloading = YES;
        
        _friendCurStartIndex = 0;
        [self loadMusicUserFromServer:_friendCurStartIndex size:FRIEND_DISPLAY_COUNT];
    }
}

-(void)reloadTableViewFooterDataSource {
    
    if (!_isLoadingFriend && (_friendCurStartIndex < _totalFriendCount)) {
        
        _reloading = YES;
        
        // 只有真正返回成功之后再加到startindex上面
        //_friendCurStartIndex += FRIEND_DISPLAY_COUNT;
        [self loadMusicUserFromServer:_friendCurStartIndex size:(_friendCurStartIndex + FRIEND_DISPLAY_COUNT)];
    }
}

-(void)finishLoadMoreHeaderData {
    
    _reloading = NO;
    
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.friendTableView];
}

-(void)finishLoadMoreFooterData {
    
    _reloading = NO;
    
    [self putFooterToEnd];
    
    // TODO:定位到最后一列
    
    [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:_friendTableView];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    
    if (view == _refreshHeaderView) {
        
        _isHeaderLoading = YES;
        [self reloadTableViewHeaderDataSource];
    }
    else if (view == _refreshFooterView) {
        
        _isHeaderLoading = NO;
        [self reloadTableViewFooterDataSource];
    }
    else {
        
        _isHeaderLoading = NO;
    }
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    
    return _reloading;
}

//-(NSData*)egoRefreshTableHeaderDataSourceLastUpdated:(

#endif


@end
