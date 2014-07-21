//
//  MessageViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageInfoCell.h"
#import "MessageInfo.h"
#import "FriendOfReceiveHiViewController.h"
#import "FriendOfReceiveMusicViewController.h"
#import "MyFriendPersonalPageViewController.h"
#import "ChatViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;
@synthesize userinfo = _userinfo;
@synthesize msgCurStartIndex = _msgCurStartIndex;
@synthesize isLoadingMsg = _isLoadingMsg;
@synthesize totalMsgCount = _totalMsgCount;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize reloading = _reloading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMessageSuccess:) name:NotificationNameGetPushMsgSuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadMessageFailed:) name:NotificationNameGetPushMsgFailed object:nil];
    }
    return self;
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetPushMsgSuccess object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetPushMsgFailed object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 初始化成员变量值
    _msgCurStartIndex = 0;
    _isLoadingMsg = NO;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"消息";
    
    //body
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(ORIGIN_X, posy + 10, ORIGIN_WIDTH, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 10 - BOTTOM_PLAYER_HEIGHT);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    
    // 初始化Headerview
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, 0 - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [_dataTableView addSubview:_refreshHeaderView];
    [_refreshHeaderView refreshLastUpdatedDate];
    
    [self.view addSubview:_dataTableView];
    
    //
    _datalist = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    // 清除消息数量显示
    UIApplication* application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

-(void)loadData {
    
    [self loadMessageFromDatabase];
    
    [self loadMessageFromServer:_msgCurStartIndex size:MSG_DISPLAY_COUNT];
}

-(void)loadMessageFromDatabase {
//
//    // test
//    MessageInfo *mi0 = [[MessageInfo alloc] init];
//    mi0.userInfo = [[NearbyUser alloc] init];
//    mi0.userInfo.nickname = @"liujun";
//    mi0.content = @"使对方看董翔是基佬~~~~~";
//    mi0.messagetype = 1;
//    mi0.userInfo.distance = 200.0;
//    mi0.userInfo.songname = @"老鼠爱西米";
//    [_datalist addObject:mi0];
//    
//    MessageInfo *mi1 = [[MessageInfo alloc] init];
//    mi1.userInfo = [[NearbyUser alloc] init];
//    mi1.userInfo.nickname = @"liujun";
//    mi1.content = @"你这首太难听了，和董翔一个品位";
//    mi1.messagetype = 3;
//    mi1.userInfo.distance = 1000000.0;
//    mi1.userInfo.songname = @"董翔是坏蛋";
//    [_datalist addObject:mi1];
}

-(void)loadMessageFromServer:(int)startindex size:(int)tsize {
    
    if([UserSessionManager GetInstance].isLoggedIn && !_isLoadingMsg) {
        
        if (!_reloading) {
            
            [SVProgressHUD showWithStatus:MIGTIP_LOADING maskType:SVProgressHUDMaskTypeGradient];
        }
        
        _isLoadingMsg = YES;
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        NSString* szstart = [NSString stringWithFormat:@"%d", startindex];
        NSString* szsize = [NSString stringWithFormat:@"%d", tsize];
        
        [self.miglabAPI doGetPushMsg:userid token:accesstoken pageindex:szstart pagesize:szsize];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // ...
    MessageInfo *messageInfo = [_datalist objectAtIndex:indexPath.row];
    
    if (messageInfo.messagetype == 1) {
        
        // 打招呼
        FriendOfReceiveHiViewController *receiveHiViewController = [[FriendOfReceiveHiViewController alloc] initWithNibName:@"FriendOfReceiveHiViewController" bundle:nil];
        receiveHiViewController.msginfo = messageInfo;
        [self.navigationController pushViewController:receiveHiViewController animated:YES];
        
    } else if (messageInfo.messagetype == 2) {
        
        // 送歌
        FriendOfReceiveMusicViewController *receiveMusicViewController = [[FriendOfReceiveMusicViewController alloc] initWithNibName:@"FriendOfReceiveMusicViewController" bundle:nil];
        receiveMusicViewController.msginfo = messageInfo;
        [self.navigationController pushViewController:receiveMusicViewController animated:YES];
    } else if (messageInfo.messagetype == 3) {
        
        // 评论歌曲
        //MyFriendPersonalPageViewController* receiveMusicViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
        //receiveMusicViewController.userinfo = user;
        //[self.navigationController pushViewController:receiveMusicViewController animated:YES];
        
        // 聊天留言
        int currentUserId = [[UserSessionManager GetInstance].userid intValue];
        ChatViewController *chatController = [[ChatViewController alloc] init:nil uid:currentUserId tid:[messageInfo.send_uid intValue]];
        [self.navigationController pushViewController:chatController animated:YES];
        
    } else {
        
        [SVProgressHUD showErrorWithStatus:@"信息格式不正确, 无法显示"];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - notification

-(void)loadMessageSuccess:(NSNotification *)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NSMutableArray* messages = [result objectForKey:@"result"];
    
    // 如果curStartIndex是0，则表示第一次更新，或者选择了重新刷新，则删除所有数据，重新加载
    if (_msgCurStartIndex == 0) {
        
        [_datalist removeAllObjects];
    }
    
    [_datalist addObjectsFromArray:messages];
    [_dataTableView reloadData];
    
    _isLoadingMsg = NO;
    
    if (_reloading) {
        
        [self doneLoadingTableViewData];
    }
    
    [SVProgressHUD dismiss];
}

-(void)loadMessageFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD dismiss];
    
    //[SVProgressHUD showErrorWithStatus:@"附近的推送消息失败:("];
    
    if (_reloading) {
        
        [self doneLoadingTableViewData];
    }
    
    _isLoadingMsg = NO;
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_datalist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MessageInfoCell";
	MessageInfoCell *cell = (MessageInfoCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MessageInfoCell" owner:self options:nil];
        cell = (MessageInfoCell *)[nibContents objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
	}
    
    MessageInfo *messageInfo = [_datalist objectAtIndex:indexPath.row];
    [cell updateMessageInfoCellData:messageInfo];
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return CELL_HEIGHT;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
#if USE_NEW_LOAD
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
#endif
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
#if USE_NEW_LOAD
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
#else
    if (scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height) {
        
        // 没有加载消息，并且数量未加载完，则更新
        if (!_isLoadingMsg && (_msgCurStartIndex < _totalMsgCount)) {
            
            _msgCurStartIndex += MSG_DISPLAY_COUNT;
            [self loadMessageFromServer:_msgCurStartIndex size:MSG_DISPLAY_COUNT];
        }
    }
    else if(scrollView.contentOffset.y < 0) {
        
        if (!_isLoadingMsg) {
            
            _msgCurStartIndex = 0;
            [self loadMessageFromServer:_msgCurStartIndex size:MSG_DISPLAY_COUNT];
        }
    }
#endif
}

#if USE_NEW_LOAD

-(void)reloadTableViewDataSource {
    
    _reloading = YES;
    
    if (!_isLoadingMsg) {
        
        _msgCurStartIndex = 0;
        [self loadMessageFromServer:_msgCurStartIndex size:MSG_DISPLAY_COUNT];
    }
}

-(void)doneLoadingTableViewData {
    
    _reloading = NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.dataTableView];
}

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
    
    [self reloadTableViewDataSource];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
    
    return _reloading;
}

//-(NSData*)egoRefreshTableHeaderDataSourceLastUpdated:(

#endif

@end
