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

@interface MessageViewController ()

@end

@implementation MessageViewController

@synthesize dataTableView = _dataTableView;
@synthesize datalist = _datalist;
@synthesize userinfo = _userinfo;

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
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-45, ios7-65
    
    //nav bar
    self.navView.titleLabel.text = @"消息";
    
    //body
    _dataTableView = [[UITableView alloc] init];
    _dataTableView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.backgroundColor = [UIColor clearColor];
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 - 10);
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    _dataTableView.backgroundView = bodyBgImageView;
    [self.view addSubview:_dataTableView];
    
    //
    _datalist = [[NSMutableArray alloc] init];
    
    [self loadMessageFromServer];
    
    //
    MessageInfo *mi0 = [[MessageInfo alloc] init];
    mi0.userInfo = [[NearbyUser alloc] init];
    mi0.userInfo.nickname = @"liujun";
    mi0.content = @"使对方看董翔是基佬~~~~~";
    mi0.messagetype = 1;
    [_datalist addObject:mi0];
    
    MessageInfo *mi1 = [[MessageInfo alloc] init];
    mi1.userInfo = [[NearbyUser alloc] init];
    mi1.userInfo.nickname = @"liujun";
    mi1.content = @"你这首太难听了，和董翔一个品位";
    mi1.messagetype = 3;
    [_datalist addObject:mi1];
    
}

-(void)loadMessageFromServer {
    
    if([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString* userid = [UserSessionManager GetInstance].userid;
        NSString* accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doGetPushMsg:userid token:accesstoken pageindex:@"0" pagesize:@"10"];
    }
    else {
        
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
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
    NearbyUser* user = messageInfo.userInfo;
    
    if (messageInfo.messagetype == 1 || messageInfo.messagetype == 3) {
        // 打招呼
        FriendOfReceiveHiViewController *receiveHiViewController = [[FriendOfReceiveHiViewController alloc] initWithNibName:@"FriendOfReceiveHiViewController" bundle:nil];
        receiveHiViewController.msginfo = messageInfo;
        [self.navigationController pushViewController:receiveHiViewController animated:YES];
        
//    } else if (messageInfo.messagetype == 3) {
//        // 评论歌曲
//        MyFriendPersonalPageViewController* receiveMusicViewController = [[MyFriendPersonalPageViewController alloc] initWithNibName:@"MyFriendPersonalPageViewController" bundle:nil];
//        receiveMusicViewController.userinfo = user;
//        [self.navigationController pushViewController:receiveMusicViewController animated:YES];
        
    } else if (messageInfo.messagetype == 2) {
        // 送歌
        
        //        FriendOfReceiveMusicViewController *receiveMusicViewController = [[FriendOfReceiveMusicViewController alloc] initWithNibName:@"FriendOfReceiveMusicViewController" bundle:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - notification

-(void)loadMessageSuccess:(NSNotification *)tNotification {
    
    NSDictionary* result = [tNotification userInfo];
    NSMutableArray* messages = [result objectForKey:@"result"];
    
    [_datalist addObjectsFromArray:messages];
    [_dataTableView reloadData];
}

-(void)loadMessageFailed:(NSNotification *)tNotification {
    
    [SVProgressHUD showErrorWithStatus:@"附近的推送消息失败:("];
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
    NSString* username = messageInfo.userInfo.nickname;
    
    if(messageInfo.messagetype == 2) {
        
        cell.lblMessageType.text = [NSString stringWithFormat:@"%@送了一首歌曲给你", username];
    }
    else if(messageInfo.messagetype == 3) {
        
        cell.lblMessageType.text = [NSString stringWithFormat:@"%@评论了你个歌曲", username];
    }
    else {
        
        cell.lblMessageType.text = [NSString stringWithFormat:@"%@给你打了一个招呼", username];
    }
    
    cell.lblContent.text = messageInfo.content;
    
    NSLog(@"cell.frame.size.height: %f", cell.frame.size.height);
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

@end
